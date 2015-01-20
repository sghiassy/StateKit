//
//  SKState.m
//  Pods
//
//  Created by Shaheen Ghiassy on 1/20/15.
//
//

#import "SKState.h"

@interface SKState ()

@property (nonatomic, strong) NSMutableDictionary *events;
@property (nonatomic, strong) NSMutableDictionary *subStates;

@end

@implementation SKState

- (instancetype)init {
    self = [super init];

    if (self) {
        _events = [[NSMutableDictionary alloc] init];
        _subStates = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)setEvent:(NSString *)messageName forBlock:(void(^)(void))block {
    [self.events setObject:[block copy] forKey:[messageName copy]];
}

- (void)setSubState:(NSString *)stateName forState:(SKState *)state {
    [self.subStates setObject:[state copy] forKey:[stateName copy]];
}

@end
