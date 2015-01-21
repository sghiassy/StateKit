//
//  StateEvents_Tests.m
//  StateKit
//
//  Created by Shaheen Ghiassy on 1/21/15.
//  Copyright (c) 2015 Shaheen Ghiassy. All rights reserved.
//

#import <SKStateChart.h>
#import <OCMock.h>

SpecBegin(StateChart_State_Events)

describe(@"SKStateMachine", ^{

    it(@"can be instantiated", ^{
        SKStateChart *stateChart = [[SKStateChart alloc] init];
        expect(stateChart).to.beTruthy();
    });

    it(@"the enter state will be called on root on init", ^{
        id mock = OCMClassMock([NSString class]);

        NSDictionary *chart = @{@"root":@{
                                        @"enterState":^(SKStateChart *sc) {
                                            [mock uppercaseString];
                                        }}};

        SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:chart];

        OCMVerify([[mock expect] uppercaseString]);

        expect(stateChart).toNot.beNil();
    });

    it(@"if you misspell the enterState, it will obviously not be called", ^{
        id mock = OCMClassMock([NSString class]);

        [[mock reject] uppercaseString];

        NSDictionary *chart = @{@"root":@{
                                        @"enterSState":^(SKStateChart *sc) {
                                            [mock uppercaseString];
                                        }}};

        SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:chart];

        OCMVerify([[mock reject] uppercaseString]);
        
        expect(stateChart).toNot.beNil();
    });
    
});

SpecEnd
