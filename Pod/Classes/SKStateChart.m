//
//  SKStateChart.m
//  Pods
//
//  Created by Shaheen Ghiassy on 1/19/15.
//
//

#import "SKStateChart.h"

typedef void (^StateBlock)(void);
typedef void (^MessageBlock)(SKStateChart *this);


@interface SKStateChart ()

@property (nonatomic, copy) NSDictionary *stateChart;

@property (nonatomic, copy) NSString *currentState;

@end


@implementation SKStateChart

- (instancetype)initWithStateChart:(NSDictionary *)stateChart {
    self = [super init];

    if (self) {
        _stateChart = [stateChart copy];
    }

    return self;
}

@end
