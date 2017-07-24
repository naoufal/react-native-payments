#import <Foundation/Foundation.h>

#import "BTLogger.h"

@interface BTLogger ()

- (void)log:(NSString *)format, ...;
- (void)critical:(NSString *)format, ...;
- (void)error:(NSString *)format, ...;
- (void)warning:(NSString *)format, ...;
- (void)info:(NSString *)format, ...;
- (void)debug:(NSString *)format, ...;

/*!
 @brief Custom block for handling log messages
*/
@property (nonatomic, copy) void (^logBlock)(BTLogLevel level, NSString *message);

@end
