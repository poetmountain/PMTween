//
//  PMTweenEasingBounce.h
//  PMTween
//
//  Created by Brett Walker on 4/14/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenEasing.h"

/**
 *  PMTweenEasingBounce provides easing equations that have successively smaller value peaks, like a bouncing ball.
 */

@interface PMTweenEasingBounce : NSObject

/**
 *  Bounce easingIn type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingIn;

/**
 *  Bounce easingOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingOut;

/**
 *  Bounce easingInOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingInOut;


@end
