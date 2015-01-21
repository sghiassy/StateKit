//
//  Message_Tests.m
//  StateKit
//
//  Created by Shaheen Ghiassy on 1/21/15.
//  Copyright (c) 2015 Shaheen Ghiassy. All rights reserved.
//

#import <SKStateChart.h>
#import <OCMock.h>

SpecBegin(StateChart_Messages)

describe(@"SKStateMachine", ^{

    it(@"can be instantiated", ^{
        SKStateChart *stateChart = [[SKStateChart alloc] init];
        expect(stateChart).to.beTruthy();
    });

    it(@"The current state will respond to events", ^{
        __block NSString *mock = @"not called";

        NSDictionary *chart = @{@"root":@{
                                        @"waka_waka":^(SKStateChart *sc){
                                            mock = @"waka_waka was called";
                                        }
                                        }};

        SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:chart];

        expect(mock).to.equal(@"not called");

        [stateChart sendMessage:@"waka_waka"];

        expect(mock).to.equal(@"waka_waka was called");
    });

    it(@"Methods in the same state, will not respond", ^{
        __block NSString *waka = @"not called";
        __block NSString *yaka = @"not called";

        NSDictionary *chart = @{@"root":@{
                                        @"waka_waka":^(SKStateChart *sc){
                                            waka = @"waka_waka was called";
                                        },
                                        @"yaka_yaka":^(SKStateChart *sc) {
                                            yaka = @"yaka_yaka was called";
                                        }}};

        SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:chart];

        expect(waka).to.equal(@"not called");
        expect(yaka).to.equal(@"not called");

        [stateChart sendMessage:@"waka_waka"];

        expect(waka).to.equal(@"waka_waka was called");
        expect(yaka).to.equal(@"not called");
    });

    it(@"Messages in substates with the same name will not respond", ^{
        __block NSString *waka = @"not called";
        __block NSString *yaka = @"not called";

        NSDictionary *chart = @{@"root":@{
                                        @"waka_waka":^(SKStateChart *sc){
                                            // Enforce the fact that we are not overriding the substates value
                                            if ([waka isEqualToString:@"not called"]) {
                                                waka = @"waka_waka was called";
                                            }
                                        },
                                        @"yaka_yaka":^(SKStateChart *sc) {
                                            yaka = @"yaka_yaka was called";
                                        },
                                        @"subStates":@{
                                                @"rootChildState":@{
                                                        @"waka_waka":^(SKStateChart *sc) {
                                                            waka = @"waka_waka_sub_state was called";
                                                        }}
                                                }
                                        }
                                };

        SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:chart];

        expect(waka).to.equal(@"not called");
        expect(yaka).to.equal(@"not called");

        [stateChart sendMessage:@"waka_waka"];

        expect(waka).to.equal(@"waka_waka was called");
        expect(yaka).to.equal(@"not called");
    });
    
});

SpecEnd
