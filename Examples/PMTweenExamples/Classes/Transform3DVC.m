//
//  Transform3DVC.m
//  PMTweenExamples
//
//  Created by Brett Walker on 4/23/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "Transform3DVC.h"
#import "PMTweenCATempo.h"
#import "PMTweenEasingLinear.h"
#import "PMTweenEasingSine.h"
#import "PMTweenUnit.h"
#import "PMTweenGroup.h"

@interface Transform3DVC ()

@property (nonatomic, assign) BOOL createdUI;
@property (nonatomic, strong) UIView *tweenView;
@property (nonatomic, strong) UIView *tweenView2;
@property (nonatomic, strong) CALayer *layer1;
@property (nonatomic, strong) CALayer *layer2;
@property (nonatomic, strong) PMTweenGroup *group;

- (void)setupUI;
- (void)setupEasing;
- (void)startTouchedHandler:(id)sender;
- (void)stopTouchedHandler:(id)sender;
- (void)pauseTouchedHandler:(id)sender;
- (void)resumeTouchedHandler:(id)sender;

@end

@implementation Transform3DVC

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
    
    [self.group stopTween];
}

- (void)viewDidLayoutSubviews {
    
    if (!self.createdUI) {
        CGFloat content_top = 0;
        if ([self respondsToSelector:@selector(topLayoutGuide)]) {
            content_top = self.topLayoutGuide.length;
        }
        self.tweenView.frame = CGRectMake(110, content_top+100, 50, 50);
        self.tweenView2.frame = CGRectMake(160, content_top+100, 50, 50);

        [self setupEasing];
        
        self.createdUI = YES;
    }
}

- (void)setupUI {
    
    self.tweenView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:self.tweenView];
    self.tweenView2 = [[UIView alloc] initWithFrame:CGRectMake(150, 100, 200, 200)];
    [self.view addSubview:self.tweenView2];
    
    self.layer1 = [CALayer layer];
	self.layer1.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:164.0/255.0 blue:68.0/255.0 alpha:1.0].CGColor;
	self.layer1.frame = CGRectMake(1, 1, 99, 99);
	self.layer1.position = CGPointMake(0,0);
	[self.tweenView.layer addSublayer:self.layer1];
    self.layer2 = [CALayer layer];
    self.layer2.backgroundColor = [UIColor colorWithRed:91.0/255.0 green:189.0/255.0 blue:231.0/255.0 alpha:1.0].CGColor;
	self.layer2.frame = CGRectMake(1, 1, 99, 99);
	self.layer2.position = CGPointMake(51,0);
	[self.tweenView2.layer addSublayer:self.layer2];
    
    CATransform3D initialTransform = self.layer1.sublayerTransform;
	initialTransform.m34 = 1.0 / -350;
	self.layer1.sublayerTransform = initialTransform;
    self.layer2.sublayerTransform = initialTransform;
    
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
    
    PMTweenEasingBlock easing = [PMTweenEasingSine easingInOut];
    //self.tween = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:0.01 duration:1.0 options:PMTweenOptionRepeat easingBlock:easing];
    PMTweenUnit *tween1 = [[PMTweenUnit alloc] initWithObject:self.tweenView propertyKeyPath:@"layer.sublayerTransform.m13" startingValue:self.tweenView.layer.sublayerTransform.m13 endingValue:0.0025 duration:2.0 options:PMTweenOptionNone easingBlock:easing];
    PMTweenUnit *tween2 = [[PMTweenUnit alloc] initWithObject:self.tweenView propertyKeyPath:@"layer.sublayerTransform.m14" startingValue:self.tweenView.layer.sublayerTransform.m14 endingValue:-0.004 duration:2.0 options:PMTweenOptionNone easingBlock:easing];
    PMTweenUnit *tween3 = [[PMTweenUnit alloc] initWithObject:self.tweenView propertyKeyPath:@"layer.sublayerTransform.m11" startingValue:self.tweenView.layer.sublayerTransform.m11 endingValue:-0.30 duration:2.0 options:PMTweenOptionNone easingBlock:easing];
    
    PMTweenUnit *tween4 = [[PMTweenUnit alloc] initWithObject:self.tweenView2 propertyKeyPath:@"layer.sublayerTransform.m13" startingValue:self.tweenView.layer.sublayerTransform.m13 endingValue:0.0025 duration:2.0 options:PMTweenOptionNone easingBlock:easing];
    PMTweenUnit *tween5 = [[PMTweenUnit alloc] initWithObject:self.tweenView2 propertyKeyPath:@"layer.sublayerTransform.m14" startingValue:self.tweenView.layer.sublayerTransform.m14 endingValue:-0.004 duration:2.0 options:PMTweenOptionNone easingBlock:easing];
    PMTweenUnit *tween6 = [[PMTweenUnit alloc] initWithObject:self.tweenView2 propertyKeyPath:@"layer.sublayerTransform.m11" startingValue:self.tweenView.layer.sublayerTransform.m11 endingValue:-0.30 duration:2.0 options:PMTweenOptionNone easingBlock:easing];
    
    self.group = [[PMTweenGroup alloc] initWithTweens:@[tween1, tween2, tween3, tween4, tween5, tween6] options:PMTweenOptionRepeat|PMTweenOptionReverse];
    self.group.numberOfRepeats = NSIntegerMax;

}


- (void)startTouchedHandler:(id)sender {
    [self.group startTween];
}

- (void)stopTouchedHandler:(id)sender {
    [self.group stopTween];
}

- (void)pauseTouchedHandler:(id)sender {
    [self.group pauseTween];
}

- (void)resumeTouchedHandler:(id)sender {
    [self.group resumeTween];
}

@end
