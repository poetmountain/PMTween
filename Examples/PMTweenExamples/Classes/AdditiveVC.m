//
//  AdditiveVC.m
//  PMTweenExamples
//
//  Created by Brett Walker on 7/11/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "AdditiveVC.h"
#import "PMTweenEasingQuadratic.h"
#import "PMTweenUnit.h"

@interface AdditiveVC ()

@property (nonatomic, assign) BOOL createdUI;
@property (nonatomic, strong) UIView *tweenView;
@property (nonatomic, strong) PMTweenUnit *openTween;
@property (nonatomic, strong) PMTweenUnit *closeTween;

- (void)setupUI;
- (void)setupEasing;
- (void)openTouchedHandler:(id)sender;
- (void)closeTouchedHandler:(id)sender;
- (void)pauseTouchedHandler:(id)sender;
- (void)resumeTouchedHandler:(id)sender;

@end

@implementation AdditiveVC

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
    
    [self.openTween stopTween];
    [self.closeTween stopTween];
}

- (void)viewDidLayoutSubviews {
    
    if (!self.createdUI) {
        
        [self setupEasing];
        
        self.createdUI = YES;
    }
}

- (void)setupUI {
    
    self.tweenView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width , self.view.frame.size.height)];
    self.tweenView.backgroundColor = [UIColor colorWithRed:91.0/255.0 green:189.0/255.0 blue:231.0/255.0 alpha:1.0];
    [self.view addSubview:self.tweenView];
    
    CGFloat currx = 10;
    CGFloat btn_y = self.view.frame.size.height - 60;
    CGFloat btn_spacer = 10;
    
    UIButton *open_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    open_btn.frame = CGRectMake(currx, btn_y, 60, 40);
    [open_btn setTitle:@"Open" forState:UIControlStateNormal];
    [open_btn addTarget:self action:@selector(openTouchedHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:open_btn];
    
    currx += open_btn.frame.size.width + btn_spacer;
    
    UIButton *close_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    close_btn.frame = CGRectMake(currx, btn_y, 60, 40);
    [close_btn setTitle:@"Close" forState:UIControlStateNormal];
    [close_btn addTarget:self action:@selector(closeTouchedHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close_btn];
    
    currx += close_btn.frame.size.width + btn_spacer;
    
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
    PMTweenEasingBlock easing = [PMTweenEasingQuadratic easingInOut];
    
    self.openTween = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.origin.y" startingValue:self.tweenView.frame.origin.y endingValue:0 duration:1.6 options:PMTweenOptionNone easingBlock:easing];
    self.openTween.additive = YES;
    self.closeTween = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.origin.y" startingValue:0 endingValue:self.view.frame.size.height duration:1.5 options:PMTweenOptionNone easingBlock:easing];
    self.closeTween.additive = YES;
    
}


- (void)openTouchedHandler:(id)sender {
    [self.openTween startTween];
}

- (void)closeTouchedHandler:(id)sender {
    [self.closeTween startTween];
}

- (void)pauseTouchedHandler:(id)sender {
    [self.openTween pauseTween];
    [self.closeTween pauseTween];
}

- (void)resumeTouchedHandler:(id)sender {
    [self.openTween resumeTween];
    [self.closeTween resumeTween];
}

@end
