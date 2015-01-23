//
//  CrazyStateTransition_Tests.m
//  StateKit
//
//  Created by Shaheen Ghiassy on 1/23/15.
//  Copyright (c) 2015 Shaheen Ghiassy. All rights reserved.
//

#import <SKStateChart.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "MockLogger.h"

SpecBegin(StateChart_Errorneous_Transitions)

describe(@"SKStateMachine", ^{

    __block SKStateChart *stateChart;
    __block id logMock;


    it(@"it can handle multi-state transitions in one pass", ^{
        NSDictionary *chart = @{@"bad_root":@{},
                                @"root":@{
                                        @"enterState":^(SKStateChart *sc) {
                                            [sc goToState:@"level:1"];
                                        },
                                        @"subStates":@{
                                                @"level:1":@{
                                                        @"enterState":^(SKStateChart *sc) {
                                                            [sc goToState:@"level:2"];
                                                        },
                                                        @"subStates":@{
                                                                @"level:2":@{
                                                                        @"enterState":^(SKStateChart *sc) {
                                                                            [sc goToState:@"level:2"];
                                                                        },
                                                                        @"subStates":@{
                                                                                @"level:3":@{
                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                        },
                                                                                        @"subStates":@{
                                                                                                @"level:4":@{
                                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                                        }
                                                                                                        }
                                                                                                }
                                                                                        }
                                                                                }
                                                                        }
                                                                }
                                                        }
                                                }
                                        }
                                };

        logMock = mock([MockLogger class]);
        stateChart = [[SKStateChart alloc] initWithStateChart:chart];
        expect(stateChart.currentState.name).to.equal(@"level:2");
    });


    it(@"it can handle multi-state transitions in one pass", ^{
        NSDictionary *chart = @{@"bad_root":@{},
                                @"root":@{
                                        @"enterState":^(SKStateChart *sc) {
                                            [logMock log:@"entered root state"];
                                            [sc goToState:@"level:1"];
                                        },
                                        @"subStates":@{
                                                @"level:1":@{
                                                        @"enterState":^(SKStateChart *sc) {
                                                            [logMock log:@"entered level:1 state"];
                                                            [sc goToState:@"level:2"];
                                                        },
                                                        @"subStates":@{
                                                                @"level:2":@{
                                                                        @"enterState":^(SKStateChart *sc) {
                                                                            [logMock log:@"entered level:2 state"];
                                                                            [sc goToState:@"level:3"];
                                                                        },
                                                                        @"subStates":@{
                                                                                @"level:3":@{
                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                            [logMock log:@"entered level:3 state"];
                                                                                            [sc goToState:@"level:4"];
                                                                                        },
                                                                                        @"subStates":@{
                                                                                                @"level:4":@{
                                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                                            [logMock log:@"entered level:4 state"];
                                                                                                            [sc goToState:@"level:2"];
                                                                                                        }
                                                                                                        }
                                                                                                }
                                                                                        }
                                                                                }
                                                                        }
                                                                }
                                                        }
                                                }
                                        }
                                };

        logMock = mock([MockLogger class]);
        stateChart = [[SKStateChart alloc] initWithStateChart:chart];
        expect(stateChart.currentState.name).to.equal(@"level:2");
        [verifyCount(logMock, times(1)) log:@"entered root state"];
        [verifyCount(logMock, times(1)) log:@"entered level:1 state"];
        [verifyCount(logMock, times(1)) log:@"entered level:2 state"];
        [verifyCount(logMock, times(1)) log:@"entered level:3 state"];
        [verifyCount(logMock, times(1)) log:@"entered level:4 state"];
    });

    it(@"it can handle long multi-branch state transitions", ^{
        NSDictionary *chart = @{@"bad_root":@{},
                                @"root":@{
                                        @"enterState":^(SKStateChart *sc) {
                                            [logMock log:@"entered root state"];
                                            [sc goToState:@"level:1"];
                                        },
                                        @"subStates":@{
                                                @"altLevel:1":@{
                                                        @"enterState":^(SKStateChart *sc) {
                                                            [logMock log:@"entered altLevel:1 state"];
                                                            [sc goToState:@"altLevel:2"];
                                                        },
                                                        @"subStates":@{
                                                                @"altLevel:2":@{
                                                                        @"enterState":^(SKStateChart *sc) {
                                                                            [logMock log:@"entered altLevel:2 state"];
                                                                            [sc goToState:@"altLevel:3"];
                                                                        },
                                                                        @"subStates":@{
                                                                                @"altLevel:3":@{
                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                            [logMock log:@"entered altLevel:3 state"];
                                                                                            [sc goToState:@"altLevel:4"];
                                                                                        },
                                                                                        @"subStates":@{
                                                                                                @"altLevel:4":@{
                                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                                            [logMock log:@"entered altLevel:4 state"];
                                                                                                            [sc goToState:@"altLevel:2"];
                                                                                                        }
                                                                                                        }
                                                                                                }
                                                                                        }
                                                                                }
                                                                        }
                                                                }
                                                        },
                                                @"level:1":@{
                                                        @"enterState":^(SKStateChart *sc) {
                                                            [logMock log:@"entered level:1 state"];
                                                            [sc goToState:@"level:2"];
                                                        },
                                                        @"subStates":@{
                                                                @"level:2":@{
                                                                        @"enterState":^(SKStateChart *sc) {
                                                                            [logMock log:@"entered level:2 state"];
                                                                            [sc goToState:@"level:3"];
                                                                        },
                                                                        @"subStates":@{
                                                                                @"level:3":@{
                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                            [logMock log:@"entered level:3 state"];
                                                                                            [sc goToState:@"level:4"];
                                                                                        },
                                                                                        @"subStates":@{
                                                                                                @"level:4":@{
                                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                                            [logMock log:@"entered level:4 state"];
                                                                                                            [sc goToState:@"altLevel:1"];
                                                                                                        }
                                                                                                        }
                                                                                                }
                                                                                        }
                                                                                }
                                                                        }
                                                                }
                                                        }
                                                }
                                        }
                                };

        logMock = mock([MockLogger class]);
        stateChart = [[SKStateChart alloc] initWithStateChart:chart];
        expect(stateChart.currentState.name).to.equal(@"altLevel:2");
        [verifyCount(logMock, times(1)) log:@"entered root state"];
        [verifyCount(logMock, times(1)) log:@"entered level:1 state"];
        [verifyCount(logMock, times(1)) log:@"entered level:2 state"];
        [verifyCount(logMock, times(1)) log:@"entered level:3 state"];
        [verifyCount(logMock, times(1)) log:@"entered level:4 state"];
        [verifyCount(logMock, times(1)) log:@"entered root state"];
        [verifyCount(logMock, times(1)) log:@"entered altLevel:1 state"];
        [verifyCount(logMock, times(1)) log:@"entered altLevel:2 state"];
        [verifyCount(logMock, times(1)) log:@"entered altLevel:3 state"];
        [verifyCount(logMock, times(1)) log:@"entered altLevel:4 state"];
    });

    it(@"it can handle long infinite loop state-transitions", ^{
        NSDictionary *chart = @{@"bad_root":@{},
                                @"root":@{
                                        @"enterState":^(SKStateChart *sc) {
                                            [logMock log:@"entered root state"];
                                        },
                                        @"startInfiniteLoop":^(SKStateChart *sc){
                                            [sc goToState:@"level:1"];
                                        },
                                        @"subStates":@{
                                                @"altLevel:1":@{
                                                        @"enterState":^(SKStateChart *sc) {
                                                            [logMock log:@"entered altLevel:1 state"];
                                                            [sc goToState:@"altLevel:2"];
                                                        },
                                                        @"subStates":@{
                                                                @"altLevel:2":@{
                                                                        @"enterState":^(SKStateChart *sc) {
                                                                            [logMock log:@"entered altLevel:2 state"];
                                                                            [sc goToState:@"altLevel:3"];
                                                                        },
                                                                        @"subStates":@{
                                                                                @"altLevel:3":@{
                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                            [logMock log:@"entered altLevel:3 state"];
                                                                                            [sc goToState:@"level:4"];
                                                                                        },
                                                                                        @"subStates":@{
                                                                                                @"altLevel:4":@{
                                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                                            [logMock log:@"entered altLevel:4 state"];
                                                                                                            [sc goToState:@"altLevel:2"];
                                                                                                        }
                                                                                                        }
                                                                                                }
                                                                                        }
                                                                                }
                                                                        }
                                                                }
                                                        },
                                                @"level:1":@{
                                                        @"enterState":^(SKStateChart *sc) {
                                                            [logMock log:@"entered level:1 state"];
                                                            [sc goToState:@"level:2"];
                                                        },
                                                        @"subStates":@{
                                                                @"level:2":@{
                                                                        @"enterState":^(SKStateChart *sc) {
                                                                            [logMock log:@"entered level:2 state"];
                                                                            [sc goToState:@"level:3"];
                                                                        },
                                                                        @"subStates":@{
                                                                                @"level:3":@{
                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                            [logMock log:@"entered level:3 state"];
                                                                                            [sc goToState:@"level:4"];
                                                                                        },
                                                                                        @"subStates":@{
                                                                                                @"level:4":@{
                                                                                                        @"enterState":^(SKStateChart *sc) {
                                                                                                            [logMock log:@"entered level:4 state"];
                                                                                                            [sc goToState:@"altLevel:1"];
                                                                                                        }
                                                                                                        }
                                                                                                }
                                                                                        }
                                                                                }
                                                                        }
                                                                }
                                                        }
                                                }
                                        }
                                };

        logMock = mock([MockLogger class]);
        stateChart = [[SKStateChart alloc] initWithStateChart:chart];
        expect(stateChart.currentState.name).to.equal(@"root");
        [verifyCount(logMock, times(1)) log:@"entered root state"];

        @try {
            [stateChart sendMessage:@"startInfiniteLoop"];
        }
        @catch (NSException *exception) {
            expect(exception.description).to.equal(@"Your stackCount (aka state transitions has reached the max threshold - you may have an infiinite loop in your state tree");
        }
    });

});

SpecEnd
