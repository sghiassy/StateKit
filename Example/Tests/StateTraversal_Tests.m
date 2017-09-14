//
//  StateTraversal_Tests.m
//  StateKit
//
//  Created by Shaheen Ghiassy on 1/21/15.
//  Copyright (c) 2015 Shaheen Ghiassy. All rights reserved.
//

#import "SKStateChart.h"

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
                                    [logMock log:@"entered root state"];
                                    [sc goToState:@"loading"];
                                  },
                                  @"apiFailed":^(SKStateChart *sc) {
                                      [logMock log:@"apiFailed"];
                                      [sc goToState:@"errorView"];
                                  },
                                  @"apiSuccess":^(SKStateChart *sc) {
                                      [sc goToState:@"pageVisible"];
                                  },
                                  @"userPressedCloseAppButton":^(SKStateChart *sc) {
                                      [sc goToState:@"closed"];
                                  },
                                  @"subStates":@{
                                          @"closed":@{
                                                  @"enterState":^(SKStateChart *sc) {
                                                      [logMock log:@"entered closed state"];
                                                  }},
                                          @"loading":@{
                                                  @"enterState":^(SKStateChart *sc) {
                                                      [logMock log:@"entered loading state"];
                                                      [viewMock showLoadingScreen];
                                                      [apiMock fetchData];
                                                  }},
                                          @"pageVisible":@{
                                                  @"enterState":^(SKStateChart *sc) {
                                                      [logMock log:@"entered pageVisible state"];
                                                      [viewMock showPage];
                                                  },
                                                  @"exitState":^(SKStateChart *sc) {
                                                      [logMock log:@"exited pageVisible state"];
                                                  },
                                                  @"userPressedShowMapButton":^(SKStateChart *sc) {
                                                      [sc goToState:@"map"];
                                                  },
                                                  @"subStates":@{
                                                          @"map":@{
                                                                  @"enterState":^{
                                                                      [logMock log:@"entered map state"];
                                                                  },
                                                                  @"exitState":^(SKStateChart *sc) {
                                                                      [logMock log:@"exited map state"];
                                                                  },
                                                                  @"apiFailed":^(SKStateChart *sc) {
                                                                      [logMock log:@"apiFailed-in-map-state"];
                                                                      [sc goToState:@"mapErrorView"];
                                                                  },
                                                                  @"userPressedListViewButton":^(SKStateChart *sc) {
                                                                      [sc goToState:@"pageVisible"];
                                                                  },
                                                                  @"subStates":@{
                                                                          @"mapErrorView":@{
                                                                                  @"enterState":^(SKStateChart *sc){
                                                                                      [logMock log:@"entered mapErrorView state"];
                                                                                  },
                                                                                  @"exitState":^(SKStateChart *sc) {
                                                                                      [logMock log:@"exited mapErrorView state"];
                                                                                  }},
                                                                          }
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

    describe(@"Enter State Traversals", ^{

        it(@"as you traverse down into substates, the enter method called on all states it enters into", ^{
            [verifyCount(logMock, times(1)) log:@"entered root state"];
            [verifyCount(logMock, times(1)) log:@"entered loading state"];
            [verifyCount(logMock, times(0)) log:@"entered pageVisible state"];
            [verifyCount(logMock, times(0)) log:@"entered map state"];
            [verifyCount(logMock, times(0)) log:@"entered mapErrorView state"];
            [verifyCount(logMock, times(0)) log:@"entered closed state"];

            [stateChart sendMessage:@"apiSuccess"];

            [verifyCount(logMock, times(1)) log:@"entered root state"];
            [verifyCount(logMock, times(1)) log:@"entered loading state"];
            [verifyCount(logMock, times(1)) log:@"entered pageVisible state"];
            [verifyCount(logMock, times(0)) log:@"entered map state"];
            [verifyCount(logMock, times(0)) log:@"entered mapErrorView state"];
            [verifyCount(logMock, times(0)) log:@"entered closed state"];

            [stateChart sendMessage:@"userPressedShowMapButton"];

            [verifyCount(logMock, times(1)) log:@"entered root state"];
            [verifyCount(logMock, times(1)) log:@"entered loading state"];
            [verifyCount(logMock, times(1)) log:@"entered pageVisible state"];
            [verifyCount(logMock, times(1)) log:@"entered map state"];
            [verifyCount(logMock, times(0)) log:@"entered mapErrorView state"];
            [verifyCount(logMock, times(0)) log:@"entered closed state"];

            [stateChart sendMessage:@"apiFailed"];

            [verifyCount(logMock, times(1)) log:@"entered root state"];
            [verifyCount(logMock, times(1)) log:@"entered loading state"];
            [verifyCount(logMock, times(1)) log:@"entered pageVisible state"];
            [verifyCount(logMock, times(1)) log:@"entered map state"];
            [verifyCount(logMock, times(1)) log:@"entered mapErrorView state"];
            [verifyCount(logMock, times(0)) log:@"entered closed state"];
        });
    });

    describe(@"Exit State Traversals", ^{

        beforeEach(^{
            // Get the statechart into the mapErrorViewState
            [stateChart sendMessage:@"apiSuccess"];
            [stateChart sendMessage:@"userPressedShowMapButton"];
            [stateChart sendMessage:@"apiFailed"];
        });

        it(@"is in the map error view state", ^{
            expect(stateChart.currentState.name).to.equal(@"mapErrorView");
        });

        it(@"with a state change that traverses up the tree, all the exitState methods will be called", ^{
            [verifyCount(logMock, times(0)) log:@"exited mapErrorView state"];
            [verifyCount(logMock, times(0)) log:@"exited map state"];
            [verifyCount(logMock, times(0)) log:@"exited pageVisible state"];
            [verifyCount(logMock, times(0)) log:@"entered closed state"];

            [stateChart sendMessage:@"userPressedCloseAppButton"];

            [verifyCount(logMock, times(1)) log:@"exited mapErrorView state"];
            [verifyCount(logMock, times(1)) log:@"exited map state"];
            [verifyCount(logMock, times(1)) log:@"exited pageVisible state"];
            [verifyCount(logMock, times(1)) log:@"entered closed state"];
        });
    });
});

SpecEnd
