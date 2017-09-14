//  OCMockito by Jon Reid, https://qualitycoding.org/
//  Copyright 2017 Jonathan M. Reid. See LICENSE.txt

#import "MKTInvocationsChecker.h"

@class MKTInvocation;
@class MKTInvocationMatcher;


NS_ASSUME_NONNULL_BEGIN

@interface MKTAtLeastNumberOfInvocationsChecker : MKTInvocationsChecker

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithWantedDescription:(NSString *)wantedDescription NS_UNAVAILABLE;
- (nullable NSString *)checkInvocations:(NSArray<MKTInvocation *> *)invocations
                                 wanted:(MKTInvocationMatcher *)wanted
                            wantedCount:(NSUInteger)wantedCount;

@end

NS_ASSUME_NONNULL_END
