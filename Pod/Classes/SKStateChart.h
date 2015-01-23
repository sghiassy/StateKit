//
//  SKStateChart.h
//  Pods
//
//  Created by Shaheen Ghiassy on 1/19/15.
//
//

#import <Foundation/Foundation.h>
#import "SKState.h" // Including definition in public header to keep user's import definitions cleaner

@interface SKStateChart : NSObject

- (SKState *)currentState;

- (instancetype)initWithStateChart:(NSDictionary *)stateChart;

- (void)goToState:(NSString *)goToState;

- (void)sendMessage:(NSString *)message;

@end
