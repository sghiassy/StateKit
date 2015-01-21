//
//  NSMutableArray+Queue.h
//  Pods
//
//  Created by Shaheen Ghiassy on 1/20/15.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Queue)

- (id)dequeue;
- (void)enqueue:(id)obj;

@end
