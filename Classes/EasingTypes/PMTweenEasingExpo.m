//
//  PMTweenEasingExpo.m
//  PMTween
//
//  Created by Brett Walker on 4/13/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenEasingExpo.h"

@implementation PMTweenEasingExpo

#pragma mark - Easing methods

+ (PMTweenEasingBlock)easingIn {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double tween_value = (elapsedTime == 0) ? startValue : valueDelta * pow(2, 10 * (elapsedTime/duration - 1)) + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double tween_value = (elapsedTime == duration) ? startValue+valueDelta : valueDelta * (-pow(2, -10 * elapsedTime/duration) + 1) + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingInOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double tween_value = 0;
        double time = elapsedTime;
        
        if (time == 0) {
            tween_value = startValue;
            
        } else if (time == duration) {
            tween_value = startValue + valueDelta;
            
        } else {
            time /= (duration * 0.5);
            if (time < 1) {
                tween_value = valueDelta / 2 * pow(2, 10 * (time - 1)) + startValue;
                
            } else {
                time--;
                tween_value = valueDelta / 2 * (-pow(2, -10 * time) + 2) + startValue;
            }
        }
        
        return tween_value;
    };
    
    return easing;
    
}

@end
