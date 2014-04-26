//
//  PMTween.m
//  PMTween
//
//  Created by Brett Walker on 4/10/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTween.h"

NSString *const PMTweenDidStartNotification = @"com.poetmountain.pmtween.start";
NSString *const PMTweenDidStopNotification = @"com.poetmountain.pmtween.stop";
NSString *const PMTweenDidReverseNotification = @"com.poetmountain.pmtween.reverse";
NSString *const PMTweenDidPauseNotification = @"com.poetmountain.pmtween.pause";
NSString *const PMTweenDidResumeNotification = @"com.poetmountain.pmtween.resume";
NSString *const PMTweenDidRepeatNotification = @"com.poetmountain.pmtween.repeat";
NSString *const PMTweenDidCompleteNotification = @"com.poetmountain.pmtween.complete";
NSString *const PMTweenHalfCompletedNotification = @"com.poetmountain.pmtween.halfcomplete";

@implementation PMTween

#pragma mark - Utility methods

+ (BOOL)isValue:(NSValue *)value objCType:(const char *)typeToMatch {
    BOOL is_matching = NO;
    
    const char* value_type = [value objCType];
    is_matching = (strcmp(value_type, typeToMatch)==0);
    
    
    return is_matching;
}

+ (SEL)getterForPropertyName:(NSString *)propertyName {
    SEL selector = nil;
    
    if (propertyName) {
        selector = NSSelectorFromString(propertyName);
    }
    
    return selector;
}

+ (SEL)setterForPropertyName:(NSString *)propertyName {
    SEL selector = nil;
    
    if (propertyName) {
        NSMutableString *mutable_name = [propertyName mutableCopy];
        NSString *capped_first_letter = [[propertyName substringToIndex:1] capitalizedString];
        [mutable_name replaceCharactersInRange:NSMakeRange(0, 1) withString:capped_first_letter];
        NSString *setter_string = [NSString stringWithFormat:@"%@%@:", @"set", mutable_name];
        selector = NSSelectorFromString(setter_string);
    }
    
    return selector;
}

@end
