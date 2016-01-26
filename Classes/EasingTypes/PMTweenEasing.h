//
//  PMTweenEasing.h
//  PMTween
//
//  Created by Brett Walker on 3/29/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// Any custom easing types should implement this block
typedef double (^PMTweenEasingBlock)(NSTimeInterval elapsedTime, double startValue, double valueDelta, NSTimeInterval duration);

