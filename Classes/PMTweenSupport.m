//
//  PMTweenUtilities.m
//  PMTween
//
//  Created by Brett Walker on 1/25/16.
//  Copyright © 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenSupport.h"
#import "PMTweenUnit.h"

@implementation PMTweenSupport

#pragma mark - Utility methods

+ (NSHashTable *)objectTweens {
    
    static NSHashTable *tweens = nil;
    static dispatch_once_t only_once;
    dispatch_once(&only_once, ^{
        tweens = [NSHashTable weakObjectsHashTable];
    });
    
    return tweens;
}

+ (NSUInteger)addTween:(NSObject<PMTweening> *)tween {
    NSHashTable *tweens = [PMTweenSupport objectTweens];
    [tweens addObject:tween];
    
    return [PMTweenSupport currentTweenOperationID];
}

+ (void)removeTween:(NSObject<PMTweening> *)tween {
    NSHashTable *tweens = [PMTweenSupport objectTweens];
    [tweens removeObject:tween];
}


+ (NSUInteger)currentTweenOperationID {
    
    static NSNumber *operationID = nil;
    static dispatch_once_t only_once;
    dispatch_once(&only_once, ^{
        operationID = @0;
    });
    
    operationID = @([operationID unsignedIntegerValue] + 1);
    
    return [operationID unsignedIntegerValue];
}


+ (NSValue *)targetValueForObject:(NSObject *)object keyPath:(NSString *)keyPath {
    
    __block NSValue *target_value = nil;
    
    // create an array from the operations NSSet, using the PMTweenUnit's operationID as sort key
    NSSet *tweens_set = [[PMTweenSupport objectTweens] setRepresentation];
    NSSortDescriptor *sort_desc = [NSSortDescriptor sortDescriptorWithKey:@"operationID" ascending:YES];
    NSArray *tweens = [tweens_set sortedArrayUsingDescriptors:@[sort_desc]];
    
    // reverse through the array and find the most recent tween operation that's modifying this object property
    [tweens enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id tween, NSUInteger idx, BOOL *stop) {
        if ([tween isKindOfClass:[PMTweenUnit class]]) {
            PMTweenUnit *unit = (PMTweenUnit *)tween;
            if (unit.targetObject == object && [unit.propertyKeyPath isEqualToString:keyPath]) {
                target_value = [NSNumber numberWithDouble:unit.endingValue];
                *stop = YES;
            }
        }
    }];
    
    
    return target_value;
}


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
