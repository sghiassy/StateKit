//
//  SKState.h
//  Pods
//
//  Created by Shaheen Ghiassy on 1/20/15.
//
//

#import <Foundation/Foundation.h>

@interface SKState : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) SKState *parentState;

- (NSString *)description;

- (void)setEvent:(NSString *)messageName forBlock:(void(^)(void))block;
- (void)setSubState:(SKState *)state;

@end
