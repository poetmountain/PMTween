//
//  TableViewController.h
//  PMTweenExamples
//
//  Created by Brett Walker on 4/22/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

typedef NS_ENUM(NSInteger, PMTweenExampleType) {
    PMTweenExampleBasic                     = 0,
    PMTweenExampleBasicPhysics              = 1,
    PMTweenExampleGroup                     = 2,
    PMTweenExampleSequence                  = 3,
    PMTweenExampleNoncontiguousSequence     = 4,
    PMTweenExampleTransform3D               = 5,
    PMTweenExampleDynamic                   = 6,
    PMTweenExampleMassTweens                = 7
};

@end
