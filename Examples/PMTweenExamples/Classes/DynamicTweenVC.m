//
//  DynamicTweenVC.m
//  PMTweenExamples
//
//  Created by Brett Walker on 5/5/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "DynamicTweenVC.h"
#import "PMTweenUnit.h"
#import "PMTweenGroup.h"
#import "PMTweenEasingQuadratic.h"

@interface DynamicTweenVC ()

@property (nonatomic, assign) BOOL createdUI;
@property (nonatomic, strong) UIView *tweenView;
@property (nonatomic, strong) NSMutableArray *tweens;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

- (void)setupUI;
- (void)startTouchedHandler:(id)sender;
- (void)stopTouchedHandler:(id)sender;
- (void)pauseTouchedHandler:(id)sender;
- (void)resumeTouchedHandler:(id)sender;
- (void)viewTappedHandler:(UIGestureRecognizer *)gesture;

@end

@implementation DynamicTweenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.createdUI) {
        [self setupUI];
        
        self.tweens = [NSMutableArray array];
        
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTappedHandler:)];
        [self.view addGestureRecognizer:self.tapRecognizer];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (PMTweenUnit *unit in self.tweens) {
        [unit stopTween];
    }
}

- (void)viewDidLayoutSubviews {
    
    if (!self.createdUI) {
        CGFloat content_top = 0;
        if ([self respondsToSelector:@selector(topLayoutGuide)]) {
            content_top = self.topLayoutGuide.length;
        }
        self.tweenView.frame = CGRectMake(20, content_top+20, 50, 50);
        
        self.createdUI = YES;
    }
}

- (void)setupUI {
    
    UILabel *instruct = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 200, 40)];
    instruct.font = [UIFont systemFontOfSize:12];
    instruct.textColor = [UIColor blackColor];
    instruct.backgroundColor = [UIColor whiteColor];
    instruct.userInteractionEnabled = NO;
    instruct.numberOfLines = 2;
    [instruct setText:@"Tap on background to change the tween destination."];
    [self.view addSubview:instruct];
    
    self.tweenView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    self.tweenView.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:164.0/255.0 blue:68.0/255.0 alpha:1.0];
    [self.view addSubview:self.tweenView];
    
    CGFloat currx = 10;
    CGFloat btn_y = self.view.frame.size.height - 60;
    CGFloat btn_spacer = 10;
    
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



- (void)viewTappedHandler:(UIGestureRecognizer *)gesture {
    
    if (gesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    CGPoint point = [gesture locationInView:self.view];
    //CGFloat slope_x = (point.x - self.tweenView.center.x) / self.view.frame.size.width;
    //CGFloat slope_y = (point.y - self.tweenView.center.y) / self.view.frame.size.height;
    
    __weak typeof(self) weak_self = self;

    PMTweenEasingBlock easing = [PMTweenEasingQuadratic easingInOut];
    PMTweenUnit *tapx = [[PMTweenUnit alloc] initWithObject:self.tweenView propertyKeyPath:@"frame.origin.x" startingValue:self.tweenView.center.x endingValue:point.x duration:1.5 options:PMTweenOptionNone easingBlock:easing];
    tapx.additive = YES;
    tapx.completeBlock = ^void(NSObject<PMTweening> *tween) {
        __strong typeof(self) strong_self = weak_self;
        [strong_self.tweens removeObject:tween];
    };
    [self.tweens addObject:tapx];
    PMTweenUnit *tapy = [[PMTweenUnit alloc] initWithObject:self.tweenView propertyKeyPath:@"frame.origin.y" startingValue:self.tweenView.center.y endingValue:point.y duration:1.5 options:PMTweenOptionNone easingBlock:easing];
    tapy.additive = YES;
    tapy.completeBlock = ^void(NSObject<PMTweening> *tween) {
        __strong typeof(self) strong_self = weak_self;
        [strong_self.tweens removeObject:tween];
    };
    [self.tweens addObject:tapy];
    
    [tapx startTween];
    [tapy startTween];
    
}


- (void)startTouchedHandler:(id)sender {

}

- (void)stopTouchedHandler:(id)sender {
    for (PMTweenUnit *unit in self.tweens) {
        [unit stopTween];
    }
    [self.tweens removeAllObjects];
}

- (void)pauseTouchedHandler:(id)sender {
    for (PMTweenUnit *unit in self.tweens) {
        [unit pauseTween];
    }
    
    self.tapRecognizer.enabled = NO;
}

- (void)resumeTouchedHandler:(id)sender {
    for (PMTweenUnit *unit in self.tweens) {
        [unit resumeTween];
    }
    
    self.tapRecognizer.enabled = YES;
}

@end
