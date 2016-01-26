//
//  PMTweenEasingQuartic.h
//  PMTween
//
//  Created by Brett Walker on 4/13/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenEasing.h"

/**
 *  PMTweenEasingQuartic provides quartic easing equations.
 */

@interface PMTweenEasingQuartic : NSObject

/**
 *  Quartic easingIn type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingIn;

/**
 *  Quartic easingOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingOut;

/**
 *  Quartic easingInOut type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingInOut;

@end
