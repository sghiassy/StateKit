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

#import "OCHamcrest.h"
#import "HCAssertThat.h"
#import "HCBaseDescription.h"
#import "HCBaseMatcher.h"
#import "HCDescription.h"
#import "HCDiagnosingMatcher.h"
#import "HCMatcher.h"
#import "HCSelfDescribing.h"
#import "HCStringDescription.h"
#import "HCCollect.h"
#import "HCInvocationMatcher.h"
#import "HCRequireNonNilObject.h"
#import "HCWrapInMatcher.h"
#import "HCTestFailure.h"
#import "HCTestFailureReporter.h"
#import "HCTestFailureReporterChain.h"
#import "HCEvery.h"
#import "HCHasCount.h"
#import "HCIsCollectionContaining.h"
#import "HCIsCollectionContainingInAnyOrder.h"
#import "HCIsCollectionContainingInOrder.h"
#import "HCIsCollectionContainingInRelativeOrder.h"
#import "HCIsCollectionOnlyContaining.h"
#import "HCIsDictionaryContaining.h"
#import "HCIsDictionaryContainingEntries.h"
#import "HCIsDictionaryContainingKey.h"
#import "HCIsDictionaryContainingValue.h"
#import "HCIsEmptyCollection.h"
#import "HCIsIn.h"
#import "HCDescribedAs.h"
#import "HCIs.h"
#import "HCAllOf.h"
#import "HCAnyOf.h"
#import "HCIsAnything.h"
#import "HCIsNot.h"
#import "HCIsCloseTo.h"
#import "HCIsEqualToNumber.h"
#import "HCIsTrueFalse.h"
#import "HCNumberAssert.h"
#import "HCOrderingComparison.h"
#import "HCArgumentCaptor.h"
#import "HCClassMatcher.h"
#import "HCConformsToProtocol.h"
#import "HCHasDescription.h"
#import "HCHasProperty.h"
#import "HCIsEqual.h"
#import "HCIsInstanceOf.h"
#import "HCIsNil.h"
#import "HCIsSame.h"
#import "HCIsTypeOf.h"
#import "HCThrowsException.h"
#import "HCIsEqualCompressingWhiteSpace.h"
#import "HCIsEqualIgnoringCase.h"
#import "HCStringContains.h"
#import "HCStringContainsInOrder.h"
#import "HCStringEndsWith.h"
#import "HCStringStartsWith.h"
#import "HCSubstringMatcher.h"

FOUNDATION_EXPORT double OCHamcrestVersionNumber;
FOUNDATION_EXPORT const unsigned char OCHamcrestVersionString[];

