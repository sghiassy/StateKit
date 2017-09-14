//
//  StateEvents_Tests.m
//  StateKit
//
//  Created by Shaheen Ghiassy on 1/21/15.
//  Copyright (c) 2015 Shaheen Ghiassy. All rights reserved.
//

#import "SKStateChart.h"
#import "MockLogger.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>


SpecBegin(StateChart_State_Events)

describe(@"SKStateMachine", ^{

    __block SKStateChart *stateChart;
    __block id logMock;

    NSDictionary *chart = @{@"root":@{
                                    @"enterState":^(SKStateChart *sc) {
                                        [logMock log:@"entered root state"];
                                    }}};

    beforeEach(^{
        logMock = mock([MockLogger class]);
        stateChart = [[SKStateChart alloc] initWithStateChart:chart];
    });

    it(@"can be instantiated", ^{
        expect(stateChart).to.beTruthy();
    });

    it(@"the enter state will be called on root on init", ^{
        [verifyCount(logMock, times(1)) log:@"entered root state"];
    });

    it(@"if you misspell the enterState, it will obviously not be called", ^{
        logMock = mock([MockLogger class]);
        NSDictionary *chart = @{@"root":@{
                                        @"enterStatez":^(SKStateChart *sc) {
                                            [logMock log:@"entered root state"];
                                            }
                                        }
                                };

        __unused SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:chart];

        // verification the addObject method was never called
        [verifyCount(logMock, times(0)) log:@"entered root state"];
    });
    
});

SpecEnd
