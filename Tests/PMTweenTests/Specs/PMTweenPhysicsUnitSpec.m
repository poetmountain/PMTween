//
//  PMTweenPhysicsUnitSpec.m
//  PMTweenTests
//
//  Created by Brett Walker on 5/4/14.
//
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMTweenPhysicsUnit.h"

SpecBegin(PMTweenPhysicsUnit)

describe(@"PMTweenPhysicsUnit", ^{
    __block PMTweenPhysicsUnit *unit;
    
    describe(@"initWithProperty: startingValue: velocity: friction: options:", ^{
        
        before(^{
            unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:1 friction:0.8 options:PMTweenOptionNone];
        });
        
        it(@"should return an instance of PMTweenPhysicsUnit", ^{
            expect(unit).to.beInstanceOf([PMTweenPhysicsUnit class]);
        });
        
    });
    
    describe(@"initWithObject: propertyKeyPath: startingValue: endingValue: duration: options: easingBlock:", ^{
        __block UIView *view;
        
        before(^{
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            unit = [[PMTweenPhysicsUnit alloc] initWithObject:view propertyKeyPath:@"frame.origin.x" startingValue:0 velocity:1 friction:0.998 options:PMTweenOptionNone];
        });
        
        it(@"should return an instance of PMTweenPhysicsUnit", ^{
            expect(unit).to.beInstanceOf([PMTweenPhysicsUnit class]);
        });
        
    });
    
    
    describe(@"tween operation", ^{
        
        describe(@"should tween", ^{
            
            describe(@"initWithProperty:...", ^{
                before(^{
                    unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:1 friction:0.8 options:PMTweenOptionNone];
                });
                
                it(@"should end on specified ending value", ^AsyncBlock{
                    unit.completeBlock = ^void(NSObject<PMTweening> *tween) {
                        __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                        expect(physics_unit.velocity).to.beCloseToWithin(0.0, 0.1);
                        expect(physics_unit.tweenProgress).to.equal(1.0);
                        done();
                    };
                    [unit startTween];
                    
                });
            });
            
            describe(@"using initWithObject:...", ^{
                __block UIView *view;
                
                before(^{
                    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
                    unit = [[PMTweenPhysicsUnit alloc] initWithObject:view propertyKeyPath:@"frame.origin.x" startingValue:0 velocity:1 friction:0.998 options:PMTweenOptionNone];
                });
                
                it(@"should end on specified ending value", ^AsyncBlock{
                    unit.completeBlock = ^void(NSObject<PMTweening> *tween) {
                        __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                        expect(physics_unit.velocity).to.beCloseToWithin(0.0, 0.1);
                        expect(physics_unit.tweenProgress).to.equal(1.0);
                        expect(view.frame.origin.x).to.equal(physics_unit.currentValue);
                        done();
                    };
                    [unit startTween];
                    
                });
            });

        });
        
        describe(@"should send notifications", ^{
            beforeAll(^{
                unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:1 friction:0.998 options:PMTweenOptionNone];
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
                unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:1 friction:0.8 options:PMTweenOptionRepeat];
                unit.numberOfRepeats = 2;
            });
            
            it(@"should call repeat and complete blocks", ^AsyncBlock {
                unit.repeatCycleBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                    
                    if (physics_unit.cyclesCompletedCount - 1 == physics_unit.numberOfRepeats) {
                        expect(physics_unit.cyclesCompletedCount - 1).to.equal(physics_unit.numberOfRepeats);
                    }
                    expect(physics_unit.cycleProgress).to.equal(0.0);
                    expect(physics_unit.tweenProgress).to.equal(0.0);
                };
                unit.completeBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                    
                    expect(physics_unit.cyclesCompletedCount-1).to.equal(physics_unit.numberOfRepeats);
                    expect(physics_unit.cycleProgress).to.equal(1.0);
                    expect(physics_unit.tweenProgress).to.equal(1.0);
                    expect(physics_unit.tweenState).to.equal(PMTweenStateStopped);
                    done();
                    
                };
                
                [unit startTween];
            });
        });
        
        describe(@"should send notifications", ^{
            beforeAll(^{
                unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:1 friction:0.998 options:PMTweenOptionRepeat];
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
                unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:1 friction:0.8 options:PMTweenOptionReverse];
            });
            
            it(@"should tween forward and back", ^AsyncBlock {
                unit.reverseBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                    
                    expect(physics_unit.cycleProgress).to.beCloseToWithin(0.5, 0.05);
                    expect(physics_unit.tweenProgress).to.equal(0.0);
                    expect(physics_unit.tweenState).to.equal(PMTweenStateTweening);
                };
                unit.completeBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                    
                    expect(physics_unit.cycleProgress).to.equal(1.0);
                    expect(physics_unit.tweenProgress).to.equal(1.0);
                    expect(physics_unit.tweenState).to.equal(PMTweenStateStopped);
                    done();
                };
                [unit startTween];
            });
        });
        
        
        
        describe(@"should send notifications", ^{
            before(^{
                unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:1 friction:0.998 options:PMTweenOptionReverse];
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
                unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:1 friction:0.8 options:PMTweenOptionReverse|PMTweenOptionRepeat];
                unit.numberOfRepeats = 2;
            });
            
            it(@"should tween more than once", ^AsyncBlock {
                unit.repeatCycleBlock = ^void(NSObject<PMTweening>  *tween) {
                    __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                    
                    if (physics_unit.cyclesCompletedCount - 1 == physics_unit.numberOfRepeats) {
                        expect(physics_unit.cyclesCompletedCount - 1).to.equal(physics_unit.numberOfRepeats);
                    }
                    expect(physics_unit.cycleProgress).to.equal(0.0);
                    expect(physics_unit.tweenProgress).to.equal(0.0);
                };
                unit.completeBlock = ^void(NSObject<PMTweening>  *tween) {
                    __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                    
                    expect(physics_unit.cyclesCompletedCount-1).to.equal(physics_unit.numberOfRepeats);
                    expect(physics_unit.cycleProgress).to.equal(1.0);
                    expect(physics_unit.tweenProgress).to.equal(1.0);
                    expect(physics_unit.tweenState).to.equal(PMTweenStateStopped);
                    done();
                };
                [unit startTween];
            });
        });
        
        
        describe(@"should send notifications", ^{
            beforeAll(^{
                unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:0.1 friction:0.998 options:PMTweenOptionReverse|PMTweenOptionRepeat];
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
    
    
    
    // test PMTweening methods
    describe(@"PMTweening methods -- ", ^{
        
        beforeAll(^{
            unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:1 friction:0.9 options:PMTweenOptionNone];
        });
        
        describe(@"-startTween", ^{
            
            it(@"should start the tween", ^ {
                unit.startBlock = ^void(NSObject<PMTweening>  *tween) {
                    __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                    expect(physics_unit.tweenState).to.equal(PMTweenStateTweening);
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
                        __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                        expect(physics_unit.tweenState).to.equal(PMTweenStateStopped);
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
                        __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                        expect(physics_unit.tweenState).to.equal(PMTweenStatePaused);
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
                unit = [[PMTweenPhysicsUnit alloc] initWithProperty:@(0) startingValue:0 velocity:2 friction:0.8 options:PMTweenOptionNone];
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
                            __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                            expect(physics_unit.tweenState).to.equal(PMTweenStateTweening);
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
                        __strong PMTweenPhysicsUnit *physics_unit = (PMTweenPhysicsUnit *)tween;
                        expect(physics_unit.tweenState).to.equal(PMTweenStateTweening);
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