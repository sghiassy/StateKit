//
//  SKState.h
//  Pods
//
//  Copyright (c) 2014, Groupon, Inc.
//  Created by Shaheen Ghiassy on 01/19/2015.
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKTypeDefs.h"

@interface SKState : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) SKState *parentState;

- (NSString *)description;

- (void)setEvent:(NSString *)messageName forBlock:(void(^)(void))block;

- (MessageBlock)blockForMessage:(NSString *)message;

- (NSDictionary *)getSubStates;

- (SKState *)subState:(NSString *)subStateName;

- (void)setSubState:(SKState *)state;

@end
