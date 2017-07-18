#import <XCTest/XCTest.h>
#import "BTLogger_Internal.h"

@interface BTLogger_Internal_Tests : XCTestCase
@end

@implementation BTLogger_Internal_Tests

- (void)testSharedLogger_returnsSingletonLogger {
    BTLogger *logger1 = [BTLogger sharedLogger];
    BTLogger *logger2 = [BTLogger sharedLogger];
    XCTAssertTrue(logger1 == logger2);
    XCTAssertTrue([logger1 isKindOfClass:[BTLogger class]]);
}

- (void)testLevel_byDefault_isInfo {
    XCTAssertEqual([[BTLogger alloc] init].level, BTLogLevelInfo);
}

- (void)testLog_whenLogBlockIsDefined_invokesBlockWithLogMessageAndLogLevel {
    BTLogger *logger = [[BTLogger alloc] init];
    NSString *messageLogged = @"BTLogger logBlock works!";
    XCTestExpectation *expectation = [self expectationWithDescription:@"logBlock invoked"];
    logger.logBlock = ^(BTLogLevel level, NSString *messageReceived) {
        XCTAssertEqualObjects(messageReceived, messageLogged);
        XCTAssertEqual(level, BTLogLevelInfo);
        [expectation fulfill];
    };

    [logger log:messageLogged];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testLog_whenLoggingAtOrBelowLevel_logsMessage {
    BTLogger *logger = [[BTLogger alloc] init];
    for (BTLogLevel level = BTLogLevelNone; level <= BTLogLevelDebug; level++) {
        NSString *message = [NSString stringWithFormat:@"test %lu", (unsigned long)level];
        NSMutableArray *messagesLogged = [NSMutableArray array];
        __block BTLogLevel maxLevel = level;
        logger.logBlock = ^(BTLogLevel actualLevel, NSString *messageReceived) {
            XCTAssertTrue(actualLevel <= maxLevel);
            [messagesLogged addObject:messageReceived];
        };

        logger.level = level;
        [logger critical:message];
        [logger error:message];
        [logger warning:message];
        [logger info:message];
        [logger debug:message];

        XCTAssertEqual(messagesLogged.count, level);
    }
}

@end
