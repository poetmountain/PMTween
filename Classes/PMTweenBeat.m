//
//  PMTweenBeat.m
//  PMTween
//
//  Created by Brett Walker on 3/28/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenBeat.h"
#import "PMTweenEasing.h"


@interface PMTweenBeat ()

// Supplies the tempo to be broadcast.
@property (nonatomic, strong) PMTweenTempo *tempo;

@end

@implementation PMTweenBeat

- (id)init {
    
    if (self = [super init]) {
        _tweens = [NSMutableArray array];
    }
    
    return self;
}


- (id)initWithTempo:(PMTweenTempo *)tempo {
    
    if (self = [self init]) {
        _tempo = tempo;
        _tempo.delegate = self;

    }
    
    return self;
}


- (void)dealloc {
    if (_tempo) {
        _tempo.delegate = nil;
    }
}


- (void)addTween:(NSObject<PMTweening> *)tween {
    if ([tween conformsToProtocol:@protocol(PMTweening)]) {
        [_tweens addObject:tween];
    } else {
        NSAssert(0, @"NSObject class does not conform to PMTweening protocol.");
    }
}

- (void)removeTween:(NSObject<PMTweening> *)tween {
    [_tweens removeObject:tween];
}



#pragma mark - setters

- (void)setTweens:(NSMutableArray *)tweens {
    _tweens = tweens;
}


#pragma mark - PMTweenTempoDelegate methods

- (void)tempoBeatWithTimestamp:(NSTimeInterval)timestamp {
    
    if (!_paused) {
        for (NSObject<PMTweening> *tween in _tweens) {
            [tween updateWithTimeInterval:timestamp];
        }
    }
}

@end
