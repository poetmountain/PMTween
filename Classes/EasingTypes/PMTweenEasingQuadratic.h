//
//  PMTweenEasingQuadratic.h
//  PMTween
//
//  Created by Brett Walker on 3/30/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenEasing.h"

/**
 *  PMTweenEasingQuadratic provides quadratic easing equations.
 */

@interface PMTweenEasingQuadratic : NSObject

/**
 *  Quadratic easingIn type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingIn;

/**
 *  Quadratic easingOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingOut;

/**
 *  Quadratic easingInOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingInOut;

@end
