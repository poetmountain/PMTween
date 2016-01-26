//
//  PMTweenPhysicsSystem.h
//  PMTween
//
//  Created by Brett Walker on 5/1/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The `PMTweenPhysicsSolving` protocol declares methods that must be adopted by a class in order to be used by `PMTweenPhysicsUnit` to update values using a physics system.
 */
@protocol PMTweenPhysicsSolving <NSObject>

/**
 *  The velocity value to use in physics calculations.
 */
@property (nonatomic, assign) double velocity;

/**
 *  The friction value to be applied in physics calculations.
 */
@property (nonatomic, assign) double friction;

/**
 *  This method updates a 1D position using physics calculations.
 *
 *  @param position    The current position of the physics object being modeled.
 *  @param currentTime The current timestamp.
 *
 *  @return An updated position.
 */
- (double)solveForPosition:(double)position currentTime:(NSTimeInterval)currentTime;

/**
 *  This method should reset the physics system to its initial velocity and clear the timestamp used to calculate the current step.
 */
- (void)resetSystem;

/**
 *  This method should reverse the direction of the velocity.
 */
- (void)reverseDirection;

/**
 *  This method should pause the physics system, preventing any new calculations.
 */
- (void)pauseSystem;

/**
 *  This method should resume the physics system.
 */
- (void)resumeSystem;

@end


/**
 *  PMTweenPhysicsSystem is the default class used by `PMTweenPhysicsUnit` to update values.
 */
@interface PMTweenPhysicsSystem : NSObject <PMTweenPhysicsSolving> {
    @protected
    double _velocity;
    double _initialVelocity;
    double _friction;
}

/**
 *  Convenience method that returns a new instance of this class.
 *
 *  @return A new instance of this class.
 */
+ (instancetype)system;

/**
 *  Initializes a new PMTweenPhysicsSystem object, setting up the physics system with initial values for velocity and friction.
 *
 *  @param velocity The initial velocity to use.
 *  @param friction The friction coefficient to use.
 *
 *  @return A new instance of this class.
 */
- (instancetype)initWithVelocity:(double)velocity friction:(double)friction;

@end
