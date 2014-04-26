//
//  PMTweenEasingLinear.h
//  PMTween
//
//  Created by Brett Walker on 3/30/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenEasing.h"

/**
 *  PMTweenEasingLinear provides a linear easing equation.
 */

@interface PMTweenEasingLinear : NSObject

/**
 *  Linear easing type.
 *
 *  @return A `PMTweenEasingBlock` block.
 */
+ (PMTweenEasingBlock)easingNone;

@end
