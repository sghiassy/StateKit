//
//  SKStateChart.h
//  Pods
//
//  Copyright (c) 2014, Groupon, Inc.
//  Created by Shaheen Ghiassy on 01/19/2015.
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKState.h" // Including definition in public header to keep user's import definitions cleaner

@interface SKStateChart : NSObject

@property (nonatomic, strong, readonly) SKState *currentState;

- (instancetype)initWithStateChart:(NSDictionary *)stateChart;

- (void)goToState:(NSString *)goToState;

- (void)sendMessage:(NSString *)message;

@end
