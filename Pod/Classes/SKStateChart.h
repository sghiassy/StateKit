//
//  SKStateChart.h
//  Pods
//
//  Created by Shaheen Ghiassy on 1/19/15.
//
//

#import <Foundation/Foundation.h>

@interface SKStateChart : NSObject

- (instancetype)initWithStateChart:(NSDictionary *)stateChart;

- (void)goToState:(NSString *)goToState;

- (void)sendMessage:(NSString *)message;

#pragma mark - Getters

/**
 *  Get the StateChart's current state
 *
 *  @return String representing current state
 */
- (NSString *)currentState;

@end


typedef void (^StateBlock)(void);
typedef void (^MessageBlock)(SKStateChart *sc);