//
//  AppDelegate.m
//  PMTweenExamples
//
//  Created by Brett Walker on 4/22/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    TableViewController *tvc = [[TableViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] init];
    [nav addChildViewController:tvc];
    [self.window setRootViewController:nav];
    
    [self.window makeKeyAndVisible];
    return YES;
}


@end
