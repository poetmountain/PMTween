//
//  PMTweenPhysicsSystem.m
//  PMTween
//
//  Created by Brett Walker on 5/1/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenPhysicsSystem.h"
#import "PMTween.h"

@interface PMTweenPhysicsSystem ()

// The initial velocity value set. Used when resetting the system.
@property (nonatomic, assign) double initialVelocity;

// The last timestamp sent via the solveForPosition:currentTime: method.
@property (nonatomic, assign) double lastTimestamp;

// Boolean value representing whether the physics system is currently paused.
@property (nonatomic, assign) BOOL paused;

@end


@implementation PMTweenPhysicsSystem

+ (instancetype)system {
    
    PMTweenPhysicsSystem *system = [[PMTweenPhysicsSystem alloc] init];
    
    return system;
}

- (instancetype)initWithVelocity:(double)velocity friction:(double)friction {
    
    if (self = [super init]) {
        self.velocity = velocity;
        self.friction = friction;
        _initialVelocity = _velocity;
    }
    
    return self;
    
}


#pragma mark - PMTweenPhysicsSolving protocol methods

- (double)solveForPosition:(double)position currentTime:(NSTimeInterval)elapsedTime {
    //NSLog(@"======================================================");
    //NSLog(@"last %f -- elapsed %f", _lastTimestamp, elapsedTime);
    
    double new_position = position;
    
    if (!_paused) {        
        if (_lastTimestamp > 0) {
            NSTimeInterval time_delta = elapsedTime - _lastTimestamp;
            time_delta = MAX(0.0, time_delta);
            //NSLog(@"time ∆ %f", time_delta);
            
            // use pow here to compensate for floating point errors over time
            double friction_multiplier = pow(1-_friction, time_delta);
            
            _velocity *= friction_multiplier;
            
            // add just the portion of current velocity that occurred during this time delta
            new_position += (_velocity * time_delta);
            
        }
        _lastTimestamp = elapsedTime;

    }
    
    return new_position;
    
}


- (void)reverseDirection {
    
    self.initialVelocity *= -1;
    _velocity *= -1;
}


- (void)resetSystem {
    
    _velocity = _initialVelocity;
    
    [self resumeSystem];

}


- (void)pauseSystem {
    self.paused = YES;
}


- (void)resumeSystem {
    self.lastTimestamp = 0;
    self.paused = NO;
}


#pragma mark - Getter/setters

- (double)velocity {
    return _velocity;
}

- (void)setVelocity:(double)velocity {
    
    _velocity = velocity;

    if (_initialVelocity == 0.0 || _velocity != 0.0) {
        self.initialVelocity = _velocity;
    }
}

- (double)friction {
    return _friction;
}

- (void)setFriction:(double)friction {
    // if we allowed 0, we'd get divide by zero errors
    // besides with 0 friction our value would sail to the stars with a constant velocity
    _friction = (friction > 0.0) ? friction : 0.000001;
}

@end
