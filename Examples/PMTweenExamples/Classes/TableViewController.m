//
//  TableViewController.m
//  PMTweenExamples
//
//  Created by Brett Walker on 4/22/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import "TableViewController.h"
#import "BasicTweenVC.h"
#import "BasicPhysicsTweenVC.h"
#import "GroupTweenVC.h"
#import "SequenceTweenVC.h"
#import "SequenceNoncontiguousVC.h"
#import "Transform3DVC.h"
#import "DynamicTweenVC.h"
#import "MassTweensVC.h"

@interface TableViewController ()

@property (nonatomic, strong) NSArray *examples;

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        _examples = @[@"Basic Tween",
                      @"Basic Physics Tween",
                      @"Group (+Reversing)",
                      @"Sequence (Rev. Contiguous)",
                      @"Sequence (Rev. Noncontiguous)",
                      @"CATransform3D Tween",
                      @"Dynamic Tween",
                      @"250 Random Tweens"
                     ];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PMTween Examples";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.examples count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = [indexPath row];
    static NSString *identifier = @"ExampleCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSString *label_text = self.examples[index];
    
    
    [cell.textLabel setText:label_text];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = [indexPath row];

    UIViewController *vc = nil;
    switch (index) {
        case PMTweenExampleBasic:
            vc = [[BasicTweenVC alloc] init];
            break;
        case PMTweenExampleBasicPhysics:
            vc = [[BasicPhysicsTweenVC alloc] init];
            break;
        case PMTweenExampleGroup:
            vc = [[GroupTweenVC alloc] init];
            break;
        case PMTweenExampleSequence:
            vc = [[SequenceTweenVC alloc] init];
            break;
        case PMTweenExampleNoncontiguousSequence:
            vc = [[SequenceNoncontiguousVC alloc] init];
            break;
        case PMTweenExampleTransform3D:
            vc = [[Transform3DVC alloc] init];
            break;
        case PMTweenExampleDynamic:
            vc = [[DynamicTweenVC alloc] init];
            break;
        case PMTweenExampleMassTweens:
            vc = [[MassTweensVC alloc] init];
            break;
        default:
            vc = [[BasicTweenVC alloc] init];
            break;
    }

    vc.title = self.examples[index];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
