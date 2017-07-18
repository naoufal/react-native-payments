#import <UIKit/UIKit.h>

@interface BTUIUtil : NSObject

+ (BOOL)luhnValid:(NSString *)cardNumber;

/*!
 @brief Strips non-digit characters from a string.

 @param input The string to strip.

 @return The string stripped of non-digit characters, or `nil` if `input` is `nil`
*/
+ (NSString *)stripNonDigits:(NSString *)input;

+ (NSString *)stripNonExpiry:(NSString *)input;

@end
