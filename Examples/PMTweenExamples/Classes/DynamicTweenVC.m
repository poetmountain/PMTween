//
//  DynamicTweenVC.m
//  PMTweenExamples
//
//  Created by Brett Walker on 5/5/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "DynamicTweenVC.h"
#import "PMTweenPhysicsUnit.h"
#import "PMTweenGroup.h"

@interface DynamicTweenVC ()

@property (nonatomic, assign) BOOL createdUI;
@property (nonatomic, strong) UIView *tweenView;
@property (nonatomic, strong) PMTweenPhysicsUnit *tweenx;
@property (nonatomic, strong) PMTweenPhysicsUnit *tweeny;
@property (nonatomic, strong) PMTweenGroup *group;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

- (void)setupUI;
- (void)setupEasing;
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
        
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTappedHandler:)];
        [self.view addGestureRecognizer:self.tapRecognizer];
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
        self.tweenView.frame = CGRectMake(20, content_top+20, 50, 50);
        
        [self setupEasing];
        
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
    [instruct setText:@"Tap on background to redirect the tween's path."];
    [self.view addSubview:instruct];
    
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
    
    self.tweenx = [[PMTweenPhysicsUnit alloc] initWithObject:self.tweenView propertyKeyPath:@"center.x" startingValue:self.tweenView.center.x velocity:4 friction:0.5 options:PMTweenOptionNone];
    self.tweeny = [[PMTweenPhysicsUnit alloc] initWithObject:self.tweenView propertyKeyPath:@"center.y" startingValue:self.tweenView.center.y velocity:4 friction:0.5 options:PMTweenOptionNone];
    
    self.group = [[PMTweenGroup alloc] initWithTweens:@[self.tweenx, self.tweeny] options:PMTweenOptionNone];
    self.group.completeBlock = ^void(NSObject<PMTweening> *tween) {
        NSLog(@"tween complete!");
    };
}


- (void)viewTappedHandler:(UIGestureRecognizer *)gesture {
    
    if (gesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    CGPoint point = [gesture locationInView:self.view];
    CGFloat slope_x = (point.x - self.tweenView.center.x) / self.view.frame.size.width;
    CGFloat slope_y = (point.y - self.tweenView.center.y) / self.view.frame.size.height;
    
    [self.group stopTween];

    self.tweenx.startingValue = self.tweenView.center.x;
    self.tweeny.startingValue = self.tweenView.center.y;
    self.tweenx.velocity = 8 * slope_x;
    self.tweeny.velocity = 8 * slope_y;
    
    [self.group startTween];
    
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
