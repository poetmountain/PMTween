//
//  PMTweenBeat.h
//  PMTween
//
//  Created by Brett Walker on 3/28/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTweenTempo.h"
#import "PMTween.h"

/**
 *  PMTweenBeat broadcasts updates from a PMTweenTempo object to multiple objects which adopt the `PMTweening` protocol. This allows you to use a single tempo object for all tween objects, avoiding a performance impact when tweening many objects. In most cases `PMTweenGroup` can be used for the same purpose, albeit with less cheekiness.
 */

@interface PMTweenBeat : NSObject <PMTweenTempoDelegate> {
    @protected
    NSMutableArray *_tweens;
}

///-------------------------------------
/// @name Creating an Instance
///-------------------------------------

/**
 *  Initializes a new PMTweenBeat object and registers the supplied PMTweenTempo.
 *
 *  @param tempo A subclass of PMTweenTempo, which provides the heartbeat for PMTweenBeat.
 *
 *  @warning Do not pass an instance of PMTweenTempo; instead use a subclass and implement the PMTweenTempoDelegate protocol.
 *
 *  @return A new instance of this class
 */
- (instancetype)initWithTempo:(PMTweenTempo *)tempo;


///-------------------------------------
/// @name Setting Up a Beat
///-------------------------------------

/**
 *  Adds an object to the list of objects PMTweenBeat should broadcast a tempo beat to.
 *
 *  @param tween An object which adopts the `PMTweening` protocol.
 */
- (void)addTween:(NSObject<PMTweening> *)tween;

/**
 *  Removes the specified object from the broadcast list.
 *
 *  @param tween The tween object to remove.
 */
- (void)removeTween:(NSObject<PMTweening> *)tween;

/**
 *  An array comprising the tween objects which receive tempo updates. (read-only)
 */
@property (readonly, nonatomic, strong) NSArray *tweens;

/**
 *  A Boolean determining whether tempo updates should be paused.
 */
@property (nonatomic, assign) BOOL paused;


@end
