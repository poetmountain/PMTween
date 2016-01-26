//
//  PMTweenEasingSine.h
//  PMTween
//
//  Created by Brett Walker on 4/13/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenEasing.h"

/**
 *  PMTweenEasingSine provides easing equations based on sine.
 */

@interface PMTweenEasingSine : NSObject

/**
 *  Sine easingIn type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingIn;

/**
 *  Sine easingOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingOut;

/**
 *  Sine easingInOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingInOut;

@end
