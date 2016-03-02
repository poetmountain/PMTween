//
//  BasicPhysicsTweenVC.m
//  PMTweenExamples
//
//  Created by Brett Walker on 5/5/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "BasicPhysicsTweenVC.h"
#import "PMTweenPhysicsUnit.h"

@interface BasicPhysicsTweenVC ()

@property (nonatomic, assign) BOOL createdUI;
@property (nonatomic, strong) UIView *tweenView;
@property (nonatomic, strong) PMTweenPhysicsUnit *tween;

- (void)setupUI;
- (void)setupEasing;
- (void)startTouchedHandler:(id)sender;
- (void)stopTouchedHandler:(id)sender;
- (void)pauseTouchedHandler:(id)sender;
- (void)resumeTouchedHandler:(id)sender;

@end

@implementation BasicPhysicsTweenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.createdUI) {
        [self setupUI];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.tween stopTween];
}

- (void)viewDidLayoutSubviews {
    
    if (!self.createdUI) {
        CGFloat content_top = 0;
        if ([self respondsToSelector:@selector(topLayoutGuide)]) {
            content_top = self.topLayoutGuide.length;
        }
        self.tweenView.frame = CGRectMake(20, content_top+20, 50, 50);
        
        [self setupEasing];
        
        self.createdUI = YES;
    }
}

- (void)setupUI {
    
    self.tweenView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    self.tweenView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tweenView];
    
    CGFloat currx = 10;
    CGFloat btn_y = self.view.frame.size.height - 60;
    CGFloat btn_spacer = 10;
    
    UIButton *start_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    start_btn.frame = CGRectMake(currx, btn_y, 60, 40);
    [start_btn setTitle:@"Start" forState:UIControlStateNormal];
    [start_btn addTarget:self action:@selector(startTouchedHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start_btn];
    
    currx += start_btn.frame.size.width + btn_spacer;
    
    UIButton *stop_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stop_btn.frame = CGRectMake(currx, btn_y, 60, 40);
    [stop_btn setTitle:@"Stop" forState:UIControlStateNormal];
    [stop_btn addTarget:self action:@selector(stopTouchedHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stop_btn];
    
    currx += stop_btn.frame.size.width + btn_spacer;
    
    UIButton *pause_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pause_btn.frame = CGRectMake(currx, btn_y, 60, 40);
    [pause_btn setTitle:@"Pause" forState:UIControlStateNormal];
    [pause_btn addTarget:self action:@selector(pauseTouchedHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pause_btn];
    
    currx += pause_btn.frame.size.width + btn_spacer;
    
    UIButton *resume_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    resume_btn.frame = CGRectMake(currx, btn_y, 60, 40);
    [resume_btn setTitle:@"Resume" forState:UIControlStateNormal];
    [resume_btn addTarget:self action:@selector(resumeTouchedHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resume_btn];
    
}


- (void)setupEasing {
    
    self.tween = [[PMTweenPhysicsUnit alloc] initWithObject:self.tweenView propertyKeyPath:@"frame.origin.x" startingValue:self.tweenView.frame.origin.x velocity:100 friction:0.4 options:PMTweenOptionNone];

    __weak typeof(self) weak_self = self;
    self.tween.updateBlock = ^void(NSObject<PMTweening> *tween) {
        //DLog(@"TWEEN 1 COMPLETE!");
        __strong typeof(self) strong_self = weak_self;
        PMTweenPhysicsUnit *ps = (PMTweenPhysicsUnit *)tween;
        NSLog(@"prog %f, velocity %f, val %f", ps.tweenProgress, ps.velocity, strong_self.tweenView.frame.origin.x);
    };
    self.tween.completeBlock = ^void(NSObject<PMTweening> *tween) {
        NSLog(@"tween complete");
    };
}


- (void)startTouchedHandler:(id)sender {
    [self.tween startTween];
}

- (void)stopTouchedHandler:(id)sender {
    [self.tween stopTween];
}

- (void)pauseTouchedHandler:(id)sender {
    [self.tween pauseTween];
}

- (void)resumeTouchedHandler:(id)sender {
    [self.tween resumeTween];
}

@end
