//
//  PMTweenSupport.h
//  PMTween
//
//  Created by Brett Walker on 1/25/16.
//  Copyright © 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweening.h"

/**
 *  PMTweenSupport provides some utility and internal methods for PMTween classes.
 */

@interface PMTweenSupport : NSObject

// Holds weak references to all currently-tweening PMTweening instances which are tweening an object's property
+ (NSHashTable *)objectTweens;

// Internal method that adds a PMTweening instance to objectTweens
+ (NSUInteger)addTween:(NSObject<PMTweening> *)tween;

// Internal method that removes a PMTweening instance from objectTweens
+ (void)removeTween:(NSObject<PMTweening> *)tween;

// Internal method that returns an incremented operation id, which are used to sort the objectTweens NSHashTable
+ (NSUInteger)currentTweenOperationID;

// Internal method that returns the ending value of the most recent tween operation for the specified object and keyPath. If none, returns nil.
+ (NSValue *)targetValueForObject:(NSObject *)object keyPath:(NSString *)keyPath;

// Utility method which determines whether the value is of the specified Objective-C type.
+ (BOOL)isValue:(NSValue *)value objCType:(const char *)typeToMatch;

// Utility method that returns a getter method selector for a property name string.
+ (SEL)getterForPropertyName:(NSString *)propertyName;

// Utility method that returns a setter method selector for a property name string.
+ (SEL)setterForPropertyName:(NSString *)propertyName;

@end
