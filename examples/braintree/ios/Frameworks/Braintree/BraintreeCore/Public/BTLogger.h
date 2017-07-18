#import <Foundation/Foundation.h>

/*!
 @brief Braintree SDK Logging Levels
*/
typedef NS_ENUM(NSUInteger, BTLogLevel) {

    /// Suppress all log output
    BTLogLevelNone     = 0,

    /// Only log critical issues (e.g. irrecoverable errors)
    BTLogLevelCritical = 1,

    /// Log errors (e.g. expected or recoverable errors)
    BTLogLevelError    = 2,

    /// Log warnings (e.g. use of pre-release features)
    BTLogLevelWarning  = 3,

    /// Log basic information (e.g. state changes, network activity)
    BTLogLevelInfo     = 4,

    /// Log debugging statements (anything and everything)
    BTLogLevelDebug    = 5
};

/*!
 @brief Braintree leveled logger
 */
@interface BTLogger : NSObject

/*!
 @brief The logger singleton used by the Braintree SDK
*/
+ (instancetype)sharedLogger;

/*!
 @brief The current log level, with default value BTLogLevelInfo
*/
@property (nonatomic, assign) BTLogLevel level;

@end
