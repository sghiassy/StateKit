//
//  SKViewController.m
//  StateKit
//
//  Copyright (c) 2014, Groupon, Inc.
//  Created by Shaheen Ghiassy on 01/19/2015.
//  All rights reserved.
//

#import "SKViewController.h"
#import <SKStateChart.h>

@interface SKViewController ()

// Views
@property (nonatomic, strong) UILabel *appTitle;
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
                                         SKDefineTransition_Event2State(@"darker", @"black"),
                                         SKDefineTransition_Event2State(@"userPressedRedButton", @"red"),
                                         SKDefineTransition_Event2State(@"userIsFeelingBlue", @"blue"),
                                         @"subStates":@{
                                                 @"pink":@{
                                                         @"enterState":^(SKStateChart *sc) {
                                                             weakSelf.view.backgroundColor = [UIColor yellowColor];
                                                             weakSelf.stateLabel.text = sc.currentState.name;
                                                         }},
                                                 @"red":@{
                                                         @"enterState":^(SKStateChart *sc) {
                                                             weakSelf.view.backgroundColor = [UIColor redColor];
                                                             weakSelf.stateLabel.text = sc.currentState.name;
                                                         },
                                                         @"exitState":^(SKStateChart *sc) {
                                                             NSLog(@"Did exit %@", sc.currentState.name);
                                                         },
                                                         SKDefineTransition_Event2State(@"darker", @"purple"),
                                                         SKDefineTransition_Event2State(@"lighter", @"pink"),
                                                         @"subStates":@{
                                                                 @"purple":@{
                                                                     @"enterState":^(SKStateChart *sc) {
                                                                         weakSelf.view.backgroundColor = [UIColor purpleColor];
                                                                         weakSelf.stateLabel.text = sc.currentState.name;
                                                                     },
                                                                     @"exitState":^(SKStateChart *sc) {
                                                                         NSLog(@"Something");
                                                                     }
                                                                 }
                                                               },
                                                         },
                                                 @"green":@{
                                                         SKDefineTransition_Event2State(@"darker", @"darkGreen"),
                                                         @"darkGreen":^{
                                                             weakSelf.view.backgroundColor = [UIColor darkGrayColor];
                                                         }},
                                                 @"blue":@{
                                                         @"enterState":^(SKStateChart *sc){
                                                             weakSelf.appTitle.textColor = [UIColor blackColor];
                                                             weakSelf.view.backgroundColor = [UIColor blueColor];
                                                             weakSelf.stateLabel.text = sc.currentState.name;
                                                         }},
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

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [stateMachine sendMessage:@"userIsFeelingBlue"];
    });
}

- (void)createHeader {
    _appTitle = [[UILabel alloc] init];
    _appTitle.text = @"StateKit!!!";
    _appTitle.font = [UIFont systemFontOfSize:26];
    _appTitle.textColor = [UIColor blueColor];
    [self.view addSubview:_appTitle];
    [_appTitle sizeToFit];
    _appTitle.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[label]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"label":_appTitle}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[label]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"label":_appTitle}]];
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
