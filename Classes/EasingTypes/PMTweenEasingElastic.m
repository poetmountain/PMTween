//
//  PMTweenEasingElastic.m
//  PMTween
//
//  Created by Brett Walker on 4/13/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenEasingElastic.h"

@implementation PMTweenEasingElastic

#pragma mark - Easing methods

+ (PMTweenEasingBlock)easingIn {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double overshoot = 1.70158; // defaults to 10% overshoot past the end value
        double period = 0;
        double amplitude = valueDelta;
        
        double tween_value = 0;
        double time = elapsedTime;
        
        if (time == 0) {
            return startValue;
        }
        
        time /= duration;
        if (time == 1) {
            tween_value = startValue + valueDelta;
        } else {
            if (!period) {
                period = duration * 0.3;
            }
            if (amplitude < fabs(valueDelta)) {
                amplitude = valueDelta;
                overshoot = period * 0.25;
            } else {
                overshoot = (period / (M_PI * 2)) * asin(valueDelta / amplitude);
            }
            
            time--;
            tween_value = -(amplitude*pow(2, 10*time) * sin( (time*duration-overshoot) * (2*M_PI)/period)) + startValue;
        }

        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double overshoot = 1.70158; // defaults to 10% overshoot past the end value
        double period = 0;
        double amplitude = valueDelta;
        
        double tween_value = 0;
        double time = elapsedTime;
        
        if (time == 0) {
            return startValue;
        }
        
        time /= duration;
        if (time == 1) {
            tween_value = startValue + valueDelta;
        } else {
            if (!period) {
                period = duration * 0.3;
            }
            if (amplitude < fabs(valueDelta)) {
                amplitude = valueDelta;
                overshoot = period * 0.25;
            } else {
                overshoot = (period / (M_PI * 2)) * asin(valueDelta / amplitude);
            }
            
            tween_value = amplitude*pow(2,-10*time) * sin( (time*duration-overshoot) * (2*M_PI)/period ) + valueDelta + startValue;
        }
        
        return tween_value;
    };
    
    return easing;
    
}

+ (PMTweenEasingBlock)easingInOut {
    
    PMTweenEasingBlock easing = ^double (NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration) {
        
        double overshoot = 1.70158; // defaults to 10% overshoot past the end value
        double period = 0;
        double amplitude = valueDelta;
        
        double tween_value = 0;
        double time = elapsedTime;

        if (time == 0) {
            return startValue;
        }
        
        time /= duration * 0.5;
        if (time == 2) {
            tween_value = startValue + valueDelta;
        } else {
            if (!period) {
                period = duration * (0.3 * 1.5);
            }
            if (amplitude < fabs(valueDelta)) {
                amplitude = valueDelta;
                overshoot = period * 0.25;
            } else {
                overshoot = (period / (M_PI * 2)) * asin(valueDelta / amplitude);
            }
            
            if (time < 1) {
                time--;
                tween_value = -0.5 * (amplitude*pow(2, 10*time) * sin( (time*duration-overshoot) * (2*M_PI)/period )) + startValue;
            } else {

                time--;
                tween_value = amplitude*pow(2, -10*time) * sin( (time*duration-overshoot) * (2*M_PI)/period ) * 0.5 + valueDelta + startValue;
            }

        }
        
        return tween_value;
    };
    
    return easing;
    
}

@end
