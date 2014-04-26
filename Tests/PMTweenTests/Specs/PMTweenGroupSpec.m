//
//  PMTweenGroupSpec.m
//  PMTweenTests
//
//  Created by Brett Walker on 4/9/14.
//
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMTweenGroup.h"
#import "PMTweenUnit.h"
#import "PMTweenEasingLinear.h"
#import "PMTweenBeat.h"
#import "PMTweenCATempo.h"

SpecBegin(PMTweenGroup)

describe(@"PMTweenGroup", ^{
    __block PMTweenGroup *group;
    
    describe(@"-initWithTweens:", ^{
        before(^{
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            group = [[PMTweenGroup alloc] initWithTweens:@[unit] options:PMTweenOptionNone];
        });
        
        it(@"should return an instance of PMTweenGroup", ^{
            expect(group).to.beInstanceOf([PMTweenGroup class]);
        });
    });
    
    describe(@"-addTween: useTweenTempo:", ^{
        before(^{
            group = [[PMTweenGroup alloc] init];
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            [group addTween:unit useTweenTempo:YES];
        });
        
        it(@"should populate tweens array", ^{
            expect(group.tweens).to.haveCountOf(1);
        });
        
    });
    
    describe(@"-addTweens:", ^{
        before(^{
            group = [[PMTweenGroup alloc] init];
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            [group addTweens:@[unit, unit2]];
        });
        
        it(@"should populate tweens array", ^{
            expect(group.tweens).to.haveCountOf(2);
        });
        
    });
    
    describe(@"-removeTween:", ^{
        before(^{
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            group = [[PMTweenGroup alloc] initWithTweens:@[unit, unit2] options:PMTweenOptionNone];
            [group removeTween:unit];
        });
        
        it(@"should remove tween from the array", ^{
            expect(group.tweens).to.haveCountOf(1);
        });
    });
    
    
    describe(@"tween operation", ^{
        __block PMTweenGroup *group;
        
        describe(@"should tween multiple tweens", ^{
            __block PMTweenUnit *unit;
            __block PMTweenUnit *unit2;
            
            before(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                group = [[PMTweenGroup alloc] initWithTweens:@[unit, unit2] options:PMTweenOptionNone];
            });
            
            it(@"should assign a tempo to the group but delete child tempos", ^{
                expect(unit.tempo).to.beNil;
                expect(unit2.tempo).to.beNil;
                expect(group.tempo).notTo.beNil;
            });
            
            it(@"should end tweens on specified ending values", ^AsyncBlock{
                group.completeBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenGroup *tween_group = (PMTweenGroup *)tween;
                    PMTweenUnit *unit = tween_group.tweens[0];
                    PMTweenUnit *unit2 = tween_group.tweens[1];
                    expect(unit.currentValue).to.equal(unit.endingValue);
                    expect(unit.tweenProgress).to.equal(1.0);
                    expect(unit2.currentValue).to.equal(unit2.endingValue);
                    expect(unit2.tweenProgress).to.equal(1.0);
                    done();
                };
                [group startTween];
                
            });
        });
        
        
        describe(@"should send notifications", ^{
            beforeAll(^{
                PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                group = [[PMTweenGroup alloc] initWithTweens:@[unit, unit2] options:PMTweenOptionNone];
            });
            
            it(@"should send a PMTweenDidStartNotification notification", ^{
                
                expect(^{ [group startTween]; }).will.notify(PMTweenDidStartNotification);
                
            });
            
            it(@"should send a PMTweenDidCompleteNotification notification", ^{

                expect(^{ [group startTween]; }).will.notify(PMTweenDidCompleteNotification);
                
            });
            
        });
        
        
    });
    
    
    
    describe(@"tween operation when repeating is active", ^{
        
        describe(@"should tween multiple tweens", ^{
            before(^{
                PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                group = [[PMTweenGroup alloc] initWithTweens:@[unit, unit2] options:PMTweenOptionRepeat];
                group.numberOfRepeats = 2;
            });
            
            it(@"should call repeat and complete blocks", ^AsyncBlock{
                group.repeatCycleBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenGroup *tween_group = (PMTweenGroup *)tween;
                    NSLog(@"--->>> repeat cycle block %i", tween_group.cyclesCompletedCount);
                    
                    if (tween_group.cyclesCompletedCount == tween_group.numberOfRepeats - 1) {
                        expect(tween_group.cyclesCompletedCount).to.equal(tween_group.numberOfRepeats - 1);
                    }
                };
                group.completeBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenGroup *tween_group = (PMTweenGroup *)tween;
                    NSLog(@"--->>> complete cycle block %i", tween_group.cyclesCompletedCount);
                    expect(tween_group.cyclesCompletedCount-1).to.equal(tween_group.numberOfRepeats);

                    PMTweenUnit *unit = tween_group.tweens[0];
                    PMTweenUnit *unit2 = tween_group.tweens[1];
                    expect(unit.currentValue).to.equal(unit.endingValue);
                    expect(unit.tweenProgress).to.equal(1.0);
                    expect(unit2.currentValue).to.equal(unit2.endingValue);
                    expect(unit2.tweenProgress).to.equal(1.0);
                    done();
                };
                [group startTween];
                
            });
        });
        
        
        describe(@"should send notifications", ^{
            
            beforeAll(^{
                PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                group = [[PMTweenGroup alloc] initWithTweens:@[unit] options:PMTweenOptionRepeat];
                group.numberOfRepeats = 2;
                __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMTweenDidCompleteNotification object:group queue:nil usingBlock:^(NSNotification *note) {
                    [[NSNotificationCenter defaultCenter] removeObserver:observer];
                }];
            });
            
            describe(@"PMTweenDidStartNotification", ^{
                
                it(@"should send a PMTweenDidStartNotification notification", ^{
                    expect(^{ [group startTween]; }).will.notify(PMTweenDidStartNotification);
                });
            });
            
            describe(@"PMTweenDidRepeatNotification", ^{
                
                it(@"should send a PMTweenDidRepeatNotification notification", ^{
                    expect(^{ [group startTween]; }).will.notify(PMTweenDidRepeatNotification);
                });
            });
            
            describe(@"PMTweenDidCompleteNotification", ^{
                
                it(@"should send a PMTweenDidCompleteNotification notification", ^{
                    expect(^{ [group startTween]; }).will.notify(PMTweenDidCompleteNotification);
                });
            });
            
        });
        
        
    });
    
    
    describe(@"tween when repeating is active", ^{
        __block PMTweenUnit *unit;
        __block PMTweenUnit *unit2;
        describe(@"should repeat tween", ^{
            before(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                group = [[PMTweenGroup alloc] initWithTweens:@[unit, unit2] options:PMTweenOptionRepeat];
                group.numberOfRepeats = 2;
            });
            
            it(@"should call repeat and complete blocks", ^AsyncBlock {
                group.repeatCycleBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenGroup *tween_group = (PMTweenGroup *)tween;
                    
                    if (tween_group.cyclesCompletedCount - 1 == tween_group.numberOfRepeats) {
                        expect(tween_group.cyclesCompletedCount - 1).to.equal(tween_group.numberOfRepeats);
                    }
                };
                group.completeBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenGroup *tween_group = (PMTweenGroup *)tween;
                    
                    expect(tween_group.cyclesCompletedCount-1).to.equal(tween_group.numberOfRepeats);
                    expect(tween_group.tweenState).to.equal(PMTweenStateStopped);
                    done();
                    
                };
                
                [group startTween];
            });
        });
        
        describe(@"should send notifications", ^{
            beforeAll(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                group = [[PMTweenGroup alloc] initWithTweens:@[unit, unit2] options:PMTweenOptionRepeat];
                group.numberOfRepeats = 2;
            });
            
            it(@"should send a PMTweenDidRepeatNotification notification", ^{
                
                expect(^{ [group startTween]; }).will.notify(PMTweenDidRepeatNotification);
                
            });
            
            
            it(@"should send a PMTweenDidCompleteNotification notification", ^{
                
                expect(^{ [group startTween]; }).will.notify(PMTweenDidCompleteNotification);
                
            });
            
        });
        
        
        
    });
    
    
    
    describe(@"tween when reversing is active", ^{
        __block PMTweenUnit *unit;
        __block PMTweenUnit *unit2;
        describe(@"should reverse the tween", ^{
            before(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                group = [[PMTweenGroup alloc] initWithTweens:@[unit, unit2] options:PMTweenOptionReverse];
            });
            
            it(@"should turn reversing property on in group's tween objects", ^{
                expect(unit.reversing).to.beTruthy();
                expect(unit2.reversing).to.beTruthy();
            });
        });
        
        
        describe(@"when syncTweensWhenReversing is set to YES", ^{
            beforeAll(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.5 options:PMTweenOptionNone easingBlock:nil];
                group = [[PMTweenGroup alloc] initWithTweens:@[unit, unit2] options:PMTweenOptionReverse|PMTweenOptionRepeat];
                group.numberOfRepeats = 2;
                group.syncTweensWhenReversing = YES;
                [group startTween];

            });
            
            it(@"should sync the tweens", ^AsyncBlock {
                unit.reverseBlock = ^void(NSObject<PMTweening>  *tween) {
                    __block PMTweenUnit *u1 = (PMTweenUnit *)tween;

                    dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                    dispatch_after(after_time, dispatch_get_main_queue(), ^{
                        // the unit with the shorter duration should be paused while the other is still tweening
                        expect(u1.tweenState).to.equal(PMTweenStatePaused);
                        expect(unit2.tweenState).to.equal(PMTweenStateTweening);
                        done();
                        
                    });
                };

            });
            
            describe(@"should send notifications", ^{
                
                it(@"should send a PMTweenDidReverseNotification notification", ^{
                    
                    expect(^{ [group startTween]; }).will.notify(PMTweenDidReverseNotification);
                    
                });
                
                it(@"should send a PMTweenHalfCompletedNotification notification", ^{
                    
                    expect(^{ [group startTween]; }).will.notify(PMTweenHalfCompletedNotification);
                    
                });
                
                it(@"should send a PMTweenDidCompleteNotification notification", ^{
                    
                    expect(^{ [group startTween]; }).will.notify(PMTweenDidCompleteNotification);
                    
                });
                
            });
            
        });
        
    });
    
    
    
    
    // test PMTweening methods
    describe(@"PMTweening methods -- ", ^{
        __block PMTweenGroup *group;
        
        beforeAll(^{
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            group = [[PMTweenGroup alloc] initWithTweens:@[unit, unit2] options:PMTweenOptionNone];
        });
        
        describe(@"-startTween", ^{
            
            it(@"should start the tween", ^ {
                group.startBlock = ^void(NSObject<PMTweening>  *tween) {
                    __strong PMTweenGroup *tween_group = (PMTweenGroup *)tween;
                    expect(tween_group.tweenState).to.equal(PMTweenStateTweening);
                };
                expect(^{ [group startTween]; }).will.notify(PMTweenDidStartNotification);
            });
            
            
            describe(@"if tween is paused", ^{
                before(^{
                    [group startTween];
                    [group pauseTween];
                    [group startTween];
                });
                it(@"should NOT start the tween", ^{
                    expect(group.tweenState).to.equal(PMTweenStatePaused);
                });
            });
            
        });
        
        describe(@"-stopTween", ^{
            before(^{
                [group startTween];
            });
            
            it(@"should stop the tween", ^AsyncBlock {
                dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                dispatch_after(after_time, dispatch_get_main_queue(), ^{
                    group.stopBlock = ^void(NSObject<PMTweening>  *tween) {
                        __strong PMTweenGroup *tween_group = (PMTweenGroup *)tween;
                        expect(tween_group.tweenState).to.equal(PMTweenStateStopped);
                        done();
                    };
                    expect(^{ [group stopTween]; }).will.notify(PMTweenDidStopNotification);
                });
                
            });
            
        });
        
        describe(@"-pauseTween", ^{
            beforeAll(^{
                [group startTween];
            });
            
            it(@"should pause the tween", ^AsyncBlock {
                dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                dispatch_after(after_time, dispatch_get_main_queue(), ^{
                    group.pauseBlock = ^void(NSObject<PMTweening>  *tween) {
                        __strong PMTweenGroup *tween_group = (PMTweenGroup *)tween;
                        expect(tween_group.tweenState).to.equal(PMTweenStatePaused);
                        done();
                    };
                    expect(^{ [group pauseTween]; }).will.notify(PMTweenDidPauseNotification);
                });
            });
            
            describe(@"if tween is stopped", ^{
                before(^{
                    [group stopTween];
                    [group pauseTween];
                });
                it(@"should NOT pause the tween", ^{
                    expect(group.tweenState).to.equal(PMTweenStateStopped);
                });
            });
            
        });
        
        describe(@"-resumeTween", ^{
            beforeAll(^{
                PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.5 options:PMTweenOptionNone easingBlock:nil];
                group = [[PMTweenGroup alloc] initWithTweens:@[unit] options:PMTweenOptionNone];
                [group startTween];
            });
            
            it(@"should resume the tween", ^AsyncBlock {
                dispatch_time_t pause_time = dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC);
                dispatch_after(pause_time, dispatch_get_main_queue(), ^{
                    [group pauseTween];
                    PMTweenUnit *unit = (PMTweenUnit *)group.tweens.firstObject;
                    expect(unit.tweenProgress).to.beCloseToWithin(0.5, 0.1);

                    dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                    dispatch_after(after_time, dispatch_get_main_queue(), ^{
                        group.resumeBlock = ^void(NSObject<PMTweening>  *tween) {
                            __strong PMTweenGroup *tween_group = (PMTweenGroup *)tween;
                            expect(tween_group.tweenState).to.equal(PMTweenStateTweening);
                            done();
                        };
                        expect(^{ [group resumeTween]; }).will.notify(PMTweenDidResumeNotification);
                    });
                });
            });
            
            describe(@"if tween is stopped", ^{
                before(^{
                    [group stopTween];
                    [group resumeTween];
                });
                it(@"should NOT resume the tween", ^{
                    expect(group.tweenState).to.equal(PMTweenStateStopped);
                });
            });
            
        });
        
        
        describe(@"-updateWithTimeInterval", ^{

            describe(@"if tween is running", ^{
                before(^{
                    PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.5 options:PMTweenOptionNone easingBlock:nil];
                    group = [[PMTweenGroup alloc] initWithTweens:@[unit] options:PMTweenOptionNone];
                });
                it(@"should call update block", ^AsyncBlock {
                    group.updateBlock = ^void(NSObject<PMTweening>  *tween) {
                        __strong PMTweenGroup *tween_group = (PMTweenGroup *)tween;
                        expect(tween_group.tweenState).to.equal(PMTweenStateTweening);
                        done();
                    };
                    [group startTween];

                });
            });
            
            
            describe(@"if tween is paused", ^{
                before(^{
                    PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                    group = [[PMTweenGroup alloc] initWithTweens:@[unit] options:PMTweenOptionNone];
                    [group startTween];
                    
                });
                
                it(@"should not send a PMTweenDidCompleteNotification notification", ^ {
                    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMTweenDidCompleteNotification object:group queue:nil usingBlock:^(NSNotification *note) {
                        
                        [[NSNotificationCenter defaultCenter] removeObserver:observer];
                    }];
                    
                    expect(^{ [group pauseTween]; }).willNot.notify(PMTweenDidCompleteNotification);
                    
                });
            });
            
        });
        
        
    });
    
    
    
});

SpecEnd
