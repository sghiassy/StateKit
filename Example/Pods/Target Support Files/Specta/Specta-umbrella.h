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

#import "Specta.h"
#import "SpectaSupport.h"
#import "SpectaTypes.h"
#import "SpectaUtility.h"
#import "SPTExample.h"
#import "SPTExampleGroup.h"
#import "SPTNestedReporter.h"
#import "SPTReporter.h"
#import "SPTSharedExampleGroups.h"
#import "SPTSpec.h"
#import "SPTXCTestCase.h"
#import "SPTXCTestReporter.h"
#import "XCTestCase+Specta.h"
#import "XCTestLog+Specta.h"
#import "XCTestRun+Specta.h"

FOUNDATION_EXPORT double SpectaVersionNumber;
FOUNDATION_EXPORT const unsigned char SpectaVersionString[];

