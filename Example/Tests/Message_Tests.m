//
//  Message_Tests.m
//  StateKit
//
//  Created by Shaheen Ghiassy on 1/21/15.
//  Copyright (c) 2015 Shaheen Ghiassy. All rights reserved.
//

#import <SKStateChart.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "MockLogger.h"

SpecBegin(StateChart_Messages)

describe(@"SKStateMachine", ^{

    __block SKStateChart *stateChart;
    __block id logMock;

    NSDictionary *chart = @{@"root":@{
                                    @"waka_waka":^(SKStateChart *sc){
                                        [logMock log:@"waka_waka was called"];
                                    },
                                    @"yaka_yaka":^(SKStateChart *sc) {
                                        [logMock log:@"yaka_yaka was called"];
                                    },
                                    @"subStates":@{
                                            @"rootChildState":@{
                                                    @"waka_waka":^(SKStateChart *sc) {
                                                        [logMock log:@"waka_waka_sub_state was called"];
                                                    }}
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

    it(@"The current state will respond to events", ^{
        [verifyCount(logMock, times(0)) log:@"waka_waka was called"];

        [stateChart sendMessage:@"waka_waka"];

        [verifyCount(logMock, times(1)) log:@"waka_waka was called"];
    });

    it(@"Methods in the same state, will not respond", ^{
        [verifyCount(logMock, times(0)) log:@"waka_waka was called"];
        [verifyCount(logMock, times(0)) log:@"yaka_yaka was called"];

        [stateChart sendMessage:@"waka_waka"];

        [verifyCount(logMock, times(1)) log:@"waka_waka was called"];
        [verifyCount(logMock, times(0)) log:@"yaka_yaka was called"];
    });

    it(@"Messages in substates with the same name will not respond", ^{
        [verifyCount(logMock, times(0)) log:@"waka_waka was called"];
        [verifyCount(logMock, times(0)) log:@"yaka_yaka was called"];
        [verifyCount(logMock, times(0)) log:@"waka_waka_sub_state was called"];

        [stateChart sendMessage:@"waka_waka"];

        [verifyCount(logMock, times(1)) log:@"waka_waka was called"];
        [verifyCount(logMock, times(0)) log:@"yaka_yaka was called"];
        [verifyCount(logMock, times(0)) log:@"waka_waka_sub_state was called"];
    });
    
});

SpecEnd
