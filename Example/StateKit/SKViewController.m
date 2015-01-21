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
                                             [sc goToState:@"black"];
                                         },
                                         @"userPressedRedButton":^(SKStateChart *sc) {
                                             [sc goToState:@"red"];
                                         },
                                         @"subStates":@{
                                                 @"pink":@{
                                                         @"enterState":^(SKStateChart *sc) {
                                                             weakSelf.view.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:200.0f/200.0f blue:200.0f/200.0f alpha:0];
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
                                                             [sc goToState:@"purple"];
                                                         },
                                                         @"lighter":^(SKStateChart *sc){
                                                             [sc goToState:@"pink"];
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
                                                             [sc goToState:@"darkGreen"];
                                                         },
                                                         @"darkGreen":^{
                                                             weakSelf.view.backgroundColor = [UIColor darkGrayColor];
                                                         }},
                                                 @"blue":@{},
                                                 }
                                         }
                                 };

    SKStateChart *stateMachine = [[SKStateChart alloc] initWithStateChart:stateChart];
    [stateMachine class];

    [stateMachine sendMessage:@"userPressedRedButton"];
    [stateMachine sendMessage:@"darker"];
    [stateMachine sendMessage:@"lighter"];
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
