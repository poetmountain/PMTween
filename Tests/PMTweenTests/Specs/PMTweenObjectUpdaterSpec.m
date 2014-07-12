//
//  PMTweenObjectUpdaterSpec.m
//  PMTweenTests
//
//  Created by Brett Walker on 4/25/14.
//
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMTweenObjectUpdater.h"

SpecBegin(PMTweenObjectUpdater)

describe(@"PMTweenObjectUpdater", ^{
    
    describe(@"replaceObject:newPropertyValue:propertyKeyPath:", ^{
        __block NSObject *old_value;
        __block NSObject *new_value;
        
        describe(@", with a CGFloat", ^{
            
            describe(@", non-additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    old_value = @0.0;
                    new_value = [updater replaceObject:old_value newPropertyValue:0.5 propertyKeyPath:@"alpha"];
                });
                
                it(@", should update", ^{
                    CGFloat new_float = (CGFloat)[(NSNumber *)new_value floatValue];
                    expect(new_float).to.equal(0.5);
                });
            });
            
            describe(@", additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    updater.additiveUpdates = YES;
                    old_value = @0.2;
                    new_value = [updater replaceObject:old_value newPropertyValue:0.1 propertyKeyPath:@"alpha"];
                });
                
                it(@", should update", ^{
                    CGFloat new_float = (CGFloat)[(NSNumber *)new_value floatValue];
                    expect(new_float).to.equal(0.3);
                });
            });
            
        });
        
        describe(@", with a CGPoint", ^{
            
            describe(@", non-additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    old_value = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
                    new_value = [updater replaceObject:old_value newPropertyValue:50 propertyKeyPath:@"x"];
                });
                
                it(@", should only update the x property", ^{
                    CGPoint old_pt = (CGPoint)[(NSValue *)old_value CGPointValue];
                    CGPoint new_pt = (CGPoint)[(NSValue *)new_value CGPointValue];
                    expect(new_pt.x).to.equal(50);
                    expect(new_pt.y).to.equal(old_pt.y);
                });
            });
            
            describe(@", additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    updater.additiveUpdates = YES;
                    old_value = [NSValue valueWithCGPoint:CGPointMake(20, 0)];
                    new_value = [updater replaceObject:old_value newPropertyValue:50 propertyKeyPath:@"x"];
                });
                
                it(@", should only update the x property", ^{
                    CGPoint old_pt = (CGPoint)[(NSValue *)old_value CGPointValue];
                    CGPoint new_pt = (CGPoint)[(NSValue *)new_value CGPointValue];
                    expect(new_pt.x).to.equal(70);
                    expect(new_pt.y).to.equal(old_pt.y);
                });
            });

            
        });
        
        describe(@", with a CGSize", ^{
            
            describe(@", non-additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    old_value = [NSValue valueWithCGSize:CGSizeMake(10, 10)];
                    new_value = [updater replaceObject:old_value newPropertyValue:50 propertyKeyPath:@"width"];
                });
                
                it(@", should only update the width property", ^{
                    CGSize old_size = (CGSize)[(NSValue *)old_value CGSizeValue];
                    CGSize new_size = (CGSize)[(NSValue *)new_value CGSizeValue];
                    expect(new_size.width).to.equal(50);
                    expect(new_size.height).to.equal(old_size.width);
                });
            });
            
            describe(@", additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    updater.additiveUpdates = YES;
                    old_value = [NSValue valueWithCGSize:CGSizeMake(10, 10)];
                    new_value = [updater replaceObject:old_value newPropertyValue:50 propertyKeyPath:@"width"];
                });
                
                it(@", should only update the width property", ^{
                    CGSize old_size = (CGSize)[(NSValue *)old_value CGSizeValue];
                    CGSize new_size = (CGSize)[(NSValue *)new_value CGSizeValue];
                    expect(new_size.width).to.equal(60);
                    expect(new_size.height).to.equal(old_size.width);
                });
            });

            
        });
        
        describe(@", with a CGRect", ^{

            describe(@", non-additive", ^{
                describe(@", targeting a CGPoint value", ^{
                    before(^{
                        PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                        old_value = [NSValue valueWithCGRect:CGRectMake(0, 0, 10, 10)];
                        new_value = [updater replaceObject:old_value newPropertyValue:50 propertyKeyPath:@"origin.x"];
                    });
                    
                    it(@", should only update the x property", ^{
                        CGRect old_rect = (CGRect)[(NSValue *)old_value CGRectValue];
                        CGRect new_rect = (CGRect)[(NSValue *)new_value CGRectValue];
                        expect(new_rect.origin.x).to.equal(50);
                        expect(new_rect.origin.y).to.equal(old_rect.origin.y);
                        expect(new_rect.size.width).to.equal(old_rect.size.width);
                    });
                    
                });
                
                describe(@", targeting a CGSize value", ^{
                    before(^{
                        PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                        old_value = [NSValue valueWithCGRect:CGRectMake(0, 0, 10, 10)];
                        new_value = [updater replaceObject:old_value newPropertyValue:50 propertyKeyPath:@"size.width"];
                    });
                    
                    it(@", should only update the width property", ^{
                        CGRect old_rect = (CGRect)[(NSValue *)old_value CGRectValue];
                        CGRect new_rect = (CGRect)[(NSValue *)new_value CGRectValue];
                        expect(new_rect.size.width).to.equal(50);
                        expect(new_rect.size.height).to.equal(old_rect.size.height);
                        expect(new_rect.origin.x).to.equal(old_rect.origin.x);
                    });
                    
                });
            });

            describe(@", additive", ^{
                describe(@", targeting a CGPoint value", ^{
                    before(^{
                        PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                        updater.additiveUpdates = YES;
                        old_value = [NSValue valueWithCGRect:CGRectMake(10, 0, 10, 10)];
                        new_value = [updater replaceObject:old_value newPropertyValue:50 propertyKeyPath:@"origin.x"];
                    });
                    
                    it(@", should only update the x property", ^{
                        CGRect old_rect = (CGRect)[(NSValue *)old_value CGRectValue];
                        CGRect new_rect = (CGRect)[(NSValue *)new_value CGRectValue];
                        expect(new_rect.origin.x).to.equal(60);
                        expect(new_rect.origin.y).to.equal(old_rect.origin.y);
                        expect(new_rect.size.width).to.equal(old_rect.size.width);
                    });
                    
                });
                
                describe(@", targeting a CGSize value", ^{
                    before(^{
                        PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                        updater.additiveUpdates = YES;
                        old_value = [NSValue valueWithCGRect:CGRectMake(0, 0, 10, 10)];
                        new_value = [updater replaceObject:old_value newPropertyValue:50 propertyKeyPath:@"size.width"];
                    });
                    
                    it(@", should only update the width property", ^{
                        CGRect old_rect = (CGRect)[(NSValue *)old_value CGRectValue];
                        CGRect new_rect = (CGRect)[(NSValue *)new_value CGRectValue];
                        expect(new_rect.size.width).to.equal(60);
                        expect(new_rect.size.height).to.equal(old_rect.size.height);
                        expect(new_rect.origin.x).to.equal(old_rect.origin.x);
                    });
                    
                });
            });

            
        });
        
        
        describe(@", with a CGAffineTransform", ^{
            
            describe(@", non-additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    old_value = [NSValue valueWithCGAffineTransform:CGAffineTransformMake(0, 0, 0, 0, 0, 0.5)];
                    new_value = [updater replaceObject:old_value newPropertyValue:1.0 propertyKeyPath:@"tx"];
                });
                
                it(@", should only update the tx property", ^{
                    CGAffineTransform old_transform = (CGAffineTransform)[(NSValue *)old_value CGAffineTransformValue];
                    CGAffineTransform new_transform = (CGAffineTransform)[(NSValue *)new_value CGAffineTransformValue];
                    expect(new_transform.tx).to.equal(1.0);
                    expect(new_transform.ty).to.equal(old_transform.ty);
                });
            });
            
            describe(@", additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    updater.additiveUpdates = YES;
                    old_value = [NSValue valueWithCGAffineTransform:CGAffineTransformMake(0, 0, 0, 0, 0.1, 0.1)];
                    new_value = [updater replaceObject:old_value newPropertyValue:0.5 propertyKeyPath:@"tx"];
                });
                
                it(@", should only update the tx property", ^{
                    CGAffineTransform old_transform = (CGAffineTransform)[(NSValue *)old_value CGAffineTransformValue];
                    CGAffineTransform new_transform = (CGAffineTransform)[(NSValue *)new_value CGAffineTransformValue];
                    expect(new_transform.tx).to.equal(0.6);
                    expect(new_transform.ty).to.equal(old_transform.ty);
                });
            });
            
        });
        
        describe(@", with a CATransform3D", ^{
            
            describe(@", non-additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    old_value = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0.0, 0.0, 0.0)];
                    new_value = [updater replaceObject:old_value newPropertyValue:1.0 propertyKeyPath:@"m11"];
                });
                
                it(@", should only update the m11 property", ^{
                    CATransform3D old_transform = (CATransform3D)[(NSValue *)old_value CATransform3DValue];
                    CATransform3D new_transform = (CATransform3D)[(NSValue *)new_value CATransform3DValue];
                    expect(new_transform.m11).to.equal(1.0);
                    expect(new_transform.m12).to.equal(old_transform.m12);
                });
            });

            describe(@", additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    updater.additiveUpdates = YES;
                    old_value = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0.0, 0.0, 0.0)];
                    new_value = [updater replaceObject:old_value newPropertyValue:0.1 propertyKeyPath:@"m11"];
                });
                
                it(@", should only update the m11 property", ^{
                    CATransform3D old_transform = (CATransform3D)[(NSValue *)old_value CATransform3DValue];
                    CATransform3D new_transform = (CATransform3D)[(NSValue *)new_value CATransform3DValue];
                    expect(new_transform.m11).to.equal(1.1);
                    expect(new_transform.m12).to.equal(old_transform.m12);
                });
            });
            
        });
        
        
        describe(@", with a UIColor", ^{
            
            describe(@", non-additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    old_value = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
                    new_value = [updater replaceObject:old_value newPropertyValue:1.0 propertyKeyPath:@"red"];
                });
                
                it(@", should only update the red property", ^{
                    UIColor *new_color = (UIColor *)new_value;
                    CGFloat red, green, blue, alpha;
                    [new_color getRed:&red green:&green blue:&blue alpha:&alpha];
                    expect(red).to.equal(1.0);
                    expect(blue).to.equal(0.0);
                });
            });
            
            describe(@", additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    updater.additiveUpdates = YES;
                    old_value = [UIColor colorWithRed:0.2 green:0.5 blue:0.0 alpha:1.0];
                    new_value = [updater replaceObject:old_value newPropertyValue:0.3 propertyKeyPath:@"red"];
                });
                
                it(@", should only update the red property", ^{
                    UIColor *new_color = (UIColor *)new_value;
                    CGFloat red, green, blue, alpha;
                    [new_color getRed:&red green:&green blue:&blue alpha:&alpha];
                    expect(red).to.equal(0.5);
                    expect(blue).to.equal(0.0);
                });
            });

        });
        
        
        describe(@", with a CIColor", ^{
            
            describe(@", non-additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    old_value = [CIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
                    new_value = [updater replaceObject:old_value newPropertyValue:1.0 propertyKeyPath:@"red"];
                });
                
                it(@", should only update the red property", ^{
                    CIColor *old_color = (CIColor *)old_value;
                    CIColor *new_color = (CIColor *)new_value;
                    expect(new_color.red).to.equal(1.0);
                    expect(new_color.blue).to.equal(old_color.blue);
                });
            });
            
            describe(@", additive", ^{
                before(^{
                    PMTweenObjectUpdater *updater = [PMTweenObjectUpdater updater];
                    updater.additiveUpdates = YES;
                    old_value = [CIColor colorWithRed:0.2 green:0.5 blue:0.0 alpha:1.0];
                    new_value = [updater replaceObject:old_value newPropertyValue:0.3 propertyKeyPath:@"red"];
                });
                
                it(@", should only update the red property", ^{
                    CIColor *old_color = (CIColor *)old_value;
                    CIColor *new_color = (CIColor *)new_value;
                    expect(new_color.red).to.equal(0.5);
                    expect(new_color.blue).to.equal(old_color.blue);
                });
            });

        });
        
    });
    
});


SpecEnd