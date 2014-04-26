//
//  PMTweenEasingBack.h
//  PMTween
//
//  Created by Brett Walker on 4/13/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenEasing.h"

/**
 *  PMTweenEasingBack provides back easing equations.
 *
 *  @warning These equations produce easing values extending beyond the starting and ending values, which may produce unpredictable results for certain properties having strict bounds limits.
 */

@interface PMTweenEasingBack : NSObject

/**
 *  Back easingIn type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingIn;

/**
 *  Back easingOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingOut;

/**
 *  Back easingInOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingInOut;

@end
