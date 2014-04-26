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
    PMTweenExampleGroup                     = 1,
    PMTweenExampleSequence                  = 2,
    PMTweenExampleNoncontiguousSequence     = 3,
    PMTweenExampleTransform3D               = 4,
    PMTweenExampleMassTweens                = 5
};

@end
