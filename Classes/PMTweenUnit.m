//
//  PMTweenUnit.m
//  PMTween
//
//  Created by Brett Walker on 3/29/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenUnit.h"
#import "PMTweenEasingLinear.h"
#import "PMTweenObjectUpdater.h"
#import "PMTweenCATempo.h"

@interface PMTweenUnit ()

// The starting time of the current tween operation. A value of 0 means that no tween is currently in progress.
@property (nonatomic, assign) NSTimeInterval startTime;

// The most recent update timestamp, as sent by `updateWithTimeInterval:currentTime:`.
@property (nonatomic, assign) NSTimeInterval currentTime;

// The ending time of the tween, which is determined by adding the tween duration to the starting time.
@property (nonatomic, assign) NSTimeInterval endTime;

// Key path for property on target. Only used when class is created with initWithTarget.
@property (nonatomic, copy) NSString *propertyKeyPath;

// Key path for the parent of the target property. Used when class is created with initWithTarget and targetProperty is a numeric value.
@property (nonatomic, copy) NSString *parentKeyPath;

// Boolean representing whether parent property should be replaced, instead of the target property directly.
@property (nonatomic, assign) BOOL replaceParentProperty;

// Boolean value representing whether the object of the property should be reset when we repeat or restart the tween.
@property (nonatomic, assign) BOOL resetObjectStateOnRepeat;

// The version of the tweened property holding the original value.
@property (nonatomic, strong) NSObject *startingTargetProperty;

// Used to reset the parent object state when resetObjectStateOnRepeat is YES.
@property (nonatomic, strong) NSObject *startingParentProperty;

// Timestamp when `pauseTween` method is called, to track amount of time paused.
@property (nonatomic, assign) NSTimeInterval pauseTimestamp;

// Cache of the getter selector for the property.
@property (nonatomic, assign) SEL propertyGetter;

// Cache of the setter selector for the property.
@property (nonatomic, assign) SEL propertySetter;


// Initializes values in preparation for a tween operation.
- (void)setupTweenForProperty:(NSObject *)property startingValue:(double)startingValue endingValue:(double)endingValue duration:(NSTimeInterval)duration options:(PMTweenOptions)options easingBlock:(PMTweenEasingBlock)easingBlock;

// Updates the target property with a new tween value.
- (void)updatePropertyValue;

// Starts the tween's next repeat cycle, if there is one.
- (void)nextRepeatCycle;

// Called when the tween has completed.
- (void)tweenCompleted;

// Reverses the direction of the tween.
- (void)reverseTweenDirection;

// Resets the tween to its initial tween state.
- (void)resetTween;

@end


@implementation PMTweenUnit

#pragma mark - Lifecycle methods

- (id)initWithProperty:(NSValue *)property startingValue:(double)startingValue endingValue:(double)endingValue duration:(NSTimeInterval)duration options:(PMTweenOptions)options easingBlock:(PMTweenEasingBlock)easingBlock {
    
    if (self = [super init]) {
        
        _structValueUpdater = [PMTweenObjectUpdater updater];
        
        [self setupTweenForProperty:property startingValue:startingValue endingValue:endingValue duration:duration options:options easingBlock:easingBlock];
    }
    
    return self;
}


- (id)initWithObject:(NSObject *)object propertyKeyPath:(NSString *)propertyKeyPath startingValue:(double)startingValue endingValue:(double)endingValue duration:(NSTimeInterval)duration options:(PMTweenOptions)options easingBlock:(PMTweenEasingBlock)easingBlock {
    
    if (self = [super init]) {
        
        _structValueUpdater = [PMTweenObjectUpdater updater];
        
        _targetObject = object;
        _propertyKeyPath = propertyKeyPath;
        
        // determine if target property is a value we can update directly, or if it's an element of a struct we need to replace
        _parentKeyPath = _propertyKeyPath;
        NSMutableArray *keys = [[propertyKeyPath componentsSeparatedByString:@"."] mutableCopy];
        NSUInteger key_count = [keys count];
        if (key_count > 1) {
            // there's more than one element in the path, meaning we have a parent, so let's find the prop type
            __block NSString *previous_parent_path = nil;
            
            // descend keypath tree until we find a key in the path that isn't a struct or integer
            __block id parent_value = nil;
            __weak typeof(self) weak_self = self;
            
            [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSArray *parent_keys = [keys subarrayWithRange:NSMakeRange(0, idx)];
                if ([parent_keys count] > 0) {
                    NSString *parent_path = [parent_keys componentsJoinedByString:@"."];
                    __strong typeof(self) strong_self = weak_self;
                    
                    parent_value = [object valueForKeyPath:parent_path];
                    
                    BOOL is_value_supported = NO;
                    if (parent_value && ([strong_self.structValueUpdater replaceObject:parent_value newPropertyValue:1 propertyKeyPath:propertyKeyPath])) {
                        is_value_supported = YES;
                    }
                    
                    if (parent_value && is_value_supported) {
                        // we found a path element that isn't numeric, so we'll need to save the path element below this one
                        
                        strong_self.replaceParentProperty = YES;
                        strong_self.parentKeyPath = [parent_path copy];
                        strong_self.propertyGetter = [PMTween getterForPropertyName:[parent_keys lastObject]];
                        strong_self.propertySetter = [PMTween setterForPropertyName:[parent_keys lastObject]];

                        *stop = YES;
                    } else if ([parent_keys count] > 1) {
                        previous_parent_path = parent_path;
                    }
                    
                }
            }];
            
            if (self.replaceParentProperty) {
                _targetProperty = parent_value;
                
            } else {
                self.propertyGetter = [PMTween getterForPropertyName:[keys lastObject]];
                self.propertySetter = [PMTween setterForPropertyName:[keys lastObject]];
            }
            
        } else {
            // this is a top-level property, so let's see if this property is updatable
            BOOL is_value_supported = NO;
            id prop_value = [object valueForKeyPath:propertyKeyPath];
            if (prop_value && [_structValueUpdater replaceObject:prop_value newPropertyValue:1 propertyKeyPath:propertyKeyPath]) {
                is_value_supported = YES;
            }
            if (prop_value && is_value_supported) {
                _targetProperty = prop_value;
            } else {
                // target property's value could be nil if it's a NSNumber, so set it to the starting value
                self.targetProperty = @(_startingValue);
            }
            
        }
        
        [self setupTweenForProperty:_targetProperty startingValue:startingValue endingValue:endingValue duration:duration options:options easingBlock:easingBlock];        
        
    }
    
    return self;
    
}


- (void)dealloc {
    if (_tempo) {
        _tempo.delegate = nil;
    }
}


#pragma mark - Initialization methods

- (void)setupTweenForProperty:(NSObject *)property startingValue:(double)startingValue endingValue:(double)endingValue duration:(NSTimeInterval)duration options:(PMTweenOptions)options easingBlock:(PMTweenEasingBlock)easingBlock {
    
    _targetProperty = property;

    _tweenState = PMTweenStateStopped;
    _cyclesCompletedCount = 0;
    
    _targetProperty = property;
    _startingTargetProperty = property;
    _startingValue = startingValue;
    _currentValue = startingValue;
    _endingValue = endingValue;
    _tweenDirection = PMTweenDirectionForward;
    _tweenProgress = 0.0;
    _cycleProgress = 0.0;
    _reversing = NO;
    _repeating = NO;
    _resetObjectStateOnRepeat = NO;

    _duration = (duration > 0.0) ? duration : 0.0; // if value passed is negative, clamp it to 0
    if (options & PMTweenOptionRepeat) {
        _repeating = YES;
    }
    if (options & PMTweenOptionReverse) {
        _reversing = YES;
    }
    if (options & PMTweenOptionResetStateOnRepeat) {
        _resetObjectStateOnRepeat = YES;
        _startingParentProperty = property;
    }
    (easingBlock) ? (_easingBlock = easingBlock) : (_easingBlock = [PMTweenEasingLinear easingNone]);
    
    _startTime = 0;
    _currentTime = 0;
    
    self.tempo = [PMTweenCATempo tempo];
        
}


#pragma mark - Tween methods

- (void)updatePropertyValue {

    if ([_targetProperty isKindOfClass:[NSNumber class]]) {
        self.targetProperty = @(_currentValue);
        
    } else {
        self.targetProperty = _targetProperty;

    }
}



- (void)tweenCompleted {
    
    self.tweenState = PMTweenStateStopped;
    _tweenProgress = 1.0;
    _cycleProgress = 1.0;
    [self updatePropertyValue];
    
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



- (void)nextRepeatCycle {
    
    if (++self.cyclesCompletedCount - 1 < _numberOfRepeats) {

        // reset for next cycle
        self.currentValue = _startingValue;
        self.tweenState = PMTweenStateTweening;
        _cycleProgress = 0.0;
        _tweenProgress = 0.0;

        if (self.resetObjectStateOnRepeat) {
            [self.targetObject setValue:_startingParentProperty forKeyPath:_parentKeyPath];
        }

        // setting startTime to 0 causes tweenUpdate method to re-init the tween
        self.startTime = 0;
        
        if (self.reversing) {
            [self reverseTweenDirection];
        }
        
        // call cycle block
        if (_repeatCycleBlock) {
            __weak typeof(self) block_self = self;
            self.repeatCycleBlock(block_self);
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidRepeatNotification object:self userInfo:nil];
        

        
    } else {
        [self tweenCompleted];
    }

    
}


- (void)reverseTweenDirection {
    if (_tweenDirection == PMTweenDirectionForward) {
        self.tweenDirection = PMTweenDirectionReverse;
        
    } else if (_tweenDirection == PMTweenDirectionReverse) {
        self.tweenDirection = PMTweenDirectionForward;
    }
    
    // reset the times to get ready for the new reverse tween
    self.startTime = 0;

    _tweenProgress = 0.0;
    
    // call reverse block
    if (_reverseBlock) {
        __weak typeof(self) block_self = self;
        self.reverseBlock(block_self);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidReverseNotification object:self userInfo:nil];
    
    // send out 50% complete notification, used by PMTweenSequence in contiguous mode
    if (_tweenDirection == PMTweenDirectionReverse) {
        NSUInteger half_complete = lroundf(_numberOfRepeats / 2);
        
        if (_cyclesCompletedCount == half_complete) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenHalfCompletedNotification object:self userInfo:nil];

        }
    }
    
}


- (void)resetTween {
    self.tweenState = PMTweenStateStopped;
    self.currentValue = _startingValue;
    self.tweenDirection = PMTweenDirectionForward;
    if (self.resetObjectStateOnRepeat) {
        [self.targetObject setValue:_startingParentProperty forKeyPath:_parentKeyPath];

    }
    
    self.cyclesCompletedCount = 0;
    _cycleProgress = 0.0;
    _tweenProgress = 0.0;
    
    // setting startTime to 0 causes tweenUpdate method to re-init the tween
    self.startTime = 0;
}


// TODO: test more thoroughly before surfacing this method in the public API, possibly add to other classes and PMTweening protocol.
- (void)jumpToPosition:(CGFloat)position {
    
    if (_tweenState == PMTweenStateTweening) {
        self.cycleProgress = position;
        
        self.currentTime = ((_endTime - _startTime) * position) + _startTime;
        double value_delta = _endingValue - _startingValue;
        self.currentValue = (value_delta * position) + _startingValue;
    }
    
}


#pragma mark - Getter/setters

- (void)setCurrentValue:(double)currentValue {
    _currentValue = currentValue;
}

- (void)setTweenProgress:(CGFloat)tweenProgress {
    _tweenProgress = tweenProgress;
    
    // sync cycleProgress with tweenProgress so that cycleProgress always represents total cycle progress
    if (_reversing && _tweenDirection == PMTweenDirectionForward) {
        _cycleProgress = tweenProgress * 0.5;
    } else if (_reversing && _tweenDirection == PMTweenDirectionReverse) {
        _cycleProgress = (tweenProgress * 0.5) + 0.5;
    } else {
        _cycleProgress = tweenProgress;
    }
}


- (void)setCycleProgress:(CGFloat)cycleProgress {
    _cycleProgress = cycleProgress;

    if (self.reversing) {
        CGFloat new_progress = _cycleProgress * 2;
        if (_cycleProgress >= 0.5) { new_progress -= 1; }
        _tweenProgress = new_progress;

    } else {
        _tweenProgress = _cycleProgress;
    }
}


- (NSObject *)targetProperty {
    
    NSObject *prop = nil;
    
    if (self.targetObject) {
        if ([_targetProperty isKindOfClass:[NSValue class]]) {
            if (!_replaceParentProperty) {
                prop = [(NSValue *)self.targetObject valueForKeyPath:_propertyKeyPath];
            } else {
                prop = [self.targetObject valueForKeyPath:_parentKeyPath];
            }
            
        } else if ([_targetProperty isKindOfClass:[UIColor class]]) {
            NSArray *keys = nil;
            if (!_replaceParentProperty) {
                keys = [_propertyKeyPath componentsSeparatedByString:@"."];
            } else {
                keys = [_parentKeyPath componentsSeparatedByString:@"."];
            }
            @try {
                // letting the runtime know about result and argument types
                // performSelector can be leaky under ARC
                SEL getter = self.propertyGetter;
                IMP imp =  [self.targetObject methodForSelector:getter];
                UIColor* (*func)(id, SEL) = (void *)imp;
                UIColor *color = func(self.targetObject, getter);
                prop = color;
            }
            @catch (NSException *exception) {
                NSLog(@"Unknown selector! %@", exception);
            }
        }
        
    } else {
        prop = _targetProperty;
    }
    
    return prop;
}


- (void)setTargetProperty:(NSObject *)targetProperty {
    

    _targetProperty = targetProperty;

    if (self.targetObject) {

        if ([_targetProperty isKindOfClass:[NSValue class]]) {
            if (!_replaceParentProperty) {
                [self.targetObject setValue:_targetProperty forKeyPath:_propertyKeyPath];
                
            } else {
                // replace the top-level struct of the property we're trying to alter
                // e.g.: keyPath is @"frame.origin.x", so we replace "frame" because that's the closest KVC-compliant prop
                NSValue *base_prop = [self.targetObject valueForKeyPath:_parentKeyPath];
                NSValue *new_parent_value = (NSValue *)[self.structValueUpdater replaceObject:base_prop newPropertyValue:_currentValue propertyKeyPath:_propertyKeyPath];
                
                [self.targetObject setValue:new_parent_value forKeyPath:_parentKeyPath];
            }
            
        } else if ([_targetProperty isKindOfClass:[UIColor class]]) {
            NSArray *keys = nil;
            if (!_replaceParentProperty) {
                keys = [_propertyKeyPath componentsSeparatedByString:@"."];
            } else {
                keys = [_parentKeyPath componentsSeparatedByString:@"."];
            }
            
            // replace the top-level struct of the property we're trying to alter
            // e.g.: keyPath is @"frame.origin.x", so we replace "frame" because that's the closest KVC-compliant prop
            id base_prop = [self.targetObject valueForKeyPath:_parentKeyPath];
            UIColor *new_color = (UIColor *)[self.structValueUpdater replaceObject:base_prop newPropertyValue:_currentValue propertyKeyPath:_propertyKeyPath];
            
            @try {
                // letting the runtime know about result and argument types
                // performSelector can be leaky under ARC
                SEL setter = self.propertySetter;
                IMP imp = [self.targetObject methodForSelector:setter];
                void (*func)(id, SEL, UIColor*) = (void *)imp;
                func(self.targetObject, setter, new_color);
            }
            @catch (NSException *exception) {
                NSLog(@"Unknown selector! %@", exception);
            }
        }

    }
    
    
}

- (void)setTargetObject:(NSObject *)targetObject {
    _targetObject = targetObject;
}


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
    _numberOfRepeats = numberOfRepeats;
}

- (BOOL)isReversing {
    return _reversing;
}

- (void)setReversing:(BOOL)reversing {
    _reversing = reversing;
}


#pragma mark - PMTweenTempoDelegate methods

- (void)tempoBeatWithTimestamp:(NSTimeInterval)timestamp {
    
    [self updateWithTimeInterval:timestamp];
    
}



#pragma mark - PMTweening methods

- (void)updateWithTimeInterval:(NSTimeInterval)currentTime {
    
    if (_tweenState == PMTweenStateTweening) {

        CGFloat adjusted_duration = _duration;
        if (self.reversing) { adjusted_duration *= 0.5; }
        
        if (_pauseTimestamp != 0 && _startTime != 0) {
            // we just resumed from a pause, so adjust the times to account for paused length
            NSTimeInterval pause_delta = currentTime - self.pauseTimestamp;
            self.startTime += pause_delta;
            self.endTime += pause_delta;
            // reset pause timestamp
            self.pauseTimestamp = 0;
        }
        
        if (_startTime == 0) {
            // a start time of 0 means we need to initialize the tween times
            self.startTime = currentTime;
            self.endTime = _startTime + adjusted_duration;
            if (_pauseTimestamp != 0) {
                self.pauseTimestamp = 0;
            }
        }
        
        
        self.currentTime = MIN(currentTime, self.endTime); // don't let currentTime go over endTime or it'll produce wrong easing values
        
        NSTimeInterval elapsed_time = self.currentTime - self.startTime;
        
        double new_value;
        CGFloat progress;
        double value_delta = _endingValue - _startingValue;
        
        if (_tweenDirection == PMTweenDirectionForward) {
            new_value = self.easingBlock(elapsed_time, _startingValue, value_delta, adjusted_duration);
            progress = fabsf((_currentValue - _startingValue) / value_delta);

        } else {
            
            if (self.reverseEasingBlock) {
                new_value = self.reverseEasingBlock(elapsed_time, _endingValue, -value_delta, adjusted_duration);
            } else {
                new_value = self.easingBlock(elapsed_time, _endingValue, -value_delta, adjusted_duration);
            }
            progress = fabsf((_currentValue - _endingValue) / value_delta);

        }

        self.currentValue = new_value;
        self.tweenProgress = progress;
        
        
        // call update block
        if (_updateBlock) {
            __weak typeof(self) block_self = self;
            self.updateBlock(block_self);
        }
        

        if (_currentTime < _endTime) {
            [self updatePropertyValue];

        } else {
            // tween has completed
            
            if (_reversing || _repeating) {
                
                if ((_repeating && !_reversing) || (_reversing && _repeating && _tweenDirection == PMTweenDirectionReverse)) {
                    [self nextRepeatCycle];
                    
                } else if (!_repeating && _reversing && _tweenDirection == PMTweenDirectionReverse) {
                    [self tweenCompleted];
                    
                } else if (_reversing && _tweenState == PMTweenStateTweening) {
                    [self reverseTweenDirection];
                }

            } else {
                // not reversing or repeating
                [self tweenCompleted];
            }
        }
        
    } else if (_tweenState == PMTweenStateDelayed) {
     
        _currentTime = currentTime;
        
        if (_startTime == 0) {
            // a start time of 0 means we need to initialize the tween times
            self.startTime = currentTime;
            self.endTime = _startTime + _delay;
        }
        
        if (_currentTime >= self.endTime) {
            // delay is done, time to tween
            self.tweenState = PMTweenStateTweening;
            self.startTime = 0;
            
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
        _startTime = 0;
        _currentTime = 0;
        _tweenProgress = 0;
        
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
        
        // saves current time so we can determine length of pause time
        self.pauseTimestamp = _currentTime;
        
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
        
        // call resume block
        if (_resumeBlock) {
            __weak typeof(self) block_self = self;
            self.resumeBlock(block_self);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PMTweenDidResumeNotification object:self userInfo:nil];
    }

}



@end
