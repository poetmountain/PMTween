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
    PMTweenExampleAdditive                  = 1,
    PMTweenExampleBasicPhysics              = 2,
    PMTweenExampleGroup                     = 3,
    PMTweenExampleSequence                  = 4,
    PMTweenExampleNoncontiguousSequence     = 5,
    PMTweenExampleTransform3D               = 6,
    PMTweenExampleDynamic                   = 7,
    PMTweenExampleMassTweens                = 8
};

@end
