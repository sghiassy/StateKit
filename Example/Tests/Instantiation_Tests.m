//
//  StateKitTests.m
//  StateKitTests
//
//  Created by Shaheen Ghiassy on 01/19/2015.
//  Copyright (c) 2014 Shaheen Ghiassy. All rights reserved.
//

#import <SKStateChart.h>

SpecBegin(StateChart_Instantiation)

describe(@"SKStateMachine", ^{

    it(@"can be instantiated on its own", ^{
        SKStateChart *stateChart = [[SKStateChart alloc] init];
        expect(stateChart).to.beTruthy();
    });

    it(@"can be instantiated with a dictionary representing a state chart", ^{
        SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:@{@"root":@{}}];
        expect(stateChart).toNot.beNil();
    });

    it(@"when instantiating with an initial dictionary there must be a root state, otherwise throw an exception", ^{
        SKStateChart *stateChart;
        @try {
            stateChart = [[SKStateChart alloc] initWithStateChart:@{}];
        }
        @catch (NSException *exception) {
            expect(exception).to.beTruthy();
        }
    });

});

SpecEnd
