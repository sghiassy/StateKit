//
//  MultiThreading_Tests.m
//  StateKit
//
//  Created by Shaheen Ghiassy on 1/22/15.
//  Copyright (c) 2015 Shaheen Ghiassy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SKStateChart.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "MockLogger.h"

SpecBegin(StateChart_MultiThreading)

describe(@"SKStateMachine", ^{

    __block SKStateChart *stateChart;
    __block id logMock;

    NSDictionary *chart = @{@"bad_root":@{},
                            @"root":@{
                                    @"enterState":^(SKStateChart *sc) {
                                        NSString *message = [NSString stringWithFormat:@"entered %@ state", sc.currentState.name];
                                        [logMock log:message];
                                    },
                                    @"exitState":^(SKStateChart *sc) {
                                        NSString *message = [NSString stringWithFormat:@"exited %@ state", sc.currentState.name];
                                        [logMock log:message];
                                    },
                                    @"goDownAState":^(SKStateChart *sc) {
                                        if ([sc.currentState.name isEqualToString:@"root"]) {
                                            [sc goToState:@"level:1"];
                                        } else {
                                            NSString *lastChar = [sc.currentState.name substringFromIndex:[sc.currentState.name length] - 1];
                                            NSString *newDepth = [NSString stringWithFormat:@"%d", [lastChar integerValue] + 1];
                                            NSString *newStateName = [NSString stringWithFormat:@"level:%@", newDepth];
                                            [sc goToState:newStateName];
                                        }
                                    },
                                    @"popToParentState":^(SKStateChart *sc) {
                                        if ([sc.currentState.name isEqualToString:@"level:1"]) {
                                            [sc goToState:@"root"];
                                        } else {
                                            NSString *lastChar = [sc.currentState.name substringFromIndex:[sc.currentState.name length] - 1];
                                            NSString *newDepth = [NSString stringWithFormat:@"%d", [lastChar integerValue] - 1];
                                            NSString *newStateName = [NSString stringWithFormat:@"level:%@", newDepth];
                                            [sc goToState:newStateName];
                                        }
                                    },
                                    @"yellWaka":^(SKStateChart *sc) {
                                        [logMock log:@"wakaRoot"];
                                    },
                                    @"subStates":@{
                                            @"level:1":@{
                                                    @"enterState":^(SKStateChart *sc) {
                                                        NSString *message = [NSString stringWithFormat:@"entered %@ state", sc.currentState.name];
                                                        [logMock log:message];
                                                    },
                                                    @"exitState":^(SKStateChart *sc) {
                                                        NSString *message = [NSString stringWithFormat:@"exited %@ state", sc.currentState.name];
                                                        [logMock log:message];
                                                    },
                                                    @"yellWaka":^(SKStateChart *sc) {
                                                        [logMock log:@"waka1"];
                                                    },
                                                    @"subStates":@{
                                                            @"level:2":@{
                                                                    @"enterState":^(SKStateChart *sc) {
                                                                        NSString *message = [NSString stringWithFormat:@"entered %@ state", sc.currentState.name];
                                                                        [logMock log:message];
                                                                    },
                                                                    @"exitState":^(SKStateChart *sc) {
                                                                        NSString *message = [NSString stringWithFormat:@"exited %@ state", sc.currentState.name];
                                                                        [logMock log:message];
                                                                    },
                                                                    @"yellWaka":^(SKStateChart *sc) {
                                                                        [logMock log:@"waka2"];
                                                                    },
                                                                    @"subStates":@{
                                                                            @"level:3":@{
                                                                                    @"enterState":^(SKStateChart *sc) {
                                                                                        NSString *message = [NSString stringWithFormat:@"entered %@ state", sc.currentState.name];
                                                                                        [logMock log:message];
                                                                                    },
                                                                                    @"exitState":^(SKStateChart *sc) {
                                                                                        NSString *message = [NSString stringWithFormat:@"exited %@ state", sc.currentState.name];
                                                                                        [logMock log:message];
                                                                                    },
                                                                                    @"yellWaka":^(SKStateChart *sc) {
                                                                                        [logMock log:@"waka3"];
                                                                                    },
                                                                                    @"subStates":@{
                                                                                            @"level:4":@{
                                                                                                    @"enterState":^(SKStateChart *sc) {
                                                                                                        NSString *message = [NSString stringWithFormat:@"entered %@ state", sc.currentState.name];
                                                                                                        [logMock log:message];
                                                                                                    },
                                                                                                    @"exitState":^(SKStateChart *sc) {
                                                                                                        NSString *message = [NSString stringWithFormat:@"exited %@ state", sc.currentState.name];
                                                                                                        [logMock log:message];
                                                                                                    },
                                                                                                    @"yellWaka":^(SKStateChart *sc) {
                                                                                                        [logMock log:@"waka4"];
                                                                                                    }}
                                                                                            }
                                                                                    }
                                                                            }
                                                                    }
                                                            }
                                                    }
                                            }
                                    }
                            };

    beforeEach(^{
        logMock = mock([MockLogger class]);
        stateChart = [[SKStateChart alloc] initWithStateChart:chart];
    });

    it(@"can be instantiated", ^{
        expect(stateChart).to.beTruthy();
    });

    it(@"can handle multi-threaded event calls", ^{

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [stateChart sendMessage:@"goDownAState"];

            dispatch_async(dispatch_get_main_queue(), ^{
                expect(stateChart.currentState.name).to.equal(@"leev,ll,l,el:1");
            });


            [stateChart sendMessage:@"goDownAState"];
            expect(stateChart.currentState.name).to.equal(@"level:2");
            [stateChart sendMessage:@"goDownAState"];
            expect(stateChart.currentState.name).to.equal(@"level:3");
            [stateChart sendMessage:@"goDownAState"];
            expect(stateChart.currentState.name).to.equal(@"level:4");
            [stateChart sendMessage:@"goDownAState"];
            expect(stateChart.currentState.name).to.equal(@"level:4");
        });

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            expect(stateChart.currentState.name).to.equal(@"level:4");
            [stateChart sendMessage:@"popToParentState"];
            expect(stateChart.currentState.name).to.equal(@"level:3");
            [stateChart sendMessage:@"popToParentState"];
            expect(stateChart.currentState.name).to.equal(@"level:2");
            [stateChart sendMessage:@"popToParentState"];
            expect(stateChart.currentState.name).to.equal(@"level:4");
        });

    });
});

SpecEnd

