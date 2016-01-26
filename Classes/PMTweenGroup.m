//
//  PMTweenGroup.m
//  PMTween
//
//  Created by Brett Walker on 4/4/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenGroup.h"
#import "PMTweenCATempo.h"
#import "PMTweenSupport.h"

@interface PMTweenGroup ()

// An array of Boolean values representing whether a tween should 'override' the group tempo and use its own instead.
// Each array position corresponds to the tween objects in the `tweens` array.
@property (nonatomic, strong) NSMutableArray *tempoOverrides;

// The number of tween objects which have completed their tween operations.
@property (nonatomic, assign) NSUInteger tweenCompleteCount;

// The number of tween objects which have finished one direction of a reversing tween.
// Used to sync tween operations while reversing and syncReversing are both set to `YES`.
@property (nonatomic, assign) NSUInteger tweenReverseCount;

// The starting time of the current tween's delay. A value of 0 means that no tween is currently in progress.
@property (nonatomic, assign) NSTimeInterval startTime;

// The most recent update timestamp, as sent by `updateWithTimeInterval:currentTime:`.
@property (nonatomic, assign) NSTimeInterval currentTime;

// The ending time of the delay, which is determined by adding the delay to the starting time.
@property (nonatomic, assign) NSTimeInterval endTime;

// Starts the group's next repeat cycle, if there is one.
- (void)nextRepeatCycle;

// Reverses the tweening direction of the group.
- (void)reverseTweenDirection;

// Called when all tween objects in the group have completed their tween operations.
- (void)groupCompleted;

// Handler for `PMTweenDidCompleteNotification` notifications from tween objects in the group.
- (void)tweenCompleteNotification:(NSNotification *)notification;

// Handler for `PMTweenHalfCompletedNotification` notifications from tween objects in the group.
- (void)tweenHalfCompleteNotification:(NSNotification *)notification;

// Resets the group to its initial tween state.
- (void)resetTween;

@end

@implementation PMTweenGroup

#pragma mark - Lifecycle methods

- (instancetype)init {
    
    if (self = [super init]) {
        _tweens = [NSMutableArray array];
        _tempoOverrides = [NSMutableArray array];
        _tweenState = PMTweenStateStopped;
        _tweenDirection = PMTweenDirectionForward;
        _syncTweensWhenReversing = YES;
        
        self.tempo = [PMTweenCATempo tempo];

    }
    
    return self;
    
}


- (instancetype)initWithTweens:(NSArray *)tweens options:(PMTweenOptions)options {
    
    if (self = [self init]) {
        for (id obj in tweens) {
            [self addTween:obj useTweenTempo:NO];
        }
        
        if (options & PMTweenOptionRepeat) {
            self.repeating = YES;
        }
        if (options & PMTweenOptionReverse) {
            self.reversing = YES;
        }
        
        self.tempo = [PMTweenCATempo tempo];

    }
    
    return self;
}

- (void)dealloc {
    if (_tempo) {
        _tempo.delegate = nil;
    }
    
    // remove all listeners of tween objects
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _tweens = nil;
}


#pragma mark - Initialization methods

- (void)addTween:(NSObject<PMTweening> *)tween {
    
    [self addTween:tween useTweenTempo:NO];
}


- (void)addTween:(NSObject<PMTweening> *)tween useTweenTempo:(BOOL)useTweenTempo {
    
    if ([tween conformsToProtocol:@protocol(PMTweening)]) {
        [_tweens addObject:tween];
        [_tempoOverrides addObject:@(useTweenTempo)];
        
        if (_reversing) {
            tween.reversing = YES;
        }
        
        if (!useTweenTempo) {
            tween.tempo = nil;
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweenCompleteNotification:) name:PMTweenDidCompleteNotification object:tween];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweenHalfCompleteNotification:) name:PMTweenHalfCompletedNotification object:tween];
    } else {
        NSAssert(0, @"NSObject class does not conform to PMTweening protocol.");
    }
}


- (void)addTweens:(NSArray *)tweens {
    
    for (id obj in tweens) {
        [self addTween:obj useTweenTempo:NO];
    }
}


- (void)removeTween:(NSObject<PMTweening> *)tween {
    NSUInteger index = [self.tweens indexOfObject:tween];
    if (index != NSNotFound) {
        [_tweens removeObject:tween];
        [_tempoOverrides removeObjectAtIndex:index];
    
        [[NSNotificationCenter defaultCenter] removeObserver:self name:PMTweenDidCompleteNotification object:tween];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:PMTweenHalfCompletedNotification object:tween];
    }
}


#pragma mark - Tween methods

- (void)nextRepeatCycle {

    if (++self.cyclesCompletedCount - 1 < _numberOfRepeats) {
        self.tweenCompleteCount = 0;
        self.startTime = 0;
        
        // call cycle block
        if (_repeatCycleBlock) {
            __weak typeof(self) block_self = self;
            self.repeatCycleBlock(block_self);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidRepeatNotification object:self userInfo:nil];
        
        // restart tweens for another cycle
        for (NSObject<PMTweening> *tween in _tweens) {
            [tween startTween];
        }

    } else {
        [self groupCompleted];
    }
}


- (void)reverseTweenDirection {
    
    if (_tweenDirection == PMTweenDirectionForward) {
        self.tweenDirection = PMTweenDirectionReverse;
        
    } else if (_tweenDirection == PMTweenDirectionReverse) {
        self.tweenDirection = PMTweenDirectionForward;
    }
    
    self.tweenReverseCount = 0;
    
    // resume any paused tweens
    for (NSObject<PMTweening> *tween in _tweens) {
        [tween resumeTween];
    }
    
    
    // call reverse block
    if (_reverseBlock) {
        __weak typeof(self) block_self = self;
        self.reverseBlock(block_self);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidReverseNotification object:self userInfo:nil];
    
    // send out 50% complete notification, used by PMTweenSequence in contiguous mode
    if (_tweenDirection == PMTweenDirectionReverse) {
        NSUInteger half_complete = round(_numberOfRepeats / 2);
        
        if (_cyclesCompletedCount == half_complete) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenHalfCompletedNotification object:self userInfo:nil];
            
        }
    }
    
}


- (void)groupCompleted {

    self.tweenState = PMTweenStateStopped;

    // call update block
    if (_updateBlock) {
        __weak typeof(self) block_self = self;
        self.updateBlock(block_self);
    }
    
    // call complete block
    if (_completeBlock) {
        __weak typeof(self) block_self = self;
        self.completeBlock(block_self);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidCompleteNotification object:self userInfo:nil];
    
}


- (void)resetTween {
    self.tweenState = PMTweenStateStopped;
    self.tweenCompleteCount = 0;
    self.cyclesCompletedCount = 0;
    self.tweenDirection = PMTweenDirectionForward;
    self.tweenReverseCount = 0;
    self.startTime = 0;
}


#pragma mark - Getter/setters

- (PMTweenTempo *)tempo {
    return _tempo;
}

- (void)setTempo:(PMTweenTempo *)tempo {
    
    // if there's a current tempo, first remove the tempo's delegate before removing its reference
    if (_tempo) {
        _tempo.delegate = nil;
        _tempo = nil;
    }
    
    if (tempo) {
        _tempo = tempo;
        _tempo.delegate = self;
        
        // delete tempos on tweens that were not specified to override the group tempo
        __weak typeof(self) weak_self = self;
        [self.tweens enumerateObjectsUsingBlock:^(NSObject<PMTweening> *tween, NSUInteger idx, BOOL *stop) {
            __strong typeof(self) strong_self = weak_self;
            if (![(NSNumber *)strong_self.tempoOverrides[idx] boolValue]) {
                tween.tempo = nil;
            }
        }];
    }
    
    
}

- (void)setTweens:(NSMutableArray *)tweens {
    _tweens = tweens;
}

- (void)setTweenState:(PMTweenState)tweeningState {
    _tweenState = tweeningState;
}

- (void)setTweenDirection:(PMTweenDirection)tweenDirection {
    _tweenDirection = tweenDirection;
}

- (void)setCyclesCompletedCount:(NSUInteger)cyclesCompleted {
    _cyclesCompletedCount = cyclesCompleted;
}

- (BOOL)isRepeating {
    return _repeating;
}

- (void)setRepeating:(BOOL)repeating {
    _repeating = repeating;
}


- (void)setNumberOfRepeats:(NSUInteger)numberOfRepeats {
    _numberOfRepeats = (numberOfRepeats > 0) ? numberOfRepeats : 0; // clamps negative values to 0
}

- (BOOL)isReversing {
    return _reversing;
}

/*
 *  PMTweenGroup implements reversing by activating reversing for each of its tween objects. Important: the previous state of reversing on any tween objects will be overridden by this assignment! Setting this property to `YES` will not post `PMTweenDidReverseNotification` notifications unless the `syncTweensWhenReversing` property is also set to `YES`. Please check out the docs for that property, as it alters reversing behavior for PMTweenGroup in significant ways.
 */
- (void)setReversing:(BOOL)reversing {
    
    _reversing = reversing;
    
    // change the reversing property on each tween object to reflect the group's new state
    for (NSObject<PMTweening> *tween in _tweens) {
        tween.reversing = reversing;
    }
    
    _tweenReverseCount = 0;
}

#pragma mark - Notification methods

- (void)tweenCompleteNotification:(NSNotification *)notification {

    if (++_tweenCompleteCount >= [_tweens count]) {
        if (self.repeating) {
            [self nextRepeatCycle];
        } else {
            [self groupCompleted];
        }
    }
    
}

- (void)tweenHalfCompleteNotification:(NSNotification *)notification {

    if (self.reversing) {
        if (++_tweenReverseCount >= [_tweens count] && self.syncTweensWhenReversing) {
            [self reverseTweenDirection];
            
        } else if (self.syncTweensWhenReversing) {
            // pause this tween until all of the group's tweens are ready to reverse
            NSObject<PMTweening> *tween = notification.object;
            [tween pauseTween];
        }
    }
    
}


#pragma mark - PMTweenTempoDelegate methods

- (void)tempoBeatWithTimestamp:(NSTimeInterval)timestamp {
    
    [self updateWithTimeInterval:timestamp];
    
}


#pragma mark - PMTweening methods

- (void)updateWithTimeInterval:(NSTimeInterval)currentTime {

    _currentTime = currentTime;

    if (_tweenState == PMTweenStateTweening) {
        __weak typeof(self) weak_self = self;

        [self.tweens enumerateObjectsUsingBlock:^(NSObject<PMTweening> *tween, NSUInteger idx, BOOL *stop) {
            __strong typeof(self) strong_self = weak_self;

            // only call tempo update on tweens that were not specified to override
            if (![(NSNumber *)strong_self.tempoOverrides[idx] boolValue]) {
                [tween updateWithTimeInterval:currentTime];
            }

        }];
        
        // call update block, but only if we're still tweening
        if (_updateBlock && _tweenState == PMTweenStateTweening) {
            __weak typeof(self) block_self = self;
            self.updateBlock(block_self);
        }
        
    } else if (_tweenState == PMTweenStateDelayed) {
        
        if (_startTime == 0) {
            // a start time of 0 means we need to initialize the tween times
            self.startTime = currentTime;
            self.endTime = _startTime + _delay;
        }
        
        if (_currentTime >= self.endTime) {
            // delay is done, time to tween
            self.tweenState = PMTweenStateTweening;
            
            for (NSObject<PMTweening> *tween in _tweens) {
                [tween startTween];
            }
            
            // call start block
            if (_startBlock) {
                __weak typeof(self) block_self = self;
                self.startBlock(block_self);
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidStartNotification object:self userInfo:nil];
        }
        
    }
    
}


- (void)startTween {

    if (_tweenState == PMTweenStateStopped) {
        [self resetTween];
        
        if (_delay == 0) {
            self.tweenState = PMTweenStateTweening;

            for (NSObject<PMTweening> *tween in _tweens) {
                [tween startTween];
            }
            
            // call start block
            if (_startBlock) {
                __weak typeof(self) block_self = self;
                self.startBlock(block_self);
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidStartNotification object:self userInfo:nil];
            
        } else {
            self.tweenState = PMTweenStateDelayed;
        }
        
    }

}

- (void)stopTween {
    if (_tweenState == PMTweenStateTweening || _tweenState == PMTweenStatePaused || _tweenState == PMTweenStateDelayed) {
        self.tweenState = PMTweenStateStopped;
        
        for (NSObject<PMTweening> *tween in _tweens) {
            [tween stopTween];
        }
        
        // call stop block
        if (_stopBlock) {
            __weak typeof(self) block_self = self;
            self.stopBlock(block_self);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidStopNotification object:self userInfo:nil];

    }
    
}

- (void)pauseTween {
    if (_tweenState == PMTweenStateTweening) {
        self.tweenState = PMTweenStatePaused;
        
        for (NSObject<PMTweening> *tween in _tweens) {
            [tween pauseTween];
        }
        
        // call pause block
        if (_pauseBlock) {
            __weak typeof(self) block_self = self;
            self.pauseBlock(block_self);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidPauseNotification object:self userInfo:nil];

    }
    
}

- (void)resumeTween {

    if (_tweenState == PMTweenStatePaused) {
        self.tweenState = PMTweenStateTweening;
        
        for (NSObject<PMTweening> *tween in _tweens) {
            [tween resumeTween];
        }
        
        // call resume block
        if (_resumeBlock) {
            __weak typeof(self) block_self = self;
            self.resumeBlock(block_self);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidResumeNotification object:self userInfo:nil];

    }
}


@end
