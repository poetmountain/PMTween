//
//  PMTweenEasingBack.m
//  PMTween
//
//  Created by Brett Walker on 4/13/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenEasingBack.h"

@implementation PMTweenEasingBack

#pragma mark - Easing methods

+ (PMTweenEasingBlock)easingIn {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double overshoot = 1.70158; // defaults to 10% overshoot past the end value
        double time = elapsedTime / duration;
        
        double tween_value = valueDelta * time*time*((overshoot + 1)*time - overshoot) + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double overshoot = 1.70158; // defaults to 10% overshoot past the end value
        double time = elapsedTime / duration;
        
        double tween_value = valueDelta * ((time - 1)*time * ((overshoot + 1)*time + overshoot) + 1) + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingInOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double overshoot = 1.70158; // defaults to 10% overshoot past the end value
        double time = elapsedTime / (duration * 0.5);
        overshoot *= 1.525;
        
        double tween_value = 0;
        if (time < 1) {
            tween_value = (valueDelta * 0.5) * (time*time*((overshoot + 1)*time - overshoot)) + startValue;
        } else {
            time -= 2;
            tween_value = (valueDelta * 0.5) * (time*time*((overshoot + 1)*time + overshoot) + 2) + startValue;
        }
        
        return tween_value;
    };
    
    return easing;
    
}

@end
