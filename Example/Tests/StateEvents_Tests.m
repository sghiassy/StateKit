//
//  StateEvents_Tests.m
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


SpecBegin(StateChart_State_Events)

describe(@"SKStateMachine", ^{

    it(@"can be instantiated", ^{
        SKStateChart *stateChart = [[SKStateChart alloc] init];
        expect(stateChart).to.beTruthy();
    });

    it(@"the enter state will be called on root on init", ^{
        // mock creation
        NSMutableArray *mockArray = mock([NSMutableArray class]);

        NSDictionary *chart = @{@"root":@{
                                        @"enterState":^(SKStateChart *sc) {
                                            [mockArray addObject:@"one"];
                                        }}};

        SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:chart];

        // verify addObject method was called with parameter @"one"
        [verify(mockArray) addObject:@"one"];

        expect(stateChart).toNot.beNil();
    });

    it(@"if you misspell the enterState, it will obviously not be called", ^{
        // mock creation
        NSMutableArray *mockArray = mock([NSMutableArray class]);

        NSDictionary *chart = @{@"root":@{
                                        @"enterStatez":^(SKStateChart *sc) {
                                            [mockArray addObject:@"one"];
                                        }}};

        SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:chart];

        // verification the addObject method was never called
        [verifyCount(mockArray, never()) addObject:@"one"];

        expect(stateChart).toNot.beNil();
    });
    
});

SpecEnd
