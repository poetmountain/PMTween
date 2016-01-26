//
//  PMTweenGroup.h
//  PMTween
//
//  Created by Brett Walker on 4/4/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenTempo.h"
#import "PMTweening.h"

/**
 *  PMTweenGroup handles the tweening of one or more objects which conform to the `PMTweening` protocol, either being instances of `PMTweenUnit` or other custom classes. The PMTweenGroup class is a good solution when you want to easily synchronize the operation of many tweens.
 */

@interface PMTweenGroup : NSObject <PMTweening, PMTweenTempoDelegate> {
    @protected
    BOOL _reversing;
    NSMutableArray *_tweens;
    PMTweenTempo *_tempo;
}

///-------------------------------------
/// @name Creating an Instance
///-------------------------------------

/**
 *  Initializes a new PMTweenGroup object and registers the provided array of tween objects.
 *
 *  @param tweens  An array of objects which should conform to the `PMTweening` protocol.
 *  @param options A bitmask of `PMTweenOptions` configuration values.
 *
 *  @return A new instance of this class.
 *
 *  @warning A NSInternalInconsistencyException will be raised if the provided array contains an object which does not adopt the `PMTweening` protocol.
 *
 */
- (instancetype)initWithTweens:(NSArray *)tweens options:(PMTweenOptions)options;


///-------------------------------------
/// @name Setting Up a Group
///-------------------------------------

/**
 *  Adds an object which conforms to the `PMTweening` protocol to the tweening group.
 *
 *  @param tween An object which adopts the `PMTweening` protocol.
 *
 *  @remarks All tween objects added via this method will have their `updateWithTimeInterval:currentTime:` method called by the PMTweenGroup instance.
 *
 *  @warning A NSInternalInconsistencyException will be raised if the provided object does not adopt the `PMTweening` protocol.
 *
 */
- (void)addTween:(NSObject<PMTweening> *)tween;

/**
 *  Adds an object which conforms to the `PMTweening` protocol to the tweening group.
 *
 *  @param tween         An object which adopts the `PMTweening` protocol.
 *  @param useTweenTempo When `YES`, the tween object should use its own tempo to update its tween progress, and thus the `updateWithTimeInterval:currentTime:` method will not be called on the object by the PMTweenGroup instance.
 *
 *  @warning A NSInternalInconsistencyException will be raised if the provided object does not adopt the `PMTweening` protocol.
 *
 */
- (void)addTween:(NSObject<PMTweening> *)tween useTweenTempo:(BOOL)useTweenTempo;

/**
 *  Adds an array of objects which should conform to the `PMTweening` protocol to the tweening group.
 *
 *  @param tweens An array of objects which should conform to the `PMTweening` protocol.
 *
 *  @remarks All tween objects added via this method will have their `updateWithTimeInterval:currentTime:` method called by the PMTweenGroup instance.
 *
 *  @warning A NSInternalInconsistencyException will be raised if the provided array contains an object which does not adopt the `PMTweening` protocol.
 *
 */
- (void)addTweens:(NSArray *)tweens;

/**
 *  Removes the specified tween object from the tweening group.
 *
 *  @param tween The tween object to remove.
 */
- (void)removeTween:(NSObject<PMTweening> *)tween;

/**
 *  The delay, in seconds, before a tween operation begins.
 *
 *  @warning Setting this parameter after a tween operation has begun has no effect.
 */
@property (nonatomic, assign) NSTimeInterval delay;

/**
 *  A Boolean which determines whether a group's tween operation should repeat.
 *
 *  @remarks When set to `YES`, each tween object in the group repeats its tween cycle for the number of times specified by the `numberOfRepeats` property. The default value is `NO`.
 *
 *  @see numberOfRepeats
 */
@property (nonatomic, assign) BOOL repeating;

/**
 *  The number of tween cycle operations to repeat.
 *
 *  @remarks This property is only used when `repeating` is set to `YES`. Negative values are clamped to 0. The default value is 0.
 *
 *  @see repeating
 */
@property (nonatomic, assign) NSUInteger numberOfRepeats;

/**
 *  A Boolean which determines whether a group's tween objects should pause until all objects are ready to reverse directions.
 *
 *  @remarks When set to `YES`, the group does not reverse direction until all objects have completed their current tween. This property only has an effect when `reversing` is set to `YES`. It posts a `PMTweenDidReverseNotification` notification when all of its tween objects are ready to reverse. When set to `NO`, its tween objects will reverse independently of each other. The default value is `YES`.
 *
 *  @see reversing
 */
@property (nonatomic, assign) BOOL syncTweensWhenReversing;


///-------------------------------------
/// @name Tween State
///-------------------------------------

/**
 *  A `PMTweenState` enum which represents the current state of the tween operation. (read-only)
 */
@property (readonly, nonatomic, assign) PMTweenState tweenState;

/**
 *  A `PMTweenDirection` enum which represents the current direction of the tween operation. (read-only)
 */
@property (readonly, nonatomic, assign) PMTweenDirection tweenDirection;

/**
 *  An array comprising the tween objects which are controlled by this PMTweenGroup object. (read-only)
 */
@property (readonly, nonatomic, strong) NSArray *tweens;

/**
 *  The number of completed tween cycles. (read-only)
 *
 *  @remarks A cycle represents the total length of tweening operation.
 *
 *  @see repeating
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
 *  This notification block is executed when a tween cycle has completed.
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
