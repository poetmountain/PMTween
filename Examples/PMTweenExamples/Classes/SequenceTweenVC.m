//
//  SequenceTweenVC.m
//  PMTweenExamples
//
//  Created by Brett Walker on 4/22/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "SequenceTweenVC.h"
#import "PMTweenCATempo.h"
#import "PMTweenEasingCubic.h"
#import "PMTweenEasingCircular.h"
#import "PMTweenUnit.h"
#import "PMTweenGroup.h"
#import "PMTweenSequence.h"

@interface SequenceTweenVC ()

@property (nonatomic, assign) BOOL createdUI;
@property (nonatomic, strong) UIView *tweenView;
@property (nonatomic, strong) PMTweenSequence *sequence;

- (void)setupUI;
- (void)setupTweens;
- (void)startTouchedHandler:(id)sender;
- (void)stopTouchedHandler:(id)sender;
- (void)pauseTouchedHandler:(id)sender;
- (void)resumeTouchedHandler:(id)sender;

@end

@implementation SequenceTweenVC

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
    
    [self.sequence stopTween];
}

- (void)viewDidLayoutSubviews {
    
    if (!self.createdUI) {

        CGFloat content_top = 0;
        if ([self respondsToSelector:@selector(topLayoutGuide)]) {
            content_top = self.topLayoutGuide.length;
        }
        self.tweenView.frame = CGRectMake(20, content_top+20, 50, 50);
        
        [self setupTweens];
        
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


- (void)setupTweens {
    PMTweenEasingBlock easing_cubic = [PMTweenEasingCubic easingInOut];
    PMTweenEasingBlock easing_circular = [PMTweenEasingCircular easingInOut];
    
    PMTweenUnit *tween = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.origin.x" startingValue:self.tweenView.frame.origin.x endingValue:110 duration:1.0 options:PMTweenOptionNone easingBlock:easing_cubic];
    PMTweenUnit *tween2 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.origin.y" startingValue:self.tweenView.frame.origin.y endingValue:250 duration:1.25 options:PMTweenOptionNone easingBlock:easing_cubic];
    PMTweenUnit *tween3 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"backgroundColor.blue" startingValue:0.0 endingValue:1 duration:0.85 options:PMTweenOptionNone easingBlock:easing_cubic];
    PMTweenUnit *tween4 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.size.width" startingValue:self.tweenView.frame.size.width endingValue:200 duration:1.0 options:PMTweenOptionNone easingBlock:easing_circular];
    
    PMTweenGroup *group = [[PMTweenGroup alloc] initWithTweens:@[tween, tween3] options:PMTweenOptionNone];
    
    self.sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[group, tween2, tween4] options:PMTweenOptionReverse];
    self.sequence.reversingMode = PMTweenSequenceReversingContiguous;
    self.sequence.stepBlock = ^void(NSObject<PMTweening> *tween) {
        NSLog(@"STEP COMPLETE!");
    };
    self.sequence.completeBlock = ^void(NSObject<PMTweening> *tween) {
        NSLog(@"COMPLETE!");
    };
}


- (void)startTouchedHandler:(id)sender {
    [self.sequence startTween];
}

- (void)stopTouchedHandler:(id)sender {
    [self.sequence stopTween];
}

- (void)pauseTouchedHandler:(id)sender {
    [self.sequence pauseTween];
}

- (void)resumeTouchedHandler:(id)sender {
    [self.sequence resumeTween];
}

@end
