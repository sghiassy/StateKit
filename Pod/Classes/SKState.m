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

- (void)setSubState:(SKState *)state {
    [self.subStates setObject:state forKey:state.name];
}

#pragma mark - Description Methods

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"State:%@", self.name];

    // Iterate through events and create string from them
    if (self.events.count > 0) {
        NSString *events = [self stringFromDictionary:self.events];
        description = [NSString stringWithFormat:@"%@ events:%@", description, events];
    }

    if (self.subStates.count > 0) {
        NSString *subStates = [self stringFromDictionary:self.subStates];
        description = [NSString stringWithFormat:@"%@ subStates:%@", description, subStates];
    }

    return description;
}

- (NSString *)stringFromDictionary:(NSDictionary *)array {
    NSString *keys;
    // Iterate through events and create string from them
    if (array.count > 0) {

        for (id key in array) {
            if (keys) {
                keys = [NSString stringWithFormat:@"%@%@,", keys, key];
            } else {
                keys = [NSString stringWithFormat:@"%@,", key];
            }
        }

        keys = [keys substringToIndex:keys.length - 1]; // Remove trailing comma
    }

    return keys;
}

@end
