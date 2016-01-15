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


- (instancetype)init {
    self = [super init];
    
    if (self) {
        _additiveUpdates = NO;
    }
    
    return self;
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
            || [PMTween isValue:value objCType:@encode(CGVector)]
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
        
    double new_property_value = propertyValue;
    
    if ([objectToUpdate isKindOfClass:[NSValue class]]) {
        NSValue *valueObject = (NSValue *)objectToUpdate;
        
        // get encoding of base parent's objective-c type
        if ([objectToUpdate isKindOfClass:[NSNumber class]]) {

            if (_additiveUpdates) {
                new_property_value = [(NSNumber *)objectToUpdate doubleValue] + propertyValue;
            }
            
            new_parent_value = [NSNumber numberWithDouble:new_property_value];
            
        } else if ([PMTween isValue:valueObject objCType:@encode(CGPoint)]) {
            CGPoint point = [valueObject CGPointValue];
            
            if ([[keys lastObject] isEqualToString:@"x"]) {
                if (_additiveUpdates) {
                    new_property_value = point.x + propertyValue;
                }
                point.x = new_property_value;
                
            } else if ([[keys lastObject] isEqualToString:@"y"]) {
                if (_additiveUpdates) {
                    new_property_value = point.y + propertyValue;
                }
                point.y = new_property_value;
                
            } else {
                // assume the last key is the cgpoint and change both x and y
                if (_additiveUpdates) {
                    new_property_value = point.x + propertyValue;
                }
                point.x = new_property_value;
                point.y = new_property_value;
            }
            
            new_parent_value = [NSValue valueWithCGPoint:point];
            
        } else if ([PMTween isValue:valueObject objCType:@encode(CGSize)]) {
            CGSize size = [valueObject CGSizeValue];
            
            if ([[keys lastObject] isEqualToString:@"width"]) {
                if (_additiveUpdates) {
                    new_property_value = size.width + propertyValue;
                }
                size.width = new_property_value;
                
            } else if ([[keys lastObject] isEqualToString:@"height"]) {
                if (_additiveUpdates) {
                    new_property_value = size.height + propertyValue;
                }
                size.height = new_property_value;
                
            } else {
                // assume the last key is the cgsize and change both width and height
                if (_additiveUpdates) {
                    new_property_value = size.width + propertyValue;
                }
                size.width = new_property_value;
                size.height = new_property_value;
            }
 
            new_parent_value = [NSValue valueWithCGSize:size];
            
        } else if ([PMTween isValue:valueObject objCType:@encode(CGRect)]) {
            CGRect rect = [valueObject CGRectValue];
            NSUInteger last_index = [keys count] - 1;
            
            if ([keys[last_index-1] isEqualToString:@"origin"]) {
                CGPoint point = rect.origin;
                
                if ([[keys lastObject] isEqualToString:@"x"]) {
                    if (_additiveUpdates) {
                        new_property_value = point.x + propertyValue;
                    }
                    point.x = new_property_value;
                    
                } else if ([[keys lastObject] isEqualToString:@"y"]) {
                    if (_additiveUpdates) {
                        new_property_value = point.y + propertyValue;
                    }
                    point.y = new_property_value;
                    
                } else {
                    // assume the last key is the CGRect and change both x and y
                    if (_additiveUpdates) {
                        new_property_value = point.x + propertyValue;
                    }
                    point.x = new_property_value;
                    point.y = new_property_value;
                }

                rect.origin = point;
            } else if ([[keys lastObject] isEqualToString:@"origin"]) {
                CGPoint point = rect.origin;
                if (_additiveUpdates) { new_property_value = point.x + propertyValue; }
                point.x = new_property_value;
                point.y = new_property_value;
                
                rect.origin = point;
            
            } else if ([keys[last_index-1] isEqualToString:@"size"]) {
                CGSize size = rect.size;
                
                if ([[keys lastObject] isEqualToString:@"width"]) {
                    if (_additiveUpdates) {
                        new_property_value = size.width + propertyValue;
                    }
                    size.width = new_property_value;
                    
                } else if ([[keys lastObject] isEqualToString:@"height"]) {
                    if (_additiveUpdates) {
                        new_property_value = size.height + propertyValue;
                    }
                    size.height = new_property_value;
                    
                } else {
                    if (_additiveUpdates) {
                        new_property_value = size.width + propertyValue;
                    }
                    size.width = new_property_value;
                    size.height = new_property_value;
                }

                rect.size = size;
                                
            } else if ([[keys lastObject] isEqualToString:@"size"]) {
                CGSize size = rect.size;
                if (_additiveUpdates) { new_property_value = size.width + propertyValue; }
                size.width = new_property_value;
                size.height = new_property_value;
                
                rect.size = size;
            }
            
            new_parent_value = [NSValue valueWithCGRect:rect];
            
            
        } else if ([PMTween isValue:valueObject objCType:@encode(CGVector)]) {
            CGVector vector = [valueObject CGVectorValue];
            
            if ([[keys lastObject] isEqualToString:@"dx"]) {
                if (_additiveUpdates) {
                    new_property_value = vector.dx + propertyValue;
                }
                vector.dx = new_property_value;
                
            } else if ([[keys lastObject] isEqualToString:@"dy"]) {
                if (_additiveUpdates) {
                    new_property_value = vector.dy + propertyValue;
                }
                vector.dy = new_property_value;
                
            } else {
                // assume the last key is the cgvector and change both dx and dy
                if (_additiveUpdates) {
                    new_property_value = vector.dx + propertyValue;
                }
                vector.dx = new_property_value;
                vector.dy = new_property_value;
            }
            
            new_parent_value = [NSValue valueWithCGVector:vector];
        
        
        } else if ([PMTween isValue:valueObject objCType:@encode(CGAffineTransform)]) {
            CGAffineTransform transform = [valueObject CGAffineTransformValue];
            
            if ([[keys lastObject] isEqualToString:@"a"]) {
                if (_additiveUpdates) { new_property_value = transform.a + new_property_value; }
                transform.a = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"b"]) {
                if (_additiveUpdates) { new_property_value = transform.b + new_property_value; }
                transform.b = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"c"]) {
                if (_additiveUpdates) { new_property_value = transform.c + new_property_value; }
                transform.c = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"d"]) {
                if (_additiveUpdates) { new_property_value = transform.d + new_property_value; }
                transform.d = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"tx"]) {
                if (_additiveUpdates) { new_property_value = transform.tx + new_property_value; }
                transform.tx = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"ty"]) {
                if (_additiveUpdates) { new_property_value = transform.ty + new_property_value; }
                transform.ty = new_property_value;
            }
            
            new_parent_value = [NSValue valueWithCGAffineTransform:transform];
            
        } else if ([PMTween isValue:valueObject objCType:@encode(CATransform3D)]) {
            CATransform3D transform = [valueObject CATransform3DValue];
            
            if ([[keys lastObject] isEqualToString:@"m11"]) {
                if (_additiveUpdates) { new_property_value = transform.m11 + new_property_value; }
                transform.m11 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m12"]) {
                if (_additiveUpdates) { new_property_value = transform.m12 + new_property_value; }
                transform.m12 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m13"]) {
                if (_additiveUpdates) { new_property_value = transform.m13 + new_property_value; }
                transform.m13 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m14"]) {
                if (_additiveUpdates) { new_property_value = transform.m14 + new_property_value; }
                transform.m14 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m21"]) {
                if (_additiveUpdates) { new_property_value = transform.m21 + new_property_value; }
                transform.m21 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m22"]) {
                if (_additiveUpdates) { new_property_value = transform.m22 + new_property_value; }
                transform.m22 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m23"]) {
                if (_additiveUpdates) { new_property_value = transform.m23 + new_property_value; }
                transform.m23 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m24"]) {
                if (_additiveUpdates) { new_property_value = transform.m24 + new_property_value; }
                transform.m24 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m31"]) {
                if (_additiveUpdates) { new_property_value = transform.m31 + new_property_value; }
                transform.m31 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m32"]) {
                if (_additiveUpdates) { new_property_value = transform.m32 + new_property_value; }
                transform.m32 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m33"]) {
                if (_additiveUpdates) { new_property_value = transform.m33 + new_property_value; }
                transform.m33 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m34"]) {
                if (_additiveUpdates) { new_property_value = transform.m34 + new_property_value; }
                transform.m34 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m41"]) {
                if (_additiveUpdates) { new_property_value = transform.m41 + new_property_value; }
                transform.m41 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m42"]) {
                if (_additiveUpdates) { new_property_value = transform.m42 + new_property_value; }
                transform.m42 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m43"]) {
                if (_additiveUpdates) { new_property_value = transform.m43 + new_property_value; }
                transform.m43 = new_property_value;
            } else if ([[keys lastObject] isEqualToString:@"m44"]) {
                if (_additiveUpdates) { new_property_value = transform.m44 + new_property_value; }
                transform.m44 = new_property_value;
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
            if (_additiveUpdates) { new_property_value = hue + new_property_value; }
            new_color = [UIColor colorWithHue:new_property_value saturation:saturation brightness:brightness alpha:alpha];
            
        } else if ([component_name isEqualToString:@"saturation"]) {
            CGFloat hue, saturation, brightness, alpha;
            [old_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            if (_additiveUpdates) { new_property_value = saturation + new_property_value; }
            new_color = [UIColor colorWithHue:hue saturation:new_property_value brightness:brightness alpha:alpha];
            
        } else if ([component_name isEqualToString:@"brightness"]) {
            CGFloat hue, saturation, brightness, alpha;
            [old_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            if (_additiveUpdates) { new_property_value = brightness + new_property_value; }
            new_color = [UIColor colorWithHue:hue saturation:saturation brightness:new_property_value alpha:alpha];
            
        } else if ([component_name isEqualToString:@"alpha"]) {
            CGFloat hue, saturation, brightness, alpha;
            [old_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            if (_additiveUpdates) { new_property_value = alpha + new_property_value; }
            new_color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:new_property_value];
            
        } else if ([component_name isEqualToString:@"red"]) {
            CGFloat red, green, blue, alpha;
            [old_color getRed:&red green:&green blue:&blue alpha:&alpha];
            if (_additiveUpdates) { new_property_value = red + new_property_value; }
            new_color = [UIColor colorWithRed:new_property_value green:green blue:blue alpha:alpha];
            
        }  else if ([component_name isEqualToString:@"green"]) {
            CGFloat red, green, blue, alpha;
            [old_color getRed:&red green:&green blue:&blue alpha:&alpha];
            if (_additiveUpdates) { new_property_value = green + new_property_value; }
            new_color = [UIColor colorWithRed:red green:new_property_value blue:blue alpha:alpha];
            
        }  else if ([component_name isEqualToString:@"blue"]) {
            CGFloat red, green, blue, alpha;
            [old_color getRed:&red green:&green blue:&blue alpha:&alpha];
            if (_additiveUpdates) { new_property_value = blue + new_property_value; }
            new_color = [UIColor colorWithRed:red green:green blue:new_property_value alpha:alpha];
        }

        new_parent_value = new_color;
        
    } else if ([objectToUpdate isKindOfClass:[CIColor class]]) {
        CIColor *new_color = nil;
        
        NSString *component_name = [keys lastObject];
        CIColor *old_color = (CIColor *)objectToUpdate;
        
        if ([component_name isEqualToString:@"alpha"]) {
            if (_additiveUpdates) { new_property_value = old_color.alpha + new_property_value; }
            new_color = [CIColor colorWithRed:old_color.red green:old_color.green blue:old_color.blue alpha:new_property_value];
            
        } else if ([component_name isEqualToString:@"red"]) {
            if (_additiveUpdates) { new_property_value = old_color.red + new_property_value; }
            new_color = [CIColor colorWithRed:new_property_value green:old_color.green blue:old_color.blue alpha:old_color.alpha];

        }  else if ([component_name isEqualToString:@"green"]) {
            if (_additiveUpdates) { new_property_value = old_color.green + new_property_value; }
            new_color = [CIColor colorWithRed:old_color.red green:new_property_value blue:old_color.blue alpha:old_color.alpha];
            
        }  else if ([component_name isEqualToString:@"blue"]) {
            if (_additiveUpdates) { new_property_value = old_color.blue + new_property_value; }
            new_color = [CIColor colorWithRed:old_color.red green:old_color.green blue:new_property_value alpha:old_color.alpha];

        }
        
        new_parent_value = new_color;
    }
    
    return new_parent_value;
}


- (BOOL)additiveUpdates {
    return _additiveUpdates;
}

- (void)setAdditiveUpdates:(BOOL)additiveUpdates {
    _additiveUpdates = additiveUpdates;
}

@end
