//
//  PMTweenEasingQuintic.h
//  PMTween
//
//  Created by Brett Walker on 4/13/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenEasing.h"

/**
 *  PMTweenEasingQuintic provides quintic easing equations.
 */

@interface PMTweenEasingQuintic : NSObject

/**
 *  Quintic easingIn type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingIn;

/**
 *  Quintic easingOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingOut;

/**
 *  Quintic easingInOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingInOut;

@end
