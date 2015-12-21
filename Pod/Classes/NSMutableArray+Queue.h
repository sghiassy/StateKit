//
//  NSMutableArray+Queue.h
//  Pods
//
//  Copyright (c) 2014, Groupon, Inc.
//  Created by Shaheen Ghiassy on 01/19/2015.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Queue)

- (id)sk_dequeue;
- (void)sk_enqueue:(id)obj;

@end
