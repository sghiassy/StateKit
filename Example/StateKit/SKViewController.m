//
//  SKViewController.m
//  StateKit
//
//  Created by Shaheen Ghiassy on 01/19/2015.
//  Copyright (c) 2014 Shaheen Ghiassy. All rights reserved.
//

#import "SKViewController.h"
#import <SKStateChart.h>

@interface SKViewController ()

@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation SKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createHeader];
    [self createStateLabel];

    __weak SKViewController *weakSelf = self;
    NSDictionary *stateChart = @{@"root":@{
                                         @"enterState":^(SKStateChart *sc) {
                                             weakSelf.view.backgroundColor = [UIColor whiteColor];
                                             weakSelf.stateLabel.text = @"init change me";
                                         },
                                         @"darker":^(SKStateChart *sc) {
                                             [sc traverseToState:@"black"];
                                         },
                                         @"userPressedRedButton":^(SKStateChart *sc) {
                                             [sc traverseToState:@"red"];
                                         },
                                         @"subStates":@{
                                                 @"pink":@{
                                                         @"enterState":^(SKStateChart *sc) {
                                                             weakSelf.view.backgroundColor = [UIColor yellowColor];
                                                             weakSelf.stateLabel.text = sc.currentStateName;
                                                         }},
                                                 @"red":@{
                                                         @"enterState":^(SKStateChart *sc) {
                                                             weakSelf.view.backgroundColor = [UIColor redColor];
                                                             weakSelf.stateLabel.text = sc.currentStateName;
                                                         },
                                                         @"exitState":^(SKStateChart *sc) {
                                                             NSLog(@"Did exit %@", sc.currentStateName);
                                                         },
                                                         @"darker":^(SKStateChart *sc){
                                                             [sc traverseToState:@"purple"];
                                                         },
                                                         @"lighter":^(SKStateChart *sc){
                                                             [sc traverseToState:@"pink"];
                                                         },
                                                         @"subStates":@{
                                                                 @"purple":@{
                                                                     @"enterState":^(SKStateChart *sc) {
                                                                         weakSelf.view.backgroundColor = [UIColor purpleColor];
                                                                         weakSelf.stateLabel.text = sc.currentStateName;
                                                                     },
                                                                     @"exitState":^(SKStateChart *sc) {
                                                                         NSLog(@"Something");
                                                                     }
                                                                 }
                                                               },
                                                         },
                                                 @"green":@{
                                                         @"darker":^(SKStateChart *sc) {
                                                             [sc traverseToState:@"darkGreen"];
                                                         },
                                                         @"darkGreen":^{
                                                             weakSelf.view.backgroundColor = [UIColor darkGrayColor];
                                                         }},
                                                 @"blue":@{},
                                                 }
                                         }
                                 };

    SKStateChart *stateMachine = [[SKStateChart alloc] initWithStateChart:stateChart];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [stateMachine sendMessage:@"userPressedRedButton"];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [stateMachine sendMessage:@"darker"];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [stateMachine sendMessage:@"lighter"];
    });
}

- (void)createHeader {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"StateKit!!!";
    label.font = [UIFont systemFontOfSize:26];
    label.textColor = [UIColor blueColor];
    [self.view addSubview:label];
    [label sizeToFit];
    label.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[label]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"label":label}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[label]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"label":label}]];
}

- (void)createStateLabel {
    self.stateLabel = [[UILabel alloc] init];
    self.stateLabel.text = @"No State Yet";
    self.stateLabel.font = [UIFont systemFontOfSize:18];
    self.stateLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.stateLabel];
    [self.stateLabel sizeToFit];
    self.stateLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[label]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"label":self.stateLabel}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(70)-[label]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"label":self.stateLabel}]];
}

@end
