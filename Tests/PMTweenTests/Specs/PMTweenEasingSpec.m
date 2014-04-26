//
//  PMTweenEasingSpec.m
//  PMTweenTests
//
//  Created by Brett Walker on 4/13/14.
//
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMTweenEasingLinear.h"
#import "PMTweenEasingQuadratic.h"
#import "PMTweenEasingCubic.h"
#import "PMTweenEasingQuartic.h"
#import "PMTweenEasingQuintic.h"
#import "PMTweenEasingSine.h"
#import "PMTweenEasingCircular.h"
#import "PMTweenEasingBack.h"
#import "PMTweenEasingBounce.h"

SpecBegin(PMTweenEasing)

describe(@"PMTweenEasing types", ^{
    __block double easing;
    
    describe(@"PMTweenEasingLinear", ^{
        before(^{
            PMTweenEasingBlock easingBlock = [PMTweenEasingLinear easingNone];
            easing = easingBlock(100, 0, 100, 100);
        });
        
        it(@"should return correct value", ^{
            expect(easing).to.equal(100);
        });
    });
    
    describe(@"PMTweenEasingQuadratic", ^{
        
        describe(@"easingIn", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingQuadratic easingIn];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
        describe(@"easingOut", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingQuadratic easingOut];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
        describe(@"easingInOut", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingQuadratic easingInOut];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
    });
    
    
    describe(@"PMTweenEasingCubic", ^{
        
        describe(@"easingIn", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingCubic easingIn];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
        describe(@"easingOut", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingCubic easingOut];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
        describe(@"easingInOut", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingCubic easingInOut];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
    });
    
    describe(@"PMTweenEasingQuartic", ^{
        
        describe(@"easingIn", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingQuartic easingIn];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
        describe(@"easingOut", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingQuartic easingOut];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
        describe(@"easingInOut", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingQuartic easingInOut];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
    });
    
    
    describe(@"PMTweenEasingQuintic", ^{
        
        describe(@"easingIn", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingQuintic easingIn];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
        describe(@"easingOut", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingQuintic easingOut];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
        describe(@"easingInOut", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingQuintic easingInOut];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
    });
    
    
    describe(@"PMTweenEasingSine", ^{
        
        describe(@"easingIn", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingSine easingIn];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
        describe(@"easingOut", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingSine easingOut];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
        describe(@"easingInOut", ^{
            before(^{
                PMTweenEasingBlock easingBlock = [PMTweenEasingSine easingInOut];
                easing = easingBlock(100, 0, 100, 100);
            });
            
            it(@"should return correct value", ^{
                expect(easing).to.equal(100);
            });
        });
        
    });
    
});



SpecEnd