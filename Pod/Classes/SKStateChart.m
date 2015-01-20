//
//  SKStateChart.m
//  Pods
//
//  Created by Shaheen Ghiassy on 1/19/15.
//
//

#import "SKStateChart.h"

@interface SKStateChart ()

@property (nonatomic, copy) NSDictionary *stateChart;

@property (nonatomic, copy) NSString *currentState;

@end


@implementation SKStateChart

- (instancetype)initWithStateChart:(NSDictionary *)stateChart {
    self = [super init];

    if (self) {
        NSDictionary *root = [stateChart objectForKey:@"root"];
        NSAssert(root != nil, @"The stateChart you input does not have a root state");

        _stateChart = root;

        MessageBlock rootBlock = [_stateChart objectForKey:@"enterState"];
        rootBlock(self);
    }

    return self;
}

- (void)goToState:(NSString *)goToState {

}

@end
