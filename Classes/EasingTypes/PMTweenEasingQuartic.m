//
//  PMTweenEasingQuartic.m
//  PMTween
//
//  Created by Brett Walker on 4/13/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenEasingQuartic.h"

@implementation PMTweenEasingQuartic

#pragma mark - Easing methods

+ (PMTweenEasingBlock)easingIn {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double time = elapsedTime / duration;
        double tween_value = valueDelta * (time*time*time*time) + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double time = elapsedTime / duration;
        time--;
        double tween_value = -valueDelta * (time*time*time*time - 1) + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingInOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double time = elapsedTime / (duration * 0.5);
        
        double tween_value = 0;
        if (time < 1) {
            tween_value = (valueDelta * 0.5) * time*time*time*time + startValue;
        } else {
            time -= 2;
            tween_value = (-valueDelta * 0.5) * (time*time*time*time - 2) + startValue;
        }
        
        return tween_value;
    };
    
    return easing;
    
}

@end
