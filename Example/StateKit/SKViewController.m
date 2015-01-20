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
                                         @"red":@{
                                                 @"enterState":^(SKStateChart *sc) {
                                                     weakSelf.view.backgroundColor = [UIColor redColor];
                                                     weakSelf.stateLabel.text = sc.currentState;
                                                 },
                                                 @"exitState":^(SKStateChart *sc) {
                                                     NSLog(@"Did exit %@", sc.currentState);
                                                 },
                                                 @"messages":@{
                                                         @"darker":^(SKStateChart *sc){
                                                             [sc goToState:@"purple"];
                                                         }},
                                                 @"purple":^{

                                                 }},
                                         @"green":@{
                                                 @"messages":@{
                                                         @"darker":^(SKStateChart *sc) {
                                                             [sc goToState:@"darkGreen"];
                                                         }
                                                 },
                                                 @"darkGreen":^{
                                                     weakSelf.view.backgroundColor = [UIColor darkGrayColor];
                                                 }},
                                         @"blue":@{},
                                         @"messages":@{
                                                 @"darker":[^(SKStateChart *sc) {
                                                     [sc goToState:@"black"];
                                                 } copy]
                                                 },
                                         @"enterState":[^(SKStateChart *sc) {
                                             weakSelf.view.backgroundColor = [UIColor whiteColor];
                                             weakSelf.stateLabel.text = @"init change me";
                                         } copy]
                                         }};

    SKStateChart *stateMachine = [[SKStateChart alloc] initWithStateChart:stateChart];
    [stateMachine class];
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
