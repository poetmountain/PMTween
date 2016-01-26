//
//  PMTweenPhysicsUnit.h
//  PMTween
//
//  Created by Brett Walker on 5/1/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweening.h"
#import "PMTweenTempo.h"
#import "PMTweenObjectUpdater.h"
#import "PMTweenPhysicsSystem.h"

/**
 *  PMTweenPhysicsUnit handles a single tween operation on an NSValue property, using a physics system to update a value with decaying velocity.
 */

@interface PMTweenPhysicsUnit : NSObject <PMTweening, PMTweenTempoDelegate> {
    @protected
    BOOL _reversing;
    NSObject *_targetProperty;
    NSObject *_targetObject;
    PMTweenTempo *_tempo;
}


///-------------------------------------
/// @name Creating an Instance
///-------------------------------------

/**
 *  Initializes a new PMTweenPhysicsUnit object, passing in a property and values for the tween operation.
 *
 *  @param property      An NSValue property to be tweened. Supported properties include several NSValue-encoded structs such as NSNumber, CGPoint, CGSize, CGRect, CGAffineTransform, and CATransform3D.
 *  @param startingValue The property's starting value for the tween operation.
 *  @param velocity      The velocity value to use in the physics calculations.
 *  @param friction      The friction value between 0 and 1 to use in the physics calculations, with 1 representing very high friction and 0 representing almost no friction.
 *  @param options       A bitmask of `PMTweenOptions` configuration values. Defaults to `PMTweenOptionNone`.
 *
 *  @return A new instance of this class.
 *
 *  @remarks If you need to tween an NSValue directly, without needing to update an object such as a UIView instance, using this method is adequate.
 *
 *  @see initWithObject:propertyKeyPath:startingValue:endingValue:duration:options:easingBlock:
 */
- (instancetype)initWithProperty:(NSValue *)property
         startingValue:(double)startingValue
              velocity:(double)velocity
              friction:(double)friction
               options:(PMTweenOptions)options;

/**
 *  Initalizes a new PMTweenPhysicsUnit object, passing in a target object, its property, and values for the tween operation.
 *
 *  @param object           An object whose property should be tweened.
 *  @param propertyKeyPath  A string keyPath that points to a NSValue property of the target object to be tweened. Supported properties include several NSValue-encoded structs such as NSNumber, CGPoint, CGSize, CGRect, CGAffineTransform, and CATransform3D.
 *  @param startingValue    The property's starting value for the tween operation.
 *  @param velocity         The velocity value to use in the physics calculations. Values from 0-10 are good for updating x/y positions.
 *  @param friction         The friction value between 0 and 1 to use in the physics calculations, with 1 representing very high friction and 0 representing almost no friction.
 *  @param options          A bitmask of `PMTweenOptions` configuration values. Defaults to `PMTweenOptionNone`.
 *
 *  @return A new instance of this class.
 *
 *  @remarks If you need to update the property of an object such as a UIView, use this method. PMTweenPhysicsUnit will handle updating the object's property automatically if you have provided a valid keyPath to the property. For a keyPath to be valid, all objects or NSValue types must be supported. By supplying a custom class to `structValueUpdater`, you can handle structs that PMTweenPhysicsUnit doesn't support by default.
 *
 *  @see initWithProperty:startingValue:endingValue:duration:options:easingBlock:, structValueUpdater
 */
- (instancetype)initWithObject:(NSObject *)object
     propertyKeyPath:(NSString *)propertyKeyPath
       startingValue:(double)startingValue
            velocity:(double)velocity
            friction:(double)friction
             options:(PMTweenOptions)options;


///-------------------------------------
/// @name Setting Up a Tween
///-------------------------------------

/**
 *  The delay, in seconds, before a tween operation begins.
 *
 *  @warning Setting this parameter after a tween operation has begun has no effect.
 */
@property (nonatomic, assign) NSTimeInterval delay;

/**
 *  A Boolean which determines whether a tween operation should repeat.
 *
 *  @remarks When set to `YES`, the tween operation repeats for the number of times specified by the `numberOfRepeats` property. The default value is `NO`.
 *
 *  @see numberOfRepeats
 */
@property (nonatomic, assign) BOOL repeating;

/**
 *  The number of tween cycle operations to repeat. The default value is 0.
 *
 *  @remarks This property is only used when `repeating` is set to `YES`. The default value is 0.
 *
 *  @see repeating
 */
@property (nonatomic, assign) NSUInteger numberOfRepeats;

/**
 *  An object conforming to the `PMTweenObjectUpdating` protocol which handles the updating of properties on objects and structs.
 *
 *  @remarks By default, PMTweenPhysicsUnit will assign an instance of `PMTweenObjectUpdater` to this property, but you can override this with your own custom classes if, for instance, you need to tween a value in an object or struct which `PMTweenObjectUpdater` doesn't handle.
 */
@property (nonatomic, strong) NSObject <PMTweenObjectUpdating> *structValueUpdater;

/**
 *  An object conforming to the `PMTweenPhysicsSolving` protocol which solves position calculation updates.
 *
 *  @remarks By default, PMTweenPhysicsUnit will assign an instance of `PMTweenPhysicsSystem` to this property, but you can override this with your own custom classes in order to supply a different physics model.
 */
@property (nonatomic, strong) NSObject <PMTweenPhysicsSolving> *physicsSystem;

/**
 *  The current velocity used by the physics system to calculate tween values.
 *
 *  @remarks If you wish to change the velocity after initially setting it via one of the init methods, use this setter. If you change the velocity directly on the `physicsSystem` object, the `tweenProgress` property won't be accurate.
 */
@property (nonatomic, assign) double velocity;

/**
 *  The current friction coefficient used by the physics system.
 *
 *  @remarks The usable value range is between 0 and 1, with 1 representing very high friction and 0 representing almost no friction. Setting this property to 0.0 will actually set it a bit fractionally higher than 0 to avoid divide-by-zero errors during calculations.
 */
@property (nonatomic, assign) double friction;

/**
 *  This float value is used to determine whether the object modeled by the physics system has come to rest due to deceleration.
 *
 *  @remarks The way PMTweenPhysicsSystem applies friction means that as velocity approaches 0, it will be assigned smaller and smaller fractional numbers, so we need a reasonable cutoff that approximates the velocity coming to rest. The default value is the internal constant PMTWEEN_DECAY_LIMIT, which is fine for display properties, but you may prefer other values for your purposes.
 */
@property (nonatomic, assign) CGFloat velocityDecayLimit;


///-------------------------------------
/// @name Tween State
///-------------------------------------

/**
 *  The property to be tweened.
 */
@property (readonly, nonatomic, strong) NSObject *targetProperty;

/**
 * The target object whose property should be tweened, applicable if this instance was initiated with the initWithProperty:... method.
 */
@property (readonly, nonatomic, strong) NSObject *targetObject;

/**
 *  A `PMTweenState` enum which represents the current state of the tween operation. (read-only)
 */
@property (readonly, nonatomic, assign) PMTweenState tweenState;

/**
 *  A `PMTweenDirection` enum which represents the current direction of the tween operation. (read-only)
 */
@property (readonly, nonatomic, assign) PMTweenDirection tweenDirection;

/**
 *  The starting value of the tween operation.
 *
 *  @remarks Note that for non-numeric properties like structs this may affect multiple values, such as the x and y properties of CGPoint.
 *
 *  @see currentValue, endingvalue
 */
@property (nonatomic, assign) double startingValue;

/**
 *  The current value of the tween operation. (read-only)
 *
 *  @remarks Note that for non-numeric properties like structs this may affect multiple values, such as the x and y properties of CGPoint.
 *
 *  @see startingValue, endingvalue
 */
@property (readonly, nonatomic, assign) double currentValue;

/**
 *  A float value between 0.0 and 1.0, which represents the current progress of a physics deceleration, calculated as the difference between the starting velocity and the current velocity. (read-only)
 */
@property (readonly, nonatomic, assign) CGFloat tweenProgress;

/**
 *  A float value between 0.0 and 1.0, which represents the current progress of a tween cycle. (read-only)
 *
 *  @remarks This progress could represent one tween or two, depending on whether `reversing` is set to `YES`.
 */
@property (readonly, nonatomic, assign) CGFloat cycleProgress;

/**
 *  The amount of completed tween cycles. (read-only)
 *
 * @remarks A cycle represents the total length of tweening operation. If `reversing` is set to `YES`, a cycle comprises two separate tweens; otherwise a cycle is the length of one tween.
 */
@property (readonly, nonatomic, assign) NSUInteger cyclesCompletedCount;


///-------------------------------------
/// @name Notification Blocks
///-------------------------------------

/**
 *  This notification block is executed when calling the `startTween` method on this instance causes a tween operation to start.
 *
 *  @see startTween
 */
@property (nonatomic, copy) PMTweenDidStartBlock startBlock;

/**
 *  This notification block is executed when calling the `stopTween` method on this instance causes a tween operation to stop.
 *
 *  @see stopTween
 */
@property (nonatomic, copy) PMTweenDidStopBlock stopBlock;

/**
 *  This notification block is executed when the `updateWithTimeInterval:currentTime:` method is called on this instance while this instance's `tweenState` is `PMTweenStateTweening`.
 *
 *  @see updateWithTimeInterval:currentTime:
 */
@property (nonatomic, copy) PMTweenDidUpdateBlock updateBlock;

/**
 *  This notification block is executed when a tween cycle has repeated.
 *
 *  @see repeating, cyclesCompletedCount
 */
@property (nonatomic, copy) PMTweenDidRepeatBlock repeatCycleBlock;

/**
 *  This notification block is executed when this instance's `tweenDirection` property changes to `PMTweenDirectionReverse`.
 *
 *  @see tweenDirection, reversing
 */
@property (nonatomic, copy) PMTweenDidReverseBlock reverseBlock;

/**
 *  This notification block is executed when calling the `pauseTween` method on this instance causes a tween operation to pause.
 *
 *  @see pauseTween
 */
@property (nonatomic, copy) PMTweenDidPauseBlock pauseBlock;

/**
 *  This notification block is executed when calling the `resumeTween` method on this instance causes a tween operation to resume.
 *
 *  @see resumeTween
 */
@property (nonatomic, copy) PMTweenDidResumeBlock resumeBlock;

/**
 *  This notification block is executed when a tween operation has completed (or when all tween cycles have completed, if `repeating` is set to `YES`).
 */
@property (nonatomic, copy) PMTweenDidCompleteBlock completeBlock;


@end
