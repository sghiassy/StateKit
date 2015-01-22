//
//  SKStateChart.h
//  Pods
//
//  Created by Shaheen Ghiassy on 1/19/15.
//
//

#import <Foundation/Foundation.h>
@class SKState;

@interface SKStateChart : NSObject

@property (nonatomic, strong, readonly) SKState *currentState;

- (instancetype)initWithStateChart:(NSDictionary *)stateChart;

- (void)goToState:(NSString *)goToState;

- (void)sendMessage:(NSString *)message;

@end
