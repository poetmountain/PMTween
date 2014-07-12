//
//  PMTween.m
//  PMTween
//
//  Created by Brett Walker on 4/10/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTween.h"
#import "PMTweenUnit.h"

NSString *const PMTweenDidStartNotification = @"com.poetmountain.pmtween.start";
NSString *const PMTweenDidStopNotification = @"com.poetmountain.pmtween.stop";
NSString *const PMTweenDidReverseNotification = @"com.poetmountain.pmtween.reverse";
NSString *const PMTweenDidPauseNotification = @"com.poetmountain.pmtween.pause";
NSString *const PMTweenDidResumeNotification = @"com.poetmountain.pmtween.resume";
NSString *const PMTweenDidRepeatNotification = @"com.poetmountain.pmtween.repeat";
NSString *const PMTweenDidCompleteNotification = @"com.poetmountain.pmtween.complete";
NSString *const PMTweenHalfCompletedNotification = @"com.poetmountain.pmtween.halfcomplete";

@implementation PMTween

+ (NSHashTable *)objectTweens {
    
    static NSHashTable *tweens = nil;
    static dispatch_once_t only_once;
    dispatch_once(&only_once, ^{
        tweens = [NSHashTable weakObjectsHashTable];
    });
    
    return tweens;
}

+ (NSUInteger)addTween:(PMTweenUnit *)tween {
    NSHashTable *tweens = [PMTween objectTweens];
    [tweens addObject:tween];
    
    return [PMTween currentTweenOperationID];
}

+ (void)removeTween:(PMTweenUnit *)tween {
    NSHashTable *tweens = [PMTween objectTweens];
    [tweens removeObject:tween];
}


+ (NSUInteger)currentTweenOperationID {
    
    static NSNumber *operationID = nil;
    static dispatch_once_t only_once;
    dispatch_once(&only_once, ^{
        operationID = @0;
    });
    
    operationID = @([operationID integerValue] + 1);
    
    return [operationID integerValue];
}


+ (NSValue *)targetValueForObject:(NSObject *)object keyPath:(NSString *)keyPath {
    
    __block NSValue *target_value = nil;
    
    // create an array from the operations NSSet, using the PMTweenUnit's operationID as sort key
    NSSet *tweens_set = [[PMTween objectTweens] setRepresentation];
    NSSortDescriptor *sort_desc = [NSSortDescriptor sortDescriptorWithKey:@"operationID" ascending:YES];
    NSArray *tweens = [tweens_set sortedArrayUsingDescriptors:@[sort_desc]];
        
    // reverse through the array and find the most recent tween operation that's modifying this object property
    [tweens enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PMTweenUnit *tween, NSUInteger idx, BOOL *stop) {
        if (tween.targetObject == object && tween.propertyKeyPath == keyPath) {
            target_value = [NSNumber numberWithDouble:tween.endingValue];
            *stop = YES;
        }
    }];
    
    
    return target_value;
}


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
