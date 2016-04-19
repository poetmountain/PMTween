//
//  PMTweenSequence.m
//  PMTween
//
//  Created by Brett Walker on 4/9/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenSequence.h"
#import "PMTweenCATempo.h"
#import "PMTweenSupport.h"

NSString *const PMTweenDidStepNotification = @"com.poetmountain.pmtween.step";

@interface PMTweenSequence ()

// An array of Boolean values representing whether a tween should 'override' the group tempo and use its own instead.
// Each array position corresponds to the tween objects in the `tweens` array.
@property (nonatomic, strong) NSMutableArray *tempoOverrides;

// An integer representing the position of the current sequence step.
@property (nonatomic, assign) NSInteger currentSequenceIndex;

// The number of tween objects which have finished one direction of a reversing tween.
// Used to sync tween operations while reversing and syncReversing are both set to `YES`.
@property (nonatomic, assign) NSUInteger tweenReverseCount;

// The starting time of the current tween's delay. A value of 0 means that no tween is currently in progress.
@property (nonatomic, assign) NSTimeInterval startTime;

// The most recent update timestamp, as sent by `updateWithTimeInterval:currentTime:`.
@property (nonatomic, assign) NSTimeInterval currentTime;

// The ending time of the delay, which is determined by adding the delay to the starting time.
@property (nonatomic, assign) NSTimeInterval endTime;

// Starts the next sequence step, if there is one.
- (void)nextSequenceStep;

// Starts the sequence's next repeat cycle, if there is one.
- (void)nextRepeatCycle;

// Reverses the tweening direction of the group.
- (void)reverseTweenDirection;

// Called when the sequence has completed.
- (void)sequenceCompleted;

// Handler for `PMTweenDidCompleteNotification` notifications from tween objects in the sequence.
- (void)tweenCompleteNotification:(NSNotification *)notification;

// Handler for `PMTweenHalfCompletedNotification` notifications from tween objects in the group.
- (void)tweenHalfCompleteNotification:(NSNotification *)notification;

// Resets the sequence to its initial tween state.
- (void)resetTween;

@end

@implementation PMTweenSequence

#pragma mark - Lifecycle methods

- (instancetype)init {
    
    return [self initWithSequenceSteps:nil options:PMTweenOptionNone];
}

- (instancetype)initWithSequenceSteps:(NSArray *)sequenceSteps options:(PMTweenOptions)options {
    
    self = [super init];
    
    if (self) {
        _sequenceSteps = [NSMutableArray array];
        _tempoOverrides = [NSMutableArray array];
        _currentSequenceIndex = 0;
        _tweenState = PMTweenStateStopped;
        _tweenDirection = PMTweenDirectionForward;
        _reversingMode = PMTweenSequenceReversingNoncontiguous;
        
        _tempo = [PMTweenCATempo tempo];
        
        for (NSObject<PMTweening> *step in sequenceSteps) {
            [self addSequenceStep:step useTweenTempo:NO];
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
    
    _sequenceSteps = nil;
}


#pragma mark - Initialization methods

- (void)addSequenceStep:(NSObject<PMTweening> *)sequenceStep useTweenTempo:(BOOL)useTweenTempo {

    if ([sequenceStep conformsToProtocol:@protocol(PMTweening)]) {
        [_sequenceSteps addObject:sequenceStep];
        [_tempoOverrides addObject:@(useTweenTempo)];

        if (_reversing && _reversingMode == PMTweenSequenceReversingContiguous) {
            sequenceStep.reversing = YES;
        }
        
        if (!useTweenTempo) {
            sequenceStep.tempo = nil;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweenCompleteNotification:) name:PMTweenDidCompleteNotification object:sequenceStep];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweenHalfCompleteNotification:) name:PMTweenHalfCompletedNotification object:sequenceStep];
    } else {
        NSAssert(0, @"NSObject class does not conform to PMTweening protocol.");
    }
    

}


- (void)removeSequenceStep:(NSObject<PMTweening> *)sequenceStep {
    
    NSUInteger index = [self.sequenceSteps indexOfObject:sequenceStep];
    if (index != NSNotFound) {
        [_sequenceSteps removeObject:sequenceStep];
        [_tempoOverrides removeObjectAtIndex:index];
    
        [[NSNotificationCenter defaultCenter] removeObserver:self name:PMTweenDidCompleteNotification object:sequenceStep];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:PMTweenHalfCompletedNotification object:sequenceStep];
    }
    
}


#pragma mark - Tween methods

- (NSObject<PMTweening> *)currentSequenceStep {
    
    NSObject<PMTweening> *sequence_step = nil;
    if (_currentSequenceIndex < [_sequenceSteps count] && _currentSequenceIndex >= 0) {
        sequence_step = _sequenceSteps[(NSUInteger)_currentSequenceIndex];
    }
    
    return sequence_step;
}



- (void)nextSequenceStep {
    
    if (
        (!self.reversing && (_currentSequenceIndex+1) < [_sequenceSteps count])
        || (self.reversing && (self.tweenDirection == PMTweenDirectionForward && (_currentSequenceIndex+1) < [_sequenceSteps count]))
        || (self.reversing && (self.tweenDirection == PMTweenDirectionReverse && _currentSequenceIndex-1 >= 0))
        ) {
        
        if (!self.reversing || (self.reversing && self.tweenDirection == PMTweenDirectionForward)) {
            self.currentSequenceIndex++;

        } else if (self.reversing && self.tweenDirection == PMTweenDirectionReverse) {
            self.currentSequenceIndex--;
        }
        
        // call step block
        if (_stepBlock) {
            __weak typeof(self) block_self = self;
            self.stepBlock(block_self);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidStepNotification object:self userInfo:nil];
        
        // start next sequence step
        NSObject<PMTweening> *sequence_step = [self currentSequenceStep];
        [sequence_step resumeTween];

        if (!self.reversing
            || (self.reversing && self.reversingMode == PMTweenSequenceReversingContiguous && self.tweenDirection == PMTweenDirectionForward)
            || (self.reversing && self.reversingMode == PMTweenSequenceReversingNoncontiguous)
           ) {
            [sequence_step startTween];
        } else {
            [sequence_step resumeTween];
        }

    }
    
    
}



- (void)nextRepeatCycle {
    
    if (++self.cyclesCompletedCount - 1 < _numberOfRepeats) {
        // reset sequence for another cycle
        self.currentSequenceIndex = 0;
        self.startTime = 0;
        
        // call cycle block
        if (_repeatCycleBlock) {
            __weak typeof(self) block_self = self;
            self.repeatCycleBlock(block_self);
        }
        
        if (_reversing) {
            if (_tweenDirection == PMTweenDirectionForward) {
                self.tweenDirection = PMTweenDirectionReverse;
                
            } else if (_tweenDirection == PMTweenDirectionReverse) {
                self.tweenDirection = PMTweenDirectionForward;
            }
            
            self.tweenReverseCount = 0;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidRepeatNotification object:self userInfo:nil];
        
        if (self.reversing && self.reversingMode == PMTweenSequenceReversingNoncontiguous) {
            self.currentSequenceIndex++;
        }
        
        // start first sequence step
        NSObject<PMTweening> *sequence_step = [self currentSequenceStep];
        [sequence_step resumeTween];
        [sequence_step startTween];
        
    } else {
        [self sequenceCompleted];
    }
    
}


- (void)reverseTweenDirection {
    
    if (_tweenDirection == PMTweenDirectionForward) {
        self.tweenDirection = PMTweenDirectionReverse;
        
    } else if (_tweenDirection == PMTweenDirectionReverse) {
        self.tweenDirection = PMTweenDirectionForward;
    }
    
    self.tweenReverseCount = 0;
    
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


- (void)sequenceCompleted {
    
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
    self.currentSequenceIndex = 0;
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
        [self.sequenceSteps enumerateObjectsUsingBlock:^(NSObject<PMTweening> *tween, NSUInteger idx, BOOL *stop) {
            __strong typeof(self) strong_self = weak_self;
            if (![(NSNumber *)strong_self.tempoOverrides[idx] boolValue]) {
                tween.tempo = nil;
            }
        }];
    }
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
 *  PMTweenSequence implements reversing by activating reversing for each of its tween objects. Important: the previous state of reversing on any tween objects will be overridden by this assignment!
 */
- (void)setReversing:(BOOL)reversing {
    
    _reversing = reversing;
    
    // change the reversing property on each tween object to reflect the sequence's new state
    if (self.reversingMode == PMTweenSequenceReversingContiguous) {
        for (NSObject<PMTweening> *tween in _sequenceSteps) {
            tween.reversing = reversing;
        }
    }
    
    _tweenReverseCount = 0;

}

- (void)setReversingMode:(PMTweenSequenceReversingMode)reversingMode {
    _reversingMode = reversingMode;
    
    // change the reversing property on each tween object to reflect the sequence's new state
    if (_reversingMode == PMTweenSequenceReversingContiguous && _reversing) {
        for (NSObject<PMTweening> *tween in _sequenceSteps) {
            tween.reversing = YES;
        }
    }
}


#pragma mark - Notification handlers

- (void)tweenCompleteNotification:(NSNotification *)notification {
    
    if (
        (!self.reversing && ((_currentSequenceIndex + 1) < [_sequenceSteps count]))
        || (self.reversing && ((self.tweenDirection == PMTweenDirectionReverse && _currentSequenceIndex-1 >= 0) || (self.tweenDirection == PMTweenDirectionForward && _currentSequenceIndex+1 < [_sequenceSteps count])))
       ) {
        
        [self nextSequenceStep];
        
    } else {
        if (self.reversing && self.reversingMode == PMTweenSequenceReversingNoncontiguous && ((self.tweenDirection == PMTweenDirectionForward && _currentSequenceIndex + 1 >= [_sequenceSteps count]) || (self.tweenDirection == PMTweenDirectionReverse && _currentSequenceIndex-1 == 0))) {
            [self reverseTweenDirection];
            [self nextSequenceStep];

        } else if (self.repeating) {
            [self nextRepeatCycle];

        } else {
            [self sequenceCompleted];
        }
    }
    
}

- (void)tweenHalfCompleteNotification:(NSNotification *)notification {

    if (self.reversing && self.reversingMode == PMTweenSequenceReversingContiguous && self.tweenDirection == PMTweenDirectionForward) {
        if (++_tweenReverseCount >= [_sequenceSteps count]) {
            // the last tween has reversed, so we need to unpause each tween backwards in sequence
            [self reverseTweenDirection];

        } else {
            // pause this tween until we're ready for it to complete the back half of its tween
            NSObject<PMTweening> *tween = notification.object;
            [tween pauseTween];
            
            [self nextSequenceStep];

        }
    }
    
}


#pragma mark - PMTweenTempoDelegate methods

- (void)tempoBeatWithTimestamp:(NSTimeInterval)timestamp {
    
    [self updateWithTimeInterval:timestamp];
    
}


#pragma mark - PMTweening protocol methods

- (void)updateWithTimeInterval:(NSTimeInterval)currentTime {
    
    _currentTime = currentTime;
    
    if (_tweenState == PMTweenStateTweening) {
        
        BOOL should_send_tempo = YES;
        if (_currentSequenceIndex < [_tempoOverrides count]) {
            should_send_tempo = ![(NSNumber *)_tempoOverrides[(NSUInteger)_currentSequenceIndex] boolValue];
        }
        if (should_send_tempo) {
            NSObject<PMTweening> *sequence_step = [self currentSequenceStep];
            [sequence_step updateWithTimeInterval:currentTime];
        }
        
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
            
            NSObject<PMTweening> *sequence_step = [self currentSequenceStep];
            [sequence_step startTween];
            
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

            NSObject<PMTweening> *sequence_step = [self currentSequenceStep];
            [sequence_step startTween];
            
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
    if (_tweenState == PMTweenStateTweening || _tweenState == PMTweenStatePaused) {
        self.tweenState = PMTweenStateStopped;
        
        NSObject<PMTweening> *sequence_step = [self currentSequenceStep];
        [sequence_step stopTween];
        
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
        
        NSObject<PMTweening> *sequence_step = [self currentSequenceStep];
        [sequence_step pauseTween];
        
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
        
        NSObject<PMTweening> *sequence_step = [self currentSequenceStep];
        [sequence_step resumeTween];
        
        // call resume block
        if (_resumeBlock) {
            __weak typeof(self) block_self = self;
            self.resumeBlock(block_self);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidResumeNotification object:self userInfo:nil];
    }
}


@end
