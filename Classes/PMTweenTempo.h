//
//  PMTweenTempo.h
//  PMTween
//
//  Created by Brett Walker on 3/28/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  PMTweenTempoDelegate defines methods that are called on delegate objects that listen for tempo beats.
 */
@protocol PMTweenTempoDelegate <NSObject>

/**
 *  Sends an update beat that should prompt tweening classes to recalculate tween values.
 *
 *  @param timestamp A timestamp with the current time, by which tween classes can calculate new tween values.
 */
- (void)tempoBeatWithTimestamp:(NSTimeInterval)timestamp;

@end


/**
 *  `PMTweenTempo` is an abstract class that provides a basic structure for sending a tempo by which to update tween interpolations. Concrete subclasses should call `tempoBeatWithTimestamp:` with incremental timestamps as necessary.
 
 This class should not be instantiated directly, as it provides no tempo updates on its own.
 */
@interface PMTweenTempo : NSObject

@property (nonatomic, weak) id <PMTweenTempoDelegate> delegate;

@end
