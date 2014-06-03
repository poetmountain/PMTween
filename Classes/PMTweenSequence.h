//
//  PMTweenSequence.h
//  PMTween
//
//  Created by Brett Walker on 4/9/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenTempo.h"
#import "PMTween.h"

/**
 *  PMTweenSequence allows objects which conform to the `PMTweening` protocol to be chained together in a sequential series of tween steps.
 */

@interface PMTweenSequence : NSObject <PMTweening, PMTweenTempoDelegate> {
    @protected
    BOOL _reversing;
    PMTweenTempo *_tempo;
    NSMutableArray *_sequenceSteps;
}

///-------------------------------------
/// @name Creating an Instance
///-------------------------------------

/**
 *  Initializes a new PMTweenSequence object, and uses the provided array of tween objects as its sequence steps.
 *
 *  @param sequenceSteps An array of objects which should conform to the `PMTweening` protocol.
 *  @param options       A bitmask of `PMTweenOptions` configuration values.
 *
 *  @return A new instance of this class.
 *
 *  @remarks The sequence in which the objects are tweened is defined by their order in the provided array.
 *
 *  @warning A NSInternalInconsistencyException will be raised if the provided array contains an object which does not adopt the `PMTweening` protocol.
 *
 */
- (instancetype)initWithSequenceSteps:(NSArray *)sequenceSteps options:(PMTweenOptions)options;


///-------------------------------------
/// @name Setting Up a Sequence
///-------------------------------------

/**
 *  Adds a sequence step to the end of the sequence.
 *
 *  @param sequenceStep  An object which conforms to the `PMTweening` protocol.
 *  @param useTweenTempo When `YES`, the tween object should use its own tempo to update its tween progress, and thus the `updateWithTimeInterval:currentTime:` method will not be called on the object by the PMTweenSequence instance.
 *
 *  @warning A NSInternalInconsistencyException will be raised if the provided object does not adopt the `PMTweening` protocol.
 *
 */
- (void)addSequenceStep:(NSObject<PMTweening> *)sequenceStep useTweenTempo:(BOOL)useTweenTempo;

/**
 *  Removes the specified object from the sequence.
 *
 *  @param sequenceStep The sequence step to remove.
 */
- (void)removeSequenceStep:(NSObject<PMTweening> *)sequenceStep;

/**
 *  The sequence step which is currently tweening, or the first sequence step if this instance's `tweenState` is `PMTweenStateStopped`.
 *
 *  @return The current tween object.
 */
- (NSObject<PMTweening> *)currentSequenceStep;

/**
 *  The delay, in seconds, before a sequence begins.
 *
 *  @warning Setting this parameter after a sequence has begun has no effect.
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
 *  The number of tween cycle operations to repeat.
 *
 *  @remarks This property is only used when the sequence's `repeating` property is set to `YES`. Negative values are clamped to 0. The default value is 0.
 *
 *  @see repeating
 */
@property (nonatomic, assign) NSUInteger numberOfRepeats;

/**
 *  The mode which defines a sequence's behavior when its `reversing` property is set to `YES`.
 *
 *  @remarks The default value is `PMTweenSequenceReversingNoncontiguous`.
 */
@property (nonatomic, assign) PMTweenSequenceReversingMode reversingMode;


///-------------------------------------
/// @name Tween State
///-------------------------------------

/**
 *  An array comprising tween objects which are controlled by this PMTweenSequence object. (read-only)
 *
 *  @remarks The order of objects in this array represents the sequence order in which each will be tweened.
 */
@property (readonly, nonatomic, strong) NSArray *sequenceSteps;

/**
 *  A `PMTweenState` enum which represents the current state of the tween operation. (read-only)
 */
@property (readonly, nonatomic, assign) PMTweenState tweenState;

/**
 *  A `PMTweenDirection` enum which represents the current direction of the tween operation. (read-only)
 */
@property (readonly, nonatomic, assign) PMTweenDirection tweenDirection;


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

/**
 *  This notification block is executed when playback has advanced to the next sequence step.
 */
typedef void (^PMTweenDidStepBlock)(NSObject<PMTweening> *tween);
@property (nonatomic, copy) PMTweenDidStepBlock stepBlock;

/**
 *  This notification is posted when playback has advanced to the next sequence step.
 */
extern NSString *const PMTweenDidStepNotification;





@end
