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

SpecBegin(StateChart_State_Traversal)

describe(@"SKStateMachine", ^{

    __block SKStateChart *stateChart;
    __block id apiMock;
    __block id viewMock;

    NSDictionary *chart = @{@"root":
                                @{@"enterState":^(SKStateChart *sc) {
                                    [sc goToState:@"loading"];
                                },
                                  @"refreshData":^(SKStateChart *sc) {
                                      // fetch new data from api
                                  },
                                  @"apiFailed":^(SKStateChart *sc) {
                                      //
                                  },
                                  @"subStates":@{
                                          @"loading": @{
                                                  @"enterState":^(SKStateChart *sc) {
                                                      [viewMock showLoadingScreen];
                                                      [apiMock fetchData];
                                                  },
                                                  @"apiSuccess":^(SKStateChart *sc) {
                                                      [sc goToState:@"pageVisible"];
                                                  }},
                                          @"pageVisible": @{
                                                  @"enterState":^(SKStateChart *sc) {
                                                      // tell view to grab newly available data
                                                  },
                                                  @"userPressedShowMapButton":^(SKStateChart *sc) {
                                                      [sc goToState:@"map"];
                                                  },
                                                  @"subStates":@{
                                                          @"map":@{
                                                                  @"enterState":^(SKStateChart *sc) {
                                                                      // tell view to setup map
                                                                  },
                                                                  @"exitState":^(SKStateChart *sc) {
                                                                      // dealloc the map when exiting the map state
                                                                  },
                                                                  @"apiFailed":^(SKStateChart *sc) {
                                                                      [sc goToState:@"mapErrorView"];
                                                                  },
                                                                  @"userPressedListViewButton":^(SKStateChart *sc) {
                                                                      [sc goToState:@"pageVisible"];
                                                                  },
                                                                  @"subStates":@{
                                                                          @"mapErrorView":@{
                                                                                  @"enterState":^(SKStateChart *sc) {
                                                                                      // tell the map to show the *map* error view
                                                                                  }}
                                                                          }
                                                                  },
                                                          @"errorView":@{
                                                                  @"enterState":^(SKStateChart *sc) {
                                                                      // tell view to show the error view
                                                                  }}
                                                          },
                                                  }
                                          }
                                  }
                            };

    beforeEach(^{
        apiMock = mock([MockAPI class]);
        viewMock = mock([MockView class]);
        stateChart = [[SKStateChart alloc] initWithStateChart:chart];
    });

    it(@"can be instantiated", ^{
        expect(stateChart).to.beTruthy();
    });

    it(@"per the stateChart the first state is loading", ^{
        expect(stateChart.currentState.name).to.equal(@"loading");
    });

    it(@"sending the event refreshData will call the api and transition to the loading state", ^{
//        OCMVerify([[viewMock expect] showLoadingScreen]);
//
//        OCMStub([apiMock fetchData]).andDo(^(NSInvocation *invocation) {
//            [stateChart sendMessage:@"apiSuccess"];
//            expect(stateChart.currentState.name).to.equal(@"pageVisible");
//        });
    });

});

SpecEnd
