#import "BTLogger_Internal.h"

SpecBegin(BTLogger)

describe(@"sharedLogger", ^{
    it(@"returns the singleton logger", ^{
        BTLogger *logger1 = [BTLogger sharedLogger];
        BTLogger *logger2 = [BTLogger sharedLogger];
        expect(logger1).to.beKindOf([BTLogger class]);
        expect(logger1).to.equal(logger2);
    });
});

SpecEnd

SpecBegin(BTLogger_Internal)

describe(@"logger", ^{

    __block BTLogger *logger;

    beforeEach(^{
        logger = [[BTLogger alloc] init];
    });

    describe(@"log", ^{
        it(@"sends log message to NSLog", ^{
            [logger log:@"BTLogger probably works!"];
            // Can't mock NSLog
        });

        it(@"sends log message to logBlock if defined", ^{
            waitUntil(^(DoneCallback done) {
                NSString *messageLogged = @"BTLogger logBlock works!";
                logger.logBlock = ^(BTLogLevel level, NSString *messageReceived) {
                    expect(level).to.equal(BTLogLevelInfo);
                    expect(messageReceived).to.equal(messageLogged);
                    done();
                };
                [logger log:messageLogged];
            });
        });
    });

    describe(@"level", ^{
        it(@"defaults to 'info'", ^{
            expect(logger.level).to.equal(BTLogLevelInfo);
        });

        it(@"allows logging if logged at or below level", ^{

            for (int level = BTLogLevelNone; level <= BTLogLevelDebug; level++) {
                NSString *message = [NSString stringWithFormat:@"test %d", level];
                NSMutableArray *messagesLogged = [NSMutableArray array];
                __block BTLogLevel maxLevel = level;
                waitUntil(^(DoneCallback done) {
                    logger.logBlock = ^(BTLogLevel actualLevel, NSString *messageReceived) {
                        expect(actualLevel).to.beLessThanOrEqualTo(maxLevel);
                        [messagesLogged addObject:messageReceived];
                    };

                    logger.level = level;
                    [logger critical:message];
                    [logger error:message];
                    [logger warning:message];
                    [logger info:message];
                    [logger debug:message];
                    done();
                });
                expect(messagesLogged.count).to.equal(level);
            }
        });
        
    });
    
});

SpecEnd
