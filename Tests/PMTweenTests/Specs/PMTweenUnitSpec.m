//
//  PMTweenUnitSpec.m
//  PMTweenTests
//
//  Created by Brett Walker on 4/3/14.
//
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMTweenUnit.h"
#import "PMTweenEasingLinear.h"
#import "PMTweenCATempo.h"


SpecBegin(PMTweenUnit)

describe(@"PMTweenUnit", ^{
    __block PMTweenUnit *unit;
   
    describe(@"initWithProperty: startingValue: endingValue: duration: options: easingBlock:", ^{
        
        beforeAll(^{
            unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.1 options:PMTweenOptionNone easingBlock:nil];
        });
        
        it(@"should return an instance of PMTweenUnit", ^{
            expect(unit).to.beInstanceOf([PMTweenUnit class]);
        });

    });
    
    
    describe(@"tween operation", ^{

        describe(@"should tween", ^{
            before(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:[PMTweenEasingLinear easingNone]];
            });
            
            it(@"should end on specified ending value", ^AsyncBlock{
                unit.completeBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                    expect(unit.currentValue).to.equal(unit.endingValue);
                    expect(unit.tweenProgress).to.equal(1.0);
                    done();
                };
                [unit startTween];
                
            });
        });
        
        
        describe(@"should send notifications", ^{
            before(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:[PMTweenEasingLinear easingNone]];
            });
            
            it(@"should send a PMTweenDidStartNotification notification", ^{

                expect(^{ [unit startTween]; }).will.notify(PMTweenDidStartNotification);
                
            });
            
            it(@"should send a PMTweenDidCompleteNotification notification", ^{

                expect(^{ [unit startTween]; }).will.notify(PMTweenDidCompleteNotification);
                
            });
            
        });
        
        
    });
    
    
    describe(@"tween when repeating is active", ^{
        
        describe(@"should repeat tween", ^{
            before(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionRepeat easingBlock:[PMTweenEasingLinear easingNone]];
                unit.numberOfRepeats = 2;
            });
            
            it(@"should call repeat and complete blocks", ^AsyncBlock {
                unit.repeatCycleBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                    
                    if (unit.cyclesCompletedCount - 1 == unit.numberOfRepeats) {
                        expect(unit.cyclesCompletedCount - 1).to.equal(unit.numberOfRepeats);
                    }
                    expect(unit.cycleProgress).to.equal(0.0);
                    expect(unit.tweenProgress).to.equal(0.0);
                };
                unit.completeBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                    
                    expect(unit.cyclesCompletedCount-1).to.equal(unit.numberOfRepeats);
                    expect(unit.cycleProgress).to.equal(1.0);
                    expect(unit.tweenProgress).to.equal(1.0);
                    expect(unit.tweenState).to.equal(PMTweenStateStopped);
                    done();
                    
                };
                
                [unit startTween];
            });
        });
        
        describe(@"should send notifications", ^{
            beforeAll(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionRepeat easingBlock:[PMTweenEasingLinear easingNone]];
                unit.numberOfRepeats = 2;
            });
            
            it(@"should send a PMTweenDidRepeatNotification notification", ^{
                
                expect(^{ [unit startTween]; }).will.notify(PMTweenDidRepeatNotification);
                
            });
            
            it(@"should send a PMTweenDidCompleteNotification notification", ^{

                expect(^{ [unit startTween]; }).will.notify(PMTweenDidCompleteNotification);
                
            });

        });

        
        
    });
    
    
    describe(@"tween when reversing is active", ^{
        
        describe(@"should reverse the tween", ^{
            before(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.4 options:PMTweenOptionReverse easingBlock:[PMTweenEasingLinear easingNone]];
            });
            
            it(@"should tween forward and back", ^AsyncBlock {
                unit.reverseBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                    
                    expect(unit.cycleProgress).to.beCloseToWithin(0.5, 0.05);
                    expect(unit.tweenProgress).to.equal(0.0);
                    expect(unit.tweenState).to.equal(PMTweenStateTweening);
                };
                unit.completeBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                    
                    expect(unit.cycleProgress).to.equal(1.0);
                    expect(unit.tweenProgress).to.equal(1.0);
                    expect(unit.tweenState).to.equal(PMTweenStateStopped);
                    done();
                };
                [unit startTween];
            });
        });
        

        
        describe(@"should send notifications", ^{
            before(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.1 options:PMTweenOptionReverse easingBlock:[PMTweenEasingLinear easingNone]];
            });
            
            it(@"should send a PMTweenDidReverseNotification notification", ^{

                expect(^{ [unit startTween]; }).will.notify(PMTweenDidReverseNotification);
                
            });
            
            
            it(@"should send a PMTweenDidCompleteNotification notification", ^{

                expect(^{ [unit startTween]; }).will.notify(PMTweenDidCompleteNotification);
                
            });
            
        });
        
    });
    
    
    
    describe(@"tween when repeating and reversing is active", ^{
        
        describe(@"should reverse and repeat the tween", ^{
            before(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.1 options:PMTweenOptionRepeat|PMTweenOptionReverse easingBlock:[PMTweenEasingLinear easingNone]];
                unit.numberOfRepeats = 2;
            });
            
            it(@"should tween more than once", ^AsyncBlock {
                unit.repeatCycleBlock = ^void(NSObject<PMTweening>  *tween) {
                    __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                    
                    if (unit.cyclesCompletedCount - 1 == unit.numberOfRepeats) {
                        expect(unit.cyclesCompletedCount - 1).to.equal(unit.numberOfRepeats);
                    }
                    expect(unit.cycleProgress).to.equal(0.0);
                    expect(unit.tweenProgress).to.equal(0.0);
                };
                unit.completeBlock = ^void(NSObject<PMTweening>  *tween) {
                    __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                    
                    expect(unit.cyclesCompletedCount-1).to.equal(unit.numberOfRepeats);
                    expect(unit.cycleProgress).to.equal(1.0);
                    expect(unit.tweenProgress).to.equal(1.0);
                    expect(unit.tweenState).to.equal(PMTweenStateStopped);
                    done();
                };
                [unit startTween];
            });
        });
        

        describe(@"should send notifications", ^{
            beforeAll(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.1 options:PMTweenOptionRepeat|PMTweenOptionReverse easingBlock:[PMTweenEasingLinear easingNone]];
                unit.numberOfRepeats = 2;
            });
            
            it(@"should send a PMTweenDidReverseNotification notification", ^{

                expect(^{ [unit startTween]; }).will.notify(PMTweenDidReverseNotification);
                
            });
            
            it(@"should send a PMTweenDidRepeatNotification notification", ^{

                expect(^{ [unit startTween]; }).will.notify(PMTweenDidRepeatNotification);
                
            });
            
            it(@"should send a PMTweenHalfCompletedNotification notification", ^{
                
                expect(^{ [unit startTween]; }).will.notify(PMTweenHalfCompletedNotification);
                
            });
            
            it(@"should send a PMTweenDidCompleteNotification notification", ^{

                expect(^{ [unit startTween]; }).will.notify(PMTweenDidCompleteNotification);
                
            });

        });
        
    });
    
    
//    describe(@"-jumpToPosition", ^{
//        
//        before(^{
//            unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.5 options:PMTweenOptionNone easingBlock:[PMTweenEasingLinear easingNone]];
//            [unit startTween];
//        });
//      
//        it(@"should jump ahead", ^AsyncBlock {
//            dispatch_time_t wait_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
//            dispatch_after(wait_time, dispatch_get_main_queue(), ^{
//                [unit jumpToPosition:0.8];
//                expect(unit.tweenProgress).to.equal(0.8);
//                expect(lroundf(unit.currentValue)).to.equal(80);
//                expect(unit.tweenState).to.equal(PMTweenStateTweening);
//
//                done();
//            });
//        });
//        
//    });
    
    
    // test PMTweening methods
    describe(@"PMTweening methods -- ", ^{
        
        beforeAll(^{
            unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.4 options:PMTweenOptionNone easingBlock:[PMTweenEasingLinear easingNone]];
        });
        
        describe(@"-startTween", ^{
            
            it(@"should start the tween", ^ {
                unit.startBlock = ^void(NSObject<PMTweening>  *tween) {
                    __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                    expect(unit.tweenState).to.equal(PMTweenStateTweening);
                };

                expect(^{ [unit startTween]; }).will.notify(PMTweenDidStartNotification);
            });
            
            
            describe(@"if tween is paused", ^{
                before(^{
                    [unit startTween];
                    [unit pauseTween];
                    [unit startTween];
                });
                it(@"should NOT start the tween", ^{
                    expect(unit.tweenState).to.equal(PMTweenStatePaused);
                });
            });
            
        });
        
        describe(@"-stopTween", ^{
            beforeAll(^{
                [unit startTween];
            });
            
            it(@"should stop the tween", ^AsyncBlock {
                dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                dispatch_after(after_time, dispatch_get_main_queue(), ^{
                    
                    unit.stopBlock = ^void(NSObject<PMTweening>  *tween) {
                        __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                        expect(unit.tweenState).to.equal(PMTweenStateStopped);
                        done();
                    };
                    expect(^{ [unit stopTween]; }).will.notify(PMTweenDidStopNotification);
                });
                
            });
            
        });
        
        describe(@"-pauseTween", ^{
            beforeAll(^{
                [unit startTween];
            });
            
            it(@"should pause the tween", ^AsyncBlock {
                dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                dispatch_after(after_time, dispatch_get_main_queue(), ^{
                    unit.pauseBlock = ^void(NSObject<PMTweening>  *tween) {
                        __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                        expect(unit.tweenState).to.equal(PMTweenStatePaused);
                        done();
                    };
                    expect(^{ [unit pauseTween]; }).will.notify(PMTweenDidPauseNotification);
                });
            });
            
            describe(@"if tween is stopped", ^{
                before(^{
                    [unit stopTween];
                    [unit pauseTween];
                });
                it(@"should NOT pause the tween", ^{
                    expect(unit.tweenState).to.equal(PMTweenStateStopped);
                });
            });
            
        });
        
        describe(@"-resumeTween", ^{
            beforeAll(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.5 options:PMTweenOptionNone easingBlock:[PMTweenEasingLinear easingNone]];
                [unit startTween];
            });
            
            it(@"should resume the tween", ^AsyncBlock {
                
                dispatch_time_t pause_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                dispatch_after(pause_time, dispatch_get_main_queue(), ^{
                    [unit pauseTween];
                    expect(unit.tweenProgress).to.equal(unit.tweenProgress);

                    dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                    dispatch_after(after_time, dispatch_get_main_queue(), ^{
                        unit.resumeBlock = ^void(NSObject<PMTweening>  *tween) {
                            __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                            expect(unit.tweenState).to.equal(PMTweenStateTweening);
                            done();
                        };
                        expect(^{ [unit resumeTween]; }).will.notify(PMTweenDidResumeNotification);
                    });
                });
            });
            
            describe(@"if tween is stopped", ^{
                before(^{
                    [unit stopTween];
                    [unit resumeTween];
                });
                it(@"should NOT resume the tween", ^{
                    expect(unit.tweenState).to.equal(PMTweenStateStopped);
                });
            });
            
        });
        
        describe(@"-updateWithTimeInterval", ^{
            
            describe(@"if tween is running", ^{
                
                it(@"should call update block", ^AsyncBlock {
                    unit.updateBlock = ^void(NSObject<PMTweening>  *tween) {
                        __strong PMTweenUnit *unit = (PMTweenUnit *)tween;
                        expect(unit.tweenState).to.equal(PMTweenStateTweening);
                        done();
                    };
                    [unit startTween];

                });
            });
            
            
            describe(@"if tween is paused", ^{
                before(^{
                    [unit startTween];
                });

                it(@"should not send a PMTweenDidCompleteNotification notification", ^ {
                    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMTweenDidCompleteNotification object:unit queue:nil usingBlock:^(NSNotification *note) {
                        
                        [[NSNotificationCenter defaultCenter] removeObserver:observer];
                    }];
                    
                    expect(^{ [unit pauseTween]; }).willNot.notify(PMTweenDidCompleteNotification);
 
                });
            });
            
        });
        
    });
    
    

    
});




SpecEnd