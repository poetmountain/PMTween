//
//  PMTweenStructUpdater.m
//  PMTween
//
//  Created by Brett Walker on 4/23/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenObjectUpdater.h"
#import "PMTween.h"

@implementation PMTweenObjectUpdater

+ (instancetype)updater {
    
    PMTweenObjectUpdater *updater = [[PMTweenObjectUpdater alloc] init];
    
    return updater;
}


- (BOOL)supportsObject:(NSObject *)object {
    
    BOOL is_supported = NO;
    
    if ([object isKindOfClass:[NSValue class]]) {
        NSValue *value = (NSValue *)object;
        if (
            [object isKindOfClass:[NSNumber class]]
            || [PMTween isValue:value objCType:@encode(CGPoint)]
            || [PMTween isValue:value objCType:@encode(CGSize)]
            || [PMTween isValue:value objCType:@encode(CGRect)]
            || [PMTween isValue:value objCType:@encode(CGAffineTransform)]
            || [PMTween isValue:value objCType:@encode(CATransform3D)]
            ) {
            
            is_supported = YES;
        }
    } else if (
               [object isKindOfClass:[UIColor class]]
               || [object isKindOfClass:[CIColor class]]
               ) {
        is_supported = YES;
    }
    

    
    
    return is_supported;
    
}

- (NSObject *)replaceObject:(NSObject *)objectToUpdate newPropertyValue:(double)propertyValue propertyKeyPath:(NSString *)propertyKeyPath {
    
    NSObject *new_parent_value = nil;
    
    NSMutableArray *keys = [[propertyKeyPath componentsSeparatedByString:@"."] mutableCopy];
    
    if ([objectToUpdate isKindOfClass:[NSValue class]]) {
        NSValue *valueObject = (NSValue *)objectToUpdate;
        
        // get encoding of base parent's objective-c type
        if ([objectToUpdate isKindOfClass:[NSNumber class]]) {
            new_parent_value = [NSNumber numberWithDouble:propertyValue];
            
        } else if ([PMTween isValue:valueObject objCType:@encode(CGPoint)]) {
            CGPoint point = [valueObject CGPointValue];
            
            if ([[keys lastObject] isEqualToString:@"x"]) {
                point.x = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"y"]) {
                point.y = propertyValue;
            } else {
                // assume the last key is the cgpoint and change both x and y
                point.x = propertyValue;
                point.y = propertyValue;
            }
            
            new_parent_value = [NSValue valueWithCGPoint:point];
            
        } else if ([PMTween isValue:valueObject objCType:@encode(CGSize)]) {
            CGSize size = [valueObject CGSizeValue];
            
            if ([[keys lastObject] isEqualToString:@"width"]) {
                size.width = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"height"]) {
                size.height = propertyValue;
            } else {
                // assume the last key is the cgsize and change both width and height
                size.width = propertyValue;
                size.height = propertyValue;
            }
 
            new_parent_value = [NSValue valueWithCGSize:size];
            
        } else if ([PMTween isValue:valueObject objCType:@encode(CGRect)]) {
            CGRect rect = [valueObject CGRectValue];
            NSUInteger last_index = [keys count] - 1;
            
            if ([keys[last_index-1] isEqualToString:@"origin"]) {
                CGPoint point = rect.origin;
                
                if ([[keys lastObject] isEqualToString:@"x"]) {
                    point.x = propertyValue;
                } else if ([[keys lastObject] isEqualToString:@"y"]) {
                    point.y = propertyValue;
                } else {
                    point.x = propertyValue;
                    point.y = propertyValue;
                }

                rect.origin = point;
            } else if ([[keys lastObject] isEqualToString:@"origin"]) {
                CGPoint point = rect.origin;
                
                point.x = propertyValue;
                point.y = propertyValue;
                
                rect.origin = point;
            
            } else if ([keys[last_index-1] isEqualToString:@"size"]) {
                CGSize size = rect.size;
                
                if ([[keys lastObject] isEqualToString:@"width"]) {
                    size.width = propertyValue;
                } else if ([[keys lastObject] isEqualToString:@"height"]) {
                    size.height = propertyValue;
                } else {
                    size.width = propertyValue;
                    size.height = propertyValue;
                }

                rect.size = size;
                                
            } else if ([[keys lastObject] isEqualToString:@"size"]) {
                CGSize size = rect.size;

                size.width = propertyValue;
                size.height = propertyValue;
                
                rect.size = size;
            }
            
            new_parent_value = [NSValue valueWithCGRect:rect];
            
        } else if ([PMTween isValue:valueObject objCType:@encode(CGAffineTransform)]) {
            CGAffineTransform transform = [valueObject CGAffineTransformValue];
            
            if ([[keys lastObject] isEqualToString:@"a"]) {
                transform.a = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"b"]) {
                transform.b = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"c"]) {
                transform.c = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"d"]) {
                transform.d = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"tx"]) {
                transform.tx = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"ty"]) {
                transform.ty = propertyValue;
            }
            
            new_parent_value = [NSValue valueWithCGAffineTransform:transform];
            
        } else if ([PMTween isValue:valueObject objCType:@encode(CATransform3D)]) {
            CATransform3D transform = [valueObject CATransform3DValue];
            
            if ([[keys lastObject] isEqualToString:@"m11"]) {
                transform.m11 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m12"]) {
                transform.m12 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m13"]) {
                transform.m13 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m14"]) {
                transform.m14 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m21"]) {
                transform.m21 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m22"]) {
                transform.m22 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m23"]) {
                transform.m23 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m24"]) {
                transform.m24 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m31"]) {
                transform.m31 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m32"]) {
                transform.m32 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m33"]) {
                transform.m33 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m34"]) {
                transform.m34 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m41"]) {
                transform.m41 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m42"]) {
                transform.m42 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m43"]) {
                transform.m43 = propertyValue;
            } else if ([[keys lastObject] isEqualToString:@"m44"]) {
                transform.m44 = propertyValue;
            }
            
            new_parent_value = [NSValue valueWithCATransform3D:transform];
            
        }
    } else if ([objectToUpdate isKindOfClass:[UIColor class]]) {
        UIColor *new_color = nil;
        
        NSString *component_name = [keys lastObject];
        UIColor *old_color = (UIColor *)objectToUpdate;
        
        if ([component_name isEqualToString:@"hue"]) {
            CGFloat hue, saturation, brightness, alpha;
            [old_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            new_color = [UIColor colorWithHue:propertyValue saturation:saturation brightness:brightness alpha:alpha];
            
        } else if ([component_name isEqualToString:@"saturation"]) {
            CGFloat hue, saturation, brightness, alpha;
            [old_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            new_color = [UIColor colorWithHue:hue saturation:propertyValue brightness:brightness alpha:alpha];
            
        } else if ([component_name isEqualToString:@"brightness"]) {
            CGFloat hue, saturation, brightness, alpha;
            [old_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            new_color = [UIColor colorWithHue:hue saturation:saturation brightness:propertyValue alpha:alpha];
            
        } else if ([component_name isEqualToString:@"alpha"]) {
            CGFloat hue, saturation, brightness, alpha;
            [old_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            new_color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:propertyValue];
            
        } else if ([component_name isEqualToString:@"red"]) {
            CGFloat red, green, blue, alpha;
            [old_color getRed:&red green:&green blue:&blue alpha:&alpha];
            new_color = [UIColor colorWithRed:propertyValue green:green blue:blue alpha:alpha];
            
        }  else if ([component_name isEqualToString:@"green"]) {
            CGFloat red, green, blue, alpha;
            [old_color getRed:&red green:&green blue:&blue alpha:&alpha];
            new_color = [UIColor colorWithRed:red green:propertyValue blue:blue alpha:alpha];
            
        }  else if ([component_name isEqualToString:@"blue"]) {
            CGFloat red, green, blue, alpha;
            [old_color getRed:&red green:&green blue:&blue alpha:&alpha];
            new_color = [UIColor colorWithRed:red green:green blue:propertyValue alpha:alpha];
        }

        new_parent_value = new_color;
        
    } else if ([objectToUpdate isKindOfClass:[CIColor class]]) {
        CIColor *new_color = nil;
        
        NSString *component_name = [keys lastObject];
        CIColor *old_color = (CIColor *)objectToUpdate;
        
        if ([component_name isEqualToString:@"alpha"]) {
            new_color = [CIColor colorWithRed:old_color.red green:old_color.green blue:old_color.blue alpha:propertyValue];
            
        } else if ([component_name isEqualToString:@"red"]) {
            new_color = [CIColor colorWithRed:propertyValue green:old_color.green blue:old_color.blue alpha:old_color.alpha];

        }  else if ([component_name isEqualToString:@"green"]) {
            new_color = [CIColor colorWithRed:old_color.red green:propertyValue blue:old_color.blue alpha:old_color.alpha];
            
        }  else if ([component_name isEqualToString:@"blue"]) {
            new_color = [CIColor colorWithRed:old_color.red green:old_color.green blue:propertyValue alpha:old_color.alpha];

        }
        
        new_parent_value = new_color;
    }
    
    return new_parent_value;
}

@end
