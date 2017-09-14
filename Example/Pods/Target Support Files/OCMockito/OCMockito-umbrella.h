#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MKTNonObjectArgumentMatching.h"
#import "OCMockito.h"
#import "NSInvocation+OCMockito.h"
#import "MKTBaseMockObject.h"
#import "MKTClassObjectMock.h"
#import "MKTObjectAndProtocolMock.h"
#import "MKTObjectMock.h"
#import "MKTProtocolMock.h"
#import "MKTOngoingStubbing.h"

FOUNDATION_EXPORT double OCMockitoVersionNumber;
FOUNDATION_EXPORT const unsigned char OCMockitoVersionString[];

