//
//  PMTweenEasingBounce.m
//  PMTween
//
//  Created by Brett Walker on 4/14/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenEasingBounce.h"

@implementation PMTweenEasingBounce

#pragma mark - Easing methods

+ (PMTweenEasingBlock)easingIn {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        PMTweenEasingBlock easingBlock = [PMTweenEasingBounce easingOut];
        double tween_value = valueDelta - easingBlock(duration-elapsedTime, 0, valueDelta, duration) + startValue;
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double time = elapsedTime / duration;
        double tween_value = 0;
        
        if (time < (1/2.75)) {
            tween_value = valueDelta * (7.5625 * time*time) + startValue;
        } else if (time < (2 / 2.75)) {
            time -= (1.5 / 2.75);
            tween_value = valueDelta * (7.5625 * time*time + 0.75) + startValue;
        } else if (time < (2.5/2.75)) {
            time -= (2.25/2.75);
            tween_value = valueDelta * (7.5625 *time*time + 0.9375) + startValue;
        } else {
            time -= (2.625/2.75);
            tween_value = valueDelta * (7.5625 *time*time + 0.984375) + startValue;
        }
        
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingInOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double tween_value = 0;
        
        if (elapsedTime < (duration * 0.5)) {
            PMTweenEasingBlock easingBlock = [PMTweenEasingBounce easingOut];
            tween_value = easingBlock(elapsedTime*2, 0, valueDelta, duration) * 0.5 + startValue;
        } else {
            PMTweenEasingBlock easingBlock = [PMTweenEasingBounce easingOut];
            tween_value = easingBlock(elapsedTime*2-duration, 0, valueDelta, duration) * 0.5 + (valueDelta*0.5) + startValue;
        }
        
        return tween_value;
    };
    
    return easing;
    
}

@end
