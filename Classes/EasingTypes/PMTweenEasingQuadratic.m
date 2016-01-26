//
//  PMTweenEasingQuadratic.m
//  PMTween
//
//  Created by Brett Walker on 3/30/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenEasingQuadratic.h"


@implementation PMTweenEasingQuadratic

#pragma mark - Easing methods

+ (PMTweenEasingBlock)easingIn {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        double tween_value = valueDelta * (elapsedTime*elapsedTime) / (duration*duration) + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        double tween_value = -valueDelta * (elapsedTime*elapsedTime) / (duration*duration) + 2*valueDelta*elapsedTime/duration + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingInOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double tween_value = 0;
        if (elapsedTime < duration*0.5) {
            tween_value = 2*valueDelta * (elapsedTime*elapsedTime) / (duration*duration) + startValue;
        } else {
            double time = elapsedTime - (duration*0.5);
            tween_value = -2*valueDelta * (time*time)/(duration*duration) + 2*valueDelta*(time/duration) + (valueDelta*0.5) + startValue;
        }
        
        return tween_value;
    };
    
    return easing;
    
}


@end
