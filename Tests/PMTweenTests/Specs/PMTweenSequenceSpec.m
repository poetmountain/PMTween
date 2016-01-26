//
//  PMTweenSequenceSpec.m
//  PMTweenTests
//
//  Created by Brett Walker on 4/11/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMTweenSequence.h"
#import "PMTweenGroup.h"
#import "PMTweenUnit.h"
#import "PMTweenEasingLinear.h"
#import "PMTweenCATempo.h"


SpecBegin(PMTweenSequence)

describe(@"PMTweenSequence", ^{
    __block PMTweenSequence *sequence;
    
    describe(@"-initWithSequenceSteps:", ^{
        before(^{
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionNone];
        });
        
        it(@"should return an instance of PMTweenSequence", ^{
            expect(sequence).to.beInstanceOf([PMTweenSequence class]);
        });
        
        it(@"should populate the sequenceSteps array", ^{
            expect(sequence.sequenceSteps).to.haveCountOf(2);
        });
    });
    
    
    describe(@"-addSequenceStep: useTweenTempo:", ^{
        before(^{
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            sequence = [[PMTweenSequence alloc] init];
            [sequence addSequenceStep:unit useTweenTempo:NO];
        });
        
        
        it(@"should populate the sequenceSteps array", ^{
            expect(sequence.sequenceSteps).to.haveCountOf(1);
        });
    });
    
    describe(@"-removeSequenceStep:", ^{
        before(^{
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            sequence = [[PMTweenSequence alloc] init];
            [sequence addSequenceStep:unit useTweenTempo:NO];
            [sequence removeSequenceStep:unit];
        });
        
        
        it(@"should remove tween step from the sequenceSteps array", ^{
            expect(sequence.sequenceSteps).to.haveCountOf(0);
        });
    });
    
    
    
    describe(@"sequence operation", ^{
        
        describe(@"should play tweens", ^{
            __block PMTweenUnit *unit;
            __block PMTweenUnit *unit2;
            
            before(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionNone];
            });
            
            it(@"should assign a tempo to the sequence but delete child tempos", ^{
                expect(unit.tempo).to.beNil;
                expect(unit2.tempo).to.beNil;
                expect(sequence.tempo).notTo.beNil;
            });
            
            it(@"in proper order", ^{
                waitUntil(^(DoneCallback done) {
                    sequence.startBlock = ^void(NSObject<PMTweening> *tween) {
                        __strong PMTweenSequence *seq = (PMTweenSequence *)tween;
                        PMTweenUnit *unit = seq.sequenceSteps.firstObject;
                        expect([seq currentSequenceStep]).to.equal(unit);
                    };
                    sequence.completeBlock = ^void(NSObject<PMTweening> *tween) {
                        __strong PMTweenSequence *seq = (PMTweenSequence *)tween;
                        PMTweenUnit *unit2 = seq.sequenceSteps.lastObject;
                        expect([seq currentSequenceStep]).to.equal(unit2);
                        expect(unit2.currentValue).to.beCloseTo(unit2.endingValue);
                        expect(unit2.tweenProgress).to.equal(1.0);
                        done();
                    };
                    [sequence startTween];
                });
                
            });
        });
        
        
        describe(@"should send notifications", ^{
            beforeAll(^{
                PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionNone];
            });
            
            it(@"should send a PMTweenDidStartNotification notification", ^{
                expect(^{ [sequence startTween]; }).will.notify(PMTweenDidStartNotification);
            });
            
            it(@"should send a PMTweenDidStepNotification notification", ^{
                expect(^{ [sequence startTween]; }).will.notify(PMTweenDidStepNotification);
            });
            
            it(@"should send a PMTweenDidCompleteNotification notification", ^{
                expect(^{ [sequence startTween]; }).will.notify(PMTweenDidCompleteNotification);
            });
            
        });
        
        
    });
    
    
    
    describe(@"sequence operation when repeating is active", ^{
        
        describe(@"should play tweens multiple times", ^{
            before(^{
                PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionRepeat];
                sequence.numberOfRepeats = 2;
            });
            
            
            it(@"in proper order", ^{
                waitUntil(^(DoneCallback done) {
                    sequence.repeatCycleBlock = ^void(NSObject<PMTweening> *tween) {
                        __strong PMTweenSequence *seq = (PMTweenSequence *)tween;
                        PMTweenUnit *unit = seq.sequenceSteps.firstObject;
                        expect([seq currentSequenceStep]).to.equal(unit);
                        
                        if (seq.cyclesCompletedCount == seq.numberOfRepeats - 1) {
                            expect(seq.cyclesCompletedCount).to.equal(seq.numberOfRepeats - 1);
                        }
                    };
                    sequence.completeBlock = ^void(NSObject<PMTweening> *tween) {
                        __strong PMTweenSequence *seq = (PMTweenSequence *)tween;
                        PMTweenUnit *unit2 = seq.sequenceSteps.lastObject;
                        expect([seq currentSequenceStep]).to.equal(unit2);
                        expect(unit2.currentValue).to.beCloseTo(unit2.endingValue);
                        expect(unit2.tweenProgress).to.equal(1.0);
                        done();
                    };
                    [sequence startTween];
                });
                
            });
        });
        
        
        describe(@"should send notifications", ^{
            beforeAll(^{
                PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionRepeat];
                sequence.numberOfRepeats = 1;
            });
            
            it(@"should send a PMTweenDidStartNotification notification", ^{
                expect(^{ [sequence startTween]; }).will.notify(PMTweenDidStartNotification);
            });
            
            it(@"should send a PMTweenDidStepNotification notification", ^{
                expect(^{ [sequence startTween]; }).will.notify(PMTweenDidStepNotification);
            });
            
            it(@"should send a PMTweenDidCompleteNotification notification", ^{
                expect(^{ [sequence startTween]; }).will.notify(PMTweenDidCompleteNotification);
            });
            
        });
        
        
    });
    
    
    
    describe(@"sequence operation when reversing is active", ^{

        
        describe(@", when reversingMode is PMTweenSequenceReversingNoncontiguous", ^{
            __block PMTweenUnit *unit;
            __block PMTweenUnit *unit2;
            
            describe(@"should reverse the tween", ^{
                before(^{
                    unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                    unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                    sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionReverse];
                });
                
                it(@"should NOT turn reversing property on in group's tween objects", ^{
                    expect(unit.reversing).to.beFalsy();
                    expect(unit2.reversing).to.beFalsy();
                });
            });
            
            
            describe(@"should pause tweens going forward", ^{
                before(^{
                    unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                    unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                    sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionReverse];
                    [sequence startTween];
                    
                });
                
                it(@"should have completed second tween while tweening first", ^{
                    waitUntil(^(DoneCallback done) {
                        dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC);
                        dispatch_after(after_time, dispatch_get_main_queue(), ^{
                            // first unit should be stopped while second unit is tweening during forward tween
                            expect(unit.tweenState).to.equal(PMTweenStateStopped);
                            expect(unit2.tweenState).to.equal(PMTweenStateTweening);
                            done();
                            
                        });
                    });
                });
            });
            
        });
        
        describe(@", when reversingMode is PMTweenSequenceReversingContiguous", ^{
            __block PMTweenUnit *unit;
            __block PMTweenUnit *unit2;
            
            describe(@"should reverse the tween", ^{
                before(^{
                    unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                    unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                    sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionReverse];
                    sequence.reversingMode = PMTweenSequenceReversingContiguous;
                });
                
                it(@"should turn reversing property on in group's tween objects", ^{
                    expect(unit.reversing).to.beTruthy();
                    expect(unit2.reversing).to.beTruthy();
                });
            });
            
            
            describe(@"should pause tweens going forward", ^{
                before(^{
                    unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                    unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.5 options:PMTweenOptionNone easingBlock:nil];
                    sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionReverse];
                    sequence.reversingMode = PMTweenSequenceReversingContiguous;
                    [sequence startTween];
                    
                });
                
                it(@"should pause first tween while tweening second", ^{
                    waitUntil(^(DoneCallback done) {
                        dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.22 * NSEC_PER_SEC);
                        dispatch_after(after_time, dispatch_get_main_queue(), ^{
                            // the first unit should be paused while the other is still tweening
                            expect(unit.tweenState).to.equal(PMTweenStatePaused);
                            expect(unit2.tweenState).to.equal(PMTweenStateTweening);
                            done();
                            
                        });
                    });
                });
                
            });
            
        });
        

        
        describe(@"should send notifications", ^{
            __block PMTweenUnit *unit;
            __block PMTweenUnit *unit2;
            
            beforeAll(^{
                unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
                unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.5 options:PMTweenOptionNone easingBlock:nil];
                sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionReverse|PMTweenOptionRepeat];
                sequence.numberOfRepeats = 2;
                sequence.reversingMode = PMTweenSequenceReversingContiguous;
            });
            
            it(@"should send a PMTweenDidReverseNotification notification", ^{
                
                expect(^{ [sequence startTween]; }).will.notify(PMTweenDidReverseNotification);
                
            });
            
            describe(@"PMTweenDidRepeatNotification", ^{
                
                it(@"should send a PMTweenDidRepeatNotification notification", ^{
                    expect(^{ [sequence startTween]; }).will.notify(PMTweenDidRepeatNotification);
                });
            });
            
            it(@"should send a PMTweenHalfCompletedNotification notification", ^{
                
                expect(^{ [sequence startTween]; }).will.notify(PMTweenHalfCompletedNotification);
                
            });
            
            it(@"should send a PMTweenDidCompleteNotification notification", ^{
                
                expect(^{ [sequence startTween]; }).will.notify(PMTweenDidCompleteNotification);
                
            });
            
        });
        
        
    });
    
    
    
    // test PMTweening methods
    describe(@"PMTweening methods -- ", ^{
        
        beforeAll(^{
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.5 options:PMTweenOptionNone easingBlock:nil];
            PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[unit, unit2] options:PMTweenOptionNone];
        });
        
        describe(@"-startTween", ^{
            
            it(@"should start the tween", ^ {
                sequence.startBlock = ^void(NSObject<PMTweening> *tween) {
                    __strong PMTweenSequence *seq = (PMTweenSequence *)tween;
                    expect(seq.tweenState).to.equal(PMTweenStateTweening);
                };
                expect(^{ [sequence startTween]; }).will.notify(PMTweenDidStartNotification);
            });
            
            
            describe(@"if tween is paused", ^{
                before(^{
                    [sequence startTween];
                    [sequence pauseTween];
                    [sequence startTween];
                });
                it(@"should NOT start the tween", ^{
                    expect(sequence.tweenState).to.equal(PMTweenStatePaused);
                });
            });
            
        });
        
        describe(@"-stopTween", ^{
            before(^{
                [sequence startTween];
            });
            
            it(@"should stop the tween", ^{
                waitUntil(^(DoneCallback done) {
                    dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                    dispatch_after(after_time, dispatch_get_main_queue(), ^{
                        sequence.stopBlock = ^void(NSObject<PMTweening>  *tween) {
                            __strong PMTweenSequence *seq = (PMTweenSequence *)tween;
                            expect(seq.tweenState).to.equal(PMTweenStateStopped);
                            done();
                        };
                        expect(^{ [sequence stopTween]; }).will.notify(PMTweenDidStopNotification);
                    });
                });
                
            });
            
        });
        
        describe(@"-pauseTween", ^{
            beforeAll(^{
                [sequence startTween];
            });
            
            it(@"should pause the tween", ^{
                waitUntil(^(DoneCallback done) {
                    dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                    dispatch_after(after_time, dispatch_get_main_queue(), ^{
                        sequence.pauseBlock = ^void(NSObject<PMTweening>  *tween) {
                            __strong PMTweenSequence *seq = (PMTweenSequence *)tween;
                            expect(seq.tweenState).to.equal(PMTweenStatePaused);
                            done();
                        };
                        expect(^{ [sequence pauseTween]; }).will.notify(PMTweenDidPauseNotification);
                    });
                });
            });
            
            describe(@"if tween is stopped", ^{
                before(^{
                    [sequence stopTween];
                    [sequence pauseTween];
                });
                it(@"should NOT pause the tween", ^{
                    expect(sequence.tweenState).to.equal(PMTweenStateStopped);
                });
            });
            
        });
        
        describe(@"-resumeTween", ^{
            beforeAll(^{
                [sequence startTween];
            });
            
            it(@"should resume the tween", ^{
                waitUntil(^(DoneCallback done) {
                    dispatch_time_t pause_time = dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC);
                    dispatch_after(pause_time, dispatch_get_main_queue(), ^{
                        [sequence pauseTween];
                        PMTweenUnit *unit = (PMTweenUnit *)sequence.sequenceSteps.firstObject;
                        expect(unit.tweenProgress).to.beCloseToWithin(0.5, 0.1);
                        
                        dispatch_time_t after_time = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
                        dispatch_after(after_time, dispatch_get_main_queue(), ^{
                            sequence.resumeBlock = ^void(NSObject<PMTweening>  *tween) {
                                __strong PMTweenSequence *seq = (PMTweenSequence *)tween;
                                expect(seq.tweenState).to.equal(PMTweenStateTweening);
                                done();
                            };
                            expect(^{ [sequence resumeTween]; }).will.notify(PMTweenDidResumeNotification);
                        });
                    });
                });
            });
            
            describe(@"if tween is stopped", ^{
                before(^{
                    [sequence stopTween];
                    [sequence resumeTween];
                });
                it(@"should NOT resume the tween", ^{
                    expect(sequence.tweenState).to.equal(PMTweenStateStopped);
                });
            });
            
        });
        
        
        describe(@"-updateWithTimeInterval", ^{
            
            describe(@"if tween is running", ^{
                it(@"should call update block", ^{
                    waitUntil(^(DoneCallback done) {
                        sequence.updateBlock = ^void(NSObject<PMTweening>  *tween) {
                            __strong PMTweenSequence *seq = (PMTweenSequence *)tween;
                            expect(seq.tweenState).to.equal(PMTweenStateTweening);
                            [seq stopTween];
                            done();
                        };
                        [sequence startTween];
                    });
                    
                });
            });
            
            
            describe(@"if tween is paused", ^{
                before(^{
                    [sequence startTween];
                });
                
                it(@"should not send a PMTweenDidCompleteNotification notification", ^ {
                    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMTweenDidCompleteNotification object:sequence queue:nil usingBlock:^(NSNotification *note) {
                        
                        [[NSNotificationCenter defaultCenter] removeObserver:observer];
                    }];
                    
                    expect(^{ [sequence pauseTween]; }).willNot.notify(PMTweenDidCompleteNotification);
                    
                });
            });
            
        });
        
        
    });
    
    
    
});

SpecEnd