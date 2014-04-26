//
//  PMTweenEasingSine.m
//  PMTween
//
//  Created by Brett Walker on 4/13/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenEasingSine.h"

@implementation PMTweenEasingSine

#pragma mark - Easing methods

+ (PMTweenEasingBlock)easingIn {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double tween_value = -valueDelta * cos((elapsedTime / duration) * M_PI_2) + valueDelta + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double tween_value = valueDelta * sin((elapsedTime / duration) * M_PI_2) + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingInOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double tween_value = (-valueDelta * 0.5) * (cos(M_PI * (elapsedTime / duration)) - 1) + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

@end
