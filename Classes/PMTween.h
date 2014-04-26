//
//  PMTween.h
//  PMTween
//
//  Created by Brett Walker on 4/10/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenTempo.h"

/**
 *  The `PMTweening` protocol declares methods and properties that must be adopted by custom tweening classes in order to participate in PMTween.
 
    In addition to adopting the required methods, custom tweening classes must also post the `PMTweenDidCompleteNotification` notification in order to properly interact with other PMTween classes.
 */

@protocol PMTweening <NSObject>

///--------------------------
/// @name Controlling a Tween
///--------------------------

/**
 *  Stops a tween that is currently tweening. (required)
 *
 *  @remarks When this method is called, a tween should only enter a stopped state if it currently tweening.
 */
- (void)stopTween;

/**
 *  Starts a tween that is currently stopped. (required)
 *
 *  @remarks When this method is called, a tween should only start tweening if it is stopped.
 */
- (void)startTween;

/**
 *  Pauses a tween that is currently tweening. (required)
 *
 *  @remarks When this method is called, a tween should only enter a paused state if it is currently tweening.
 */
- (void)pauseTween;

/**
 *  Resumes a tween that is currently paused. (required)
 *
 *  @remarks When this method is called, a tween should only resume tweening if it is currently paused.
 */
- (void)resumeTween;

/**
 *  A Boolean which determines whether a tween operation, when it has tweened to the ending value, should tween from the ending value back to the starting value.
 *
 *  @remarks When set to `YES`, the tween plays in reverse after completing a forward tween. In this state, a tween cycle represents the combination of the forward and back tweens. The default value is `NO`.
 */
@property (nonatomic, assign, getter = isReversing) BOOL reversing;

/**
 *  A concrete `PMTweenTempo` subclass that provides an update "beat" while a tween operation occurs.
 *
 *  @remarks While you don't have to implement PMTweenTempo for your own class updating, other tween collection classes like `PMTweenGroup` will try to remove any tempos of tween objects added to them.
 */
@property (nonatomic, strong) PMTweenTempo *tempo;


///-----------------------
/// @name Updating a Tween
///-----------------------

/**
 *  This method is called to prompt a tweening class to update its current tween values.
 *
 *  @param currentTime A timestamp that can be used in easing calculations.
 */
- (void)updateWithTimeInterval:(NSTimeInterval)currentTime;


///--------------------
/// @name Notifications
///--------------------

/**
 *  Classes adopting the PMTweening protocol must post this notification when its tween operation has fully completed.
 *
 *  @remarks A completion notification should only be posted when all activity related to the tween has ceased. For instance, if a tween class allows a tween to be repeated multiple times, this notification should only be posted when all repetitions have finished.
 */
extern NSString *const PMTweenDidCompleteNotification;

/**
 *  Classes adopting the PMTweening protocol must post this notification when its tween operation has completed half of its length.
 *
 *  @remarks This notification should only be posted when half of the activity related to the tween has ceased. For instance, if a tween class is set to repeat two times and its `reversing` property is set to `YES`, it should post this notification after the second reversal of direction.
 */
extern NSString *const PMTweenHalfCompletedNotification;


@optional

/**
 *  This notification should be posted when the `startTween` method starts a tween operation. If a delay has been specified, this notification is posted after the delay is complete.
 *
 *  @see startTween
 */
extern NSString *const PMTweenDidStartNotification;

/**
 *  This notification should be posted when the `stopTween` method stops a tween operation.
 *
 *  @see stopTween
 */
extern NSString *const PMTweenDidStopNotification;

/**
 *  This notification should be posted when calling the `pauseTween` method pauses a tween operation.
 *
 *  @see pauseTween
 */
extern NSString *const PMTweenDidPauseNotification;

/**
 *  This notification should be posted when calling the `resumeTween` method resumes a tween operation.
 *
 *  @see resumeTween
 */
extern NSString *const PMTweenDidResumeNotification;

/**
 *  This notification is posted when a tween operation reverses its tweening direction.
 *
 *  @see reversing
 */
extern NSString *const PMTweenDidReverseNotification;

/**
 *  This notification should be posted when a tween cycle has completed.
 */
extern NSString *const PMTweenDidRepeatNotification;

@end


///-------------------------------------
/// @name Notification Blocks
///-------------------------------------

/**
 *  This notification block should be executed when the `startTween` method starts a tween operation. If a delay has been specified, this block is executed after the delay is complete.
 *
 *  @see startTween
 */
typedef void (^PMTweenDidStartBlock)(NSObject<PMTweening> *tween);

/**
 *  This notification block should be executed when the `stopTween` method stops a tween operation.
 *
 *  @see stopTween
 */
typedef void (^PMTweenDidStopBlock)(NSObject<PMTweening> *tween);

/**
 *  This notification block should be executed when the `updateWithTimeInterval:currentTime:` method is called while a tween object is currently tweening.
 *
 *  @see updateWithTimeInterval:currentTime:
 */
typedef void (^PMTweenDidUpdateBlock)(NSObject<PMTweening> *tween);

/**
 *  This notification block should be executed when a tween operation reverses its tweening direction.
 */
typedef void (^PMTweenDidReverseBlock)(NSObject<PMTweening> *tween);

/**
 *  This notification block should be executed when a tween has repeated.
 */
typedef void (^PMTweenDidRepeatBlock)(NSObject<PMTweening> *tween);

/**
 *  This notification block should be executed when calling the `pauseTween` method pauses a tween operation.
 *
 *  @see pauseTween
 */
typedef void (^PMTweenDidPauseBlock)(NSObject<PMTweening> *tween);

/**
 *  This notification block should be executed when calling the `resumeTween` method pauses a tween operation.
 *
 *  @see resumeTween
 */
typedef void (^PMTweenDidResumeBlock)(NSObject<PMTweening> *tween);

/**
 *  This notification block should be executed when a tween operation has fully completed.
 *
 *  @remarks This block should only be executed when all activity related to the tween has ceased. For instance, if a tween class allows a tween to be repeated multiple times, this notification should only be posted when all repetitions have finished.
 */
typedef void (^PMTweenDidCompleteBlock)(NSObject<PMTweening> *tween);


///-------------------------------------
/// @name Constants
///-------------------------------------

/**
 *  Enum representing the direction a tween is tweening in.
 */
typedef NS_ENUM(NSInteger, PMTweenDirection) {
    /**
     *  The tween is tweening in a forward direction, from the starting value to the ending value.
     */
    PMTweenDirectionForward,
    /**
     *  The tween is tweening in a reverse direction, from the ending value to the starting value.
     */
    PMTweenDirectionReverse
};

/**
 *  Enum representing the state of a tween operation.
 */
typedef NS_ENUM(NSInteger, PMTweenState) {
    /**
     *  The state of a tweening operation when it is tweening.
     */
    PMTweenStateTweening,
    /**
     *  The state of a tweening operation when it is stopped.
     */
    PMTweenStateStopped,
    /**
     *  The state of a tweening operation when it is paused.
     */
    PMTweenStatePaused,
    /**
     *  The state of a tweening operation when it is delayed.
     */
    PMTweenStateDelayed
};

/**
 *  The mode used to define a sequence's behavior when its `reversing` property is set to `YES`.
 */
typedef NS_ENUM(NSInteger, PMTweenSequenceReversingMode) {
    /**
     *  Specifies that sequence steps play in reverse when the sequence's `tweenDirection` property is `PMTweenDirectionReverse`.
     *
     *  @remarks This mode is useful if you want to create a sequence whose tween steps reverse in a mirror image of their forward tweening.
     */
    PMTweenSequenceReversingContiguous,
    
    /**
     *  Specifies that sequence steps play forwards when the sequence's `tweenDirection` property is `PMTweenDirectionReverse`.
     *
     *  @remarks This mode is useful if you want sequence steps to tween consistently, regardless of the state of the sequence's `tweenDirection` property.
     */
    PMTweenSequenceReversingNoncontiguous
};

/**
 *  An integer bitmask providing possible initialization options for a tweening operation.
 */
typedef NS_OPTIONS(NSInteger, PMTweenOptions) {
    /**
     *  No tween options are specified.
     */
    PMTweenOptionNone                   = 0,
    /**
     *  Specifies that a tween should repeat.
     */
    PMTweenOptionRepeat                 = 1 << 0,
    /**
     *  Specifies that a tween should reverse directions after tweening forwards.
     */
    PMTweenOptionReverse                = 1 << 1,
    
    /**
     *  Specifies that a tween's property (or parent, if property is not KVC-compliant) should be reset on repeats or restarts.
     */
    PMTweenOptionResetStateOnRepeat     = 1 << 2
};

/**
 *  PMTween is a flexible and modular tweening library for iOS. This base class holds common enums, blocks, and notifications, and defines the `PMTweening` protocol.
 */

@interface PMTween : NSObject

// Utility method which determines whether the value is of the specified Objective-C type.
+ (BOOL)isValue:(NSValue *)value objCType:(const char *)typeToMatch;

// Utility method that returns a getter method selector for a property name string.
+ (SEL)getterForPropertyName:(NSString *)propertyName;

// Utility method that returns a setter method selector for a property name string.
+ (SEL)setterForPropertyName:(NSString *)propertyName;

@end
