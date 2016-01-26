//
//  PMTweenEasingLinear.m
//  PMTween
//
//  Created by Brett Walker on 3/30/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenEasingLinear.h"

@implementation PMTweenEasingLinear


#pragma mark - Easing methods

+ (PMTweenEasingBlock)easingNone {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        double tween_value = valueDelta * (elapsedTime / duration) + startValue;
        
        return tween_value;
    };

    return easing;
}


@end
