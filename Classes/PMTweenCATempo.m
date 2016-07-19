//
//  PMTweenCATempo.m
//  PMTween
//
//  Created by Brett Walker on 3/28/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMTweenCATempo.h"
#import <QuartzCore/QuartzCore.h>

@interface PMTweenCATempo ()

// Called by the CADisplayLink object when an update occurs.
- (void)update;

@end

@implementation PMTweenCATempo

+ (instancetype)tempo {
    
    PMTweenCATempo *new_tempo = [[PMTweenCATempo alloc] init];
    
    return new_tempo;
    
}


- (instancetype)init {
    if (self = [super init]) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    
    return self;
        
}


- (void)update {
    
    NSObject<PMTweenTempoDelegate> *del = self.delegate;
    [del tempoBeatWithTimestamp:self.displayLink.timestamp];
    
}


- (void)dealloc {
    [_displayLink invalidate];
}


@end
