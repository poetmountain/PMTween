//
//  SequenceNoncontiguousVC.m
//  PMTweenExamples
//
//  Created by Brett Walker on 4/22/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "SequenceNoncontiguousVC.h"
#import "PMTweenCATempo.h"
#import "PMTweenEasingCubic.h"
#import "PMTweenUnit.h"
#import "PMTweenSequence.h"

@interface SequenceNoncontiguousVC ()

@property (nonatomic, assign) BOOL createdUI;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;

@property (nonatomic, strong) PMTweenSequence *sequence;

- (void)setupUI;
- (void)setupTweens;
- (void)startTouchedHandler:(id)sender;
- (void)stopTouchedHandler:(id)sender;
- (void)pauseTouchedHandler:(id)sender;
- (void)resumeTouchedHandler:(id)sender;

@end

@implementation SequenceNoncontiguousVC

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
        CGFloat currx = 70;
        CGFloat circle_spacer = 20;
        self.view1.frame = CGRectMake(currx, content_top+30, 30, 30);
        self.view1.layer.cornerRadius = self.view1.frame.size.width/2;
        self.view1.layer.masksToBounds = YES;
        
        currx += self.view1.frame.size.width + circle_spacer;
        self.view2.frame = CGRectMake(currx, content_top+30, 30, 30);
        self.view2.layer.cornerRadius = self.view2.frame.size.width/2;
        self.view2.layer.masksToBounds = YES;

        currx += self.view2.frame.size.width + circle_spacer;
        self.view3.frame = CGRectMake(currx, content_top+30, 30, 30);
        self.view3.layer.cornerRadius = self.view3.frame.size.width/2;
        self.view3.layer.masksToBounds = YES;

        currx += self.view3.frame.size.width + circle_spacer;
        self.view4.frame = CGRectMake(currx, content_top+30, 30, 30);
        self.view4.layer.cornerRadius = self.view4.frame.size.width/2;
        self.view4.layer.masksToBounds = YES;
        
        [self setupTweens];
        
        self.createdUI = YES;
        
    }
}

- (void)setupUI {
    
    self.view1 = [[UIView alloc] init];
    self.view1.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:164.0/255.0 blue:68.0/255.0 alpha:1.0];
    [self.view addSubview:self.view1];
    
    self.view2 = [[UIView alloc] init];
    self.view2.backgroundColor = [UIColor colorWithRed:91.0/255.0 green:189.0/255.0 blue:231.0/255.0 alpha:1.0];
    [self.view addSubview:self.view2];
    
    self.view3 = [[UIView alloc] init];
    self.view3.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:166.0/255.0 blue:183.0/255.0 alpha:1.0];
    [self.view addSubview:self.view3];

    self.view4 = [[UIView alloc] init];
    self.view4.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:184.0/255.0 blue:141.0/255.0 alpha:1.0];
    [self.view addSubview:self.view4];

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
    
    PMTweenUnit *tween1 = [[PMTweenUnit alloc] initWithObject:self.view1  propertyKeyPath:@"layer.bounds.size" startingValue:30 endingValue:50 duration:0.8 options:PMTweenOptionReverse easingBlock:easing_cubic];
    PMTweenUnit *tween2 = [[PMTweenUnit alloc] initWithObject:self.view2  propertyKeyPath:@"layer.bounds.size" startingValue:30 endingValue:50 duration:0.8 options:PMTweenOptionReverse easingBlock:easing_cubic];
    PMTweenUnit *tween3 = [[PMTweenUnit alloc] initWithObject:self.view3  propertyKeyPath:@"layer.bounds.size" startingValue:30 endingValue:50 duration:0.8 options:PMTweenOptionReverse easingBlock:easing_cubic];
    PMTweenUnit *tween4 = [[PMTweenUnit alloc] initWithObject:self.view4  propertyKeyPath:@"layer.bounds.size" startingValue:30 endingValue:50 duration:0.8 options:PMTweenOptionReverse easingBlock:easing_cubic];
    
    
    self.sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[tween1, tween2, tween3, tween4] options:PMTweenOptionReverse];
    self.sequence.reversingMode = PMTweenSequenceReversingNoncontiguous;
    
    self.sequence.updateBlock = ^void(NSObject<PMTweening> *tween) {
        PMTweenSequence *seq = (PMTweenSequence *)tween;
        PMTweenUnit *unit = (PMTweenUnit *)[seq currentSequenceStep];
        UIView *tween_target = (UIView *)unit.targetObject;
        tween_target.layer.cornerRadius = unit.currentValue/2;

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
