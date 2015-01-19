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

@end

@implementation SKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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

    SKStateChart *stateChart = [[SKStateChart alloc] init];
    [stateChart class];
}

@end
