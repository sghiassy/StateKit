//
//  SKTypeDefs.h
//  Pods
//
//  Copyright (c) 2014, Groupon, Inc.
//  Created by Shaheen Ghiassy on 01/19/2015.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

// Type Defines
@class SKStateChart;
typedef void (^StateBlock)(void);
typedef void (^MessageBlock)(SKStateChart *sc);

// Use this macro to simplify the final code
// --- from ---
// @"userPressedRedButton":^(SKStateChart *sc) {
//     [sc goToState:@"red"];
// },
// --- to ---
// SKDefineTransition_Event2State(@"userPressedRedButton", @"red"),

#define SKDefineTransition_Event2State(event,nextState) event:^(SKStateChart *sc) { [sc goToState:nextState]; }
