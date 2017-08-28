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

/**
 default set to YES
 
 https://github.com/sghiassy/StateKit#message-bubbling
 
 Messages are first sent to the current state to see if there is a receiver for the message. If the current state does not respond to the message, the state chart will begin to bubble up the tree to find any parent states that respond to the message. If the current state plus any of the current state's parent states, do not respond to the message, the message will be quietly ignored.
 
 Set this to NO if you want a finite-state machine behavior.
 */
@property (nonatomic, assign) BOOL messageBubblingEnabled;

/**
 default set to NO
 
 Log messaging and state changing using `NSLog`
 */
@property (nonatomic, assign) BOOL debugLoggingEnabled;

- (instancetype)initWithStateChart:(NSDictionary *)stateChart;

- (void)goToState:(NSString *)goToState;

- (void)sendMessage:(NSString *)message;

@end

/**
 A Notification posted when `currentState` changes to a new value - does not trigger for intermediate states
 */
extern NSString *const SKStateChartDidChangeStateNotification;
