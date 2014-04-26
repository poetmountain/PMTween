//
//  MassTweensVC.m
//  PMTweenExamples
//
//  Created by Brett Walker on 4/23/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "MassTweensVC.h"
#import "PMTweenCATempo.h"
#import "PMTweenEasingCubic.h"
#import "PMTweenUnit.h"
#import "PMTweenGroup.h"

@interface MassTweensVC ()

@property (nonatomic, assign) BOOL createdUI;
@property (nonatomic, strong) PMTweenGroup *group;

- (void)setupUI;
- (void)setupEasing;
- (void)startTouchedHandler:(id)sender;
- (void)stopTouchedHandler:(id)sender;
- (void)pauseTouchedHandler:(id)sender;
- (void)resumeTouchedHandler:(id)sender;

@end

@implementation MassTweensVC

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
        [self setupEasing];
        self.createdUI = YES;
    }
}


- (void)setupUI {
 
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
    PMTweenEasingBlock easing = [PMTweenEasingCubic easingInOut];

    NSMutableArray *tweens = [NSMutableArray array];
    
    CGFloat content_top = 0;
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        content_top = self.topLayoutGuide.length;
    }
    
    for (NSInteger i=0; i<250; i++) {
        NSInteger x = 10 + arc4random_uniform(self.view.frame.size.width-40);
        NSInteger y = content_top + arc4random_uniform(self.view.frame.size.height-150);
        
        UIView *tween_view = [[UIView alloc] initWithFrame:CGRectMake(x, y, 10, 10)];
        tween_view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        [self.view addSubview:tween_view];
        
        PMTweenUnit *tweenx = [[PMTweenUnit alloc] initWithObject:tween_view  propertyKeyPath:@"frame.origin.x" startingValue:tween_view.frame.origin.x endingValue:10+arc4random_uniform(self.view.frame.size.width-20) duration:2.0 options:PMTweenOptionNone easingBlock:easing];
        tweenx.completeBlock = ^void(NSObject<PMTweening> *tween) {
            PMTweenUnit *unit = (PMTweenUnit *)tween;
            unit.endingValue = 10+arc4random_uniform(self.view.frame.size.width-20);
        };

        PMTweenUnit *tweeny = [[PMTweenUnit alloc] initWithObject:tween_view  propertyKeyPath:@"frame.origin.y" startingValue:tween_view.frame.origin.y endingValue:content_top+arc4random_uniform(self.view.frame.size.height-150) duration:2.0 options:PMTweenOptionNone easingBlock:easing];
        tweeny.completeBlock = ^void(NSObject<PMTweening> *tween) {
            PMTweenUnit *unit = (PMTweenUnit *)tween;
            unit.endingValue = content_top+arc4random_uniform(self.view.frame.size.height-150);
        };

        PMTweenGroup *xy = [[PMTweenGroup alloc] initWithTweens:@[tweenx, tweeny] options:PMTweenOptionNone];
        [tweens addObject:xy];
    }
    
    self.group = [[PMTweenGroup alloc] initWithTweens:tweens options:PMTweenOptionRepeat|PMTweenOptionReverse];
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
