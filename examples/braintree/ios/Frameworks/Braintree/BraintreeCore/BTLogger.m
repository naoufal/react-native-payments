#import <Foundation/Foundation.h>

#import "BTLogger_Internal.h"

#define variadicLogLevel(level, format) \
    va_list args; \
    va_start(args, format); \
    [self logLevel:level format:format arguments:args]; \
    va_end(args);


@implementation BTLogger

+ (instancetype)sharedLogger {
    static BTLogger *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });

    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _level = BTLogLevelInfo;
    }
    return self;
}

- (void)log:(NSString *)format, ... {
    variadicLogLevel(BTLogLevelInfo, format)
}

- (void)critical:(NSString *)format, ... {
    variadicLogLevel(BTLogLevelCritical, format)
}

- (void)error:(NSString *)format, ... {
    variadicLogLevel(BTLogLevelError, format)
}

- (void)warning:(NSString *)format, ... {
    variadicLogLevel(BTLogLevelWarning, format)
}

- (void)info:(NSString *)format, ... {
    variadicLogLevel(BTLogLevelInfo, format)
}

- (void)debug:(NSString *)format, ... {
    variadicLogLevel(BTLogLevelDebug, format)
}

- (void)logLevel:(BTLogLevel)level format:(NSString *)format arguments:(va_list)arguments {
    if (level <= self.level) {
        NSString *message = [[NSString alloc] initWithFormat:format arguments:arguments];
        if (self.logBlock) {
            self.logBlock(level, message);
        } else {
            NSString *levelString = [[self class] levelString:level];
            NSLog(@"[BraintreeSDK] %@ %@", [levelString uppercaseString], message);
        }
    }
}

+ (NSString *)levelString:(BTLogLevel)level {
    switch (level) {
        case BTLogLevelCritical:
            return @"Critical";
        case BTLogLevelError:
            return @"Error";
        case BTLogLevelWarning:
            return @"Warning";
        case BTLogLevelInfo:
            return @"Info";
        case BTLogLevelDebug:
            return @"Debug";
        default:
            return nil;
    }
}

@end
