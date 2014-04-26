//
//  PMTweenCATempo.h
//  PMTween
//
//  Created by Brett Walker on 3/28/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenTempo.h"

/**
 *  PMTweenCATempo uses a `CADisplayLink` object to send out tempo updates that are synchronized with the refresh rate of the display.
 */
@interface PMTweenCATempo : PMTweenTempo

///----------------------------------
/// @name Creating an Instance
///----------------------------------

/**
 Convenience method for creating an instance of this class.
 
 @return An instance of PMTweenCATempo.
 
 */
+ (instancetype)tempo;

/**
 *  The `CADisplayLink` object used to provide tempo updates.
 *
 *  @remarks This class provides several mechanisms for adjusting the update rate. See the `CADisplayLink` documentation for more information.
 *
 *  @warning Do not call the `addToRunLoop:forMode:`, `removeFromRunLoop:forMode:`, or `invalidate` methods on this object, as its state is handled by PMTweenCATempo directly.
 */
@property (nonatomic, strong) CADisplayLink *displayLink;

@end
