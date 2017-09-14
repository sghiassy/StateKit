//
//  ExampleStateCharts_Tests.m
//  StateKit
//
//  Created by Shaheen Ghiassy on 1/23/15.
//  Copyright (c) 2015 Shaheen Ghiassy. All rights reserved.
//

#import "SKStateChart.h"


#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "MockLogger.h"

SpecBegin(StateChart_Examples)

describe(@"These are just exmaple state charts - not really tests", ^{

    it(@"", ^{

        NSDictionary *chart = @{@"root":@{
                                        @"subStates":@{
                                                @"map":@{
                                                        @"enterState":^(SKStateChart *sc) {
                                                            // allocate map here
                                                        },
                                                        @"subStates":@{
                                                                // now any depth of breadth of states from
                                                                // here on out by definition now the map
                                                                // has already been created.
                                                                // You couldn't have gotten to that state
                                                                // without the map having already been created
                                                                }}}}};

        [chart class];

    });

});

SpecEnd

