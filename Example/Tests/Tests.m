//
//  StateKitTests.m
//  StateKitTests
//
//  Created by Shaheen Ghiassy on 01/19/2015.
//  Copyright (c) 2014 Shaheen Ghiassy. All rights reserved.
//

#import <SKStateChart.h>
#import <OCMock.h>

SpecBegin(InitialSpecs)

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

describe(@"these will pass", ^{
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
    
    it(@"will wait and succeed", ^AsyncBlock {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            done();
        });
    });
});

SpecEnd
