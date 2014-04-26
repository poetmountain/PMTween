//
//  PMTweenBeatSpec.m
//  PMTweenTests
//
//  Created by Brett Walker on 4/8/14.
//
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMTweenBeat.h"
#import "PMTweenCATempo.h"
#import "PMTweenUnit.h"

SpecBegin(PMTweenBeat)

describe(@"PMTweenBeat", ^{
    __block PMTweenBeat *beat;

    describe(@"- initWithTempo:", ^{
        before(^{
            beat = [[PMTweenBeat alloc] initWithTempo:[PMTweenCATempo tempo]];
        });
        
        it(@"should return an instance of PMTweenBeat", ^{
            expect(beat).to.beInstanceOf([PMTweenBeat class]);
        });
    });
    
    describe(@"- addTween", ^{
        before(^{
            beat = [[PMTweenBeat alloc] initWithTempo:[PMTweenCATempo tempo]];
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            [beat addTween:unit];
        });
        
        it(@"should populate tweens array", ^{
            expect(beat.tweens).to.haveCountOf(1);
        });
        
    });
    
    describe(@"- removeTween", ^{
        before(^{
            beat = [[PMTweenBeat alloc] initWithTempo:[PMTweenCATempo tempo]];
            PMTweenUnit *unit = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            PMTweenUnit *unit2 = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:0.2 options:PMTweenOptionNone easingBlock:nil];
            [beat addTween:unit];
            [beat addTween:unit2];
            [beat removeTween:unit];
        });
        
        it(@"should reduce count of tweens array", ^{
            expect(beat.tweens).to.haveCountOf(1);
        });
        
    });
    
});

SpecEnd
