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