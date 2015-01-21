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
    
});

SpecEnd
