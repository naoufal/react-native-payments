#import <XCTest/XCTest.h>
#import "BraintreeCore.h"

@interface BTMacroTests : XCTestCase

@end

@implementation BTMacroTests

- (void)test__BT_AVAILABLE_returnsTrueForAvailableClass {
    XCTAssertTrue(__BT_AVAILABLE(@"BTAPIClient"));
}

- (void)test__BT_AVAILABLE_returnsFalseForUnavailableClass {
    XCTAssertFalse(__BT_AVAILABLE(@"BTNotARealClass"));
}

@end
