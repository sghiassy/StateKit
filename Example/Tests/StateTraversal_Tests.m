//
//  StateTraversal_Tests.m
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

#import "MockAPI.h"
#import "MockView.h"
#import "MockLogger.h"

SpecBegin(StateChart_State_Traversal)

describe(@"SKStateMachine", ^{

    __block SKStateChart *stateChart;
    __block id apiMock;
    __block id viewMock;
    __block id logMock;

    NSDictionary *chart = @{@"root":
                                @{@"enterState":^(SKStateChart *sc) {
                                    [sc goToState:@"loading"];
                                  },
                                  @"apiFailed":^(SKStateChart *sc) {
                                      [logMock log:@"apiFailed"];
                                      [sc goToState:@"errorView"];
                                  },
                                  @"apiSuccess":^(SKStateChart *sc) {
                                      [sc goToState:@"pageVisible"];
                                  },
                                  @"subStates":@{
                                          @"loading": @{
                                                  @"enterState":^(SKStateChart *sc) {
                                                      [viewMock showLoadingScreen];
                                                      [apiMock fetchData];
                                                  }},
                                          @"pageVisible": @{
                                                  @"enterState":^(SKStateChart *sc) {
                                                      [viewMock showPage];
                                                  },
                                                  @"userPressedShowMapButton":^(SKStateChart *sc) {
                                                      [sc goToState:@"map"];
                                                  },
                                                  @"subStates":@{
                                                          @"map":@{
                                                                  @"apiFailed":^(SKStateChart *sc) {
                                                                      [logMock log:@"apiFailed-in-map-state"];
                                                                      [sc goToState:@"mapErrorView"];
                                                                  },
                                                                  @"userPressedListViewButton":^(SKStateChart *sc) {
                                                                      [sc goToState:@"pageVisible"];
                                                                  },
                                                                  @"subStates":@{@"mapErrorView":@{}}
                                                                  },
                                                          @"errorView":@{},
                                                  }
                                          }
                                  }
                                  }};

    beforeEach(^{
        logMock = mock([MockLogger class]);
        apiMock = mock([MockAPI class]);
        viewMock = mock([MockView class]);
        stateChart = [[SKStateChart alloc] initWithStateChart:chart];
    });

    it(@"can be instantiated", ^{
        expect(stateChart).to.beTruthy();
    });

    it(@"per the stateChart the first state is loading", ^{
        expect(stateChart.currentState.name).to.equal(@"loading");
        [verifyCount(viewMock, times(1)) showLoadingScreen];
        [verifyCount(viewMock, times(0)) showPage];
        [verifyCount(apiMock, times(1)) fetchData];
    });

    it(@"sending the event apiSuccess will transition the state chart to the pageVisible state", ^{
        expect(stateChart.currentState.name).to.equal(@"loading");

        // Now send the message that the API succeeded
        [stateChart sendMessage:@"apiSuccess"];
        expect(stateChart.currentState.name).to.equal(@"pageVisible");
        [verifyCount(viewMock, times(1)) showPage];
    });

    it(@"the stateChart will transition to the map state when the user pressed the map view button", ^{
        expect(stateChart.currentState.name).to.equal(@"loading");

        // If we send a message to the state chart where the state is not in, the message is ignored
        [stateChart sendMessage:@"userPressedShowMapButton"];
        expect(stateChart.currentState.name).to.equal(@"loading"); // Nothing changed

        // So we have to get the state chart into the right state for the user to be able to press the map button
        [stateChart sendMessage:@"apiSuccess"];
        expect(stateChart.currentState.name).to.equal(@"pageVisible");
        [verifyCount(viewMock, times(1)) showPage];

        [stateChart sendMessage:@"userPressedShowMapButton"];
        expect(stateChart.currentState.name).to.equal(@"map");
    });

    describe(@"Map State", ^{

        beforeEach(^{
            [stateChart sendMessage:@"apiSuccess"];
            [stateChart sendMessage:@"userPressedShowMapButton"];
            expect(stateChart.currentState.name).to.equal(@"map");
        });

        it(@"sending the message apiFailed moves to mapErrorView", ^{
            [stateChart sendMessage:@"apiFailed"];
            expect(stateChart.currentState.name).to.equal(@"mapErrorView");
        });

        it(@"sending the message apiFailed moves calls the sub method and NOT the top-level message", ^{
            [verifyCount(logMock, times(0)) log:@"apiFailed"];
            [verifyCount(logMock, times(0)) log:@"apiFailed-in-map-state"];
            [stateChart sendMessage:@"apiFailed"];

            expect(stateChart.currentState.name).to.equal(@"mapErrorView");
            [verifyCount(logMock, times(0)) log:@"apiFailed"];
            [verifyCount(logMock, times(1)) log:@"apiFailed-in-map-state"];
        });
    });
});

SpecEnd
