//
//  SKState.h
//  Pods
//
//  Created by Shaheen Ghiassy on 1/20/15.
//
//

#import <Foundation/Foundation.h>

@interface SKState : NSObject

- (void)setEvent:(NSString *)messageName forBlock:(void(^)(void))block;
- (void)setSubState:(NSString *)stateName forState:(SKState *)state;

@end
