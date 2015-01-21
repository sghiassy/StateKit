//
//  StateTraversal_Tests.m
//  StateKit
//
//  Created by Shaheen Ghiassy on 1/21/15.
//  Copyright (c) 2015 Shaheen Ghiassy. All rights reserved.
//

#import <SKStateChart.h>
#import <OCMock.h>

SpecBegin(StateChart_State_Traversal)

describe(@"SKStateMachine", ^{

    it(@"can be instantiated", ^{
        SKStateChart *stateChart = [[SKStateChart alloc] init];
        expect(stateChart).to.beTruthy();
    });

    it(@"the default state is root", ^{
        SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:@{@"root":@{}}];
        expect(stateChart.currentStateName).to.equal(@"root");
    });
    
});

SpecEnd
