//
//  PPOTMacros.h
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PPSDKLog(format, args...) NSLog(@"%@", [NSString stringWithFormat:@"PayPal OneTouchCoreSDK: %@", [NSString stringWithFormat:format, ## args]])

// PPLog is a replacement for NSLog that logs iff DEBUG is set.
#if DEBUG
#define PPLog(format, args...) NSLog(format, ## args)
#else
#define PPLog(format, args...)
#endif

// PPAssert* are replacements for NSAssert, NSAssert1, etc.
// Whether the latter are enabled or disabled depends upon NS_BLOCK_ASSERTIONS;
// we set NS_BLOCK_ASSERTIONS inside our .pch files based upon DEBUG.
// Those #defines are a little bit fragile, and could easily accidentally get broken in the future.
// So PPAssert* depend explicitly on DEBUG, just to be a bit more safe.
#if DEBUG
  #define PPAssert(condition, desc...) NSAssert(condition, desc)
  #define PPAssert1(condition, desc, arg1) NSAssert1(condition, desc, arg1)
  #define PPAssert2(condition, desc, arg1, arg2) NSAssert2(condition, desc, arg1, arg2)
  #define PPAssert3(condition, desc, arg1, arg2, arg3) NSAssert3(condition, desc, arg1, arg2, arg3)
  #define PPAssert4(condition, desc, arg1, arg2, arg3, arg4) NSAssert4(condition, desc, arg1, arg2, arg3, arg4)
  #define PPAssert5(condition, desc, arg1, arg2, arg3, arg4, arg5) NSAssert5(condition, desc, arg1, arg2, arg3, arg4, arg5)
  #define PPParameterAssert(condition) NSParameterAssert(condition)
#else
  #define PPAssert(condition, desc, ...)
  #define PPAssert1(condition, desc, arg1)
  #define PPAssert2(condition, desc, arg1, arg2)
  #define PPAssert3(condition, desc, arg1, arg2, arg3)
  #define PPAssert4(condition, desc, arg1, arg2, arg3, arg4)
  #define PPAssert5(condition, desc, arg1, arg2, arg3, arg4, arg5)
  #define PPParameterAssert(condition)
#endif

@interface PPOTMacros : NSObject

/*!
 @return the iOS major version number
*/
+ (NSUInteger)deviceSystemMajorVersion;

@end

#define iOS_MAJOR_VERSION  [PPOTMacros deviceSystemMajorVersion]
#define iOS_9_PLUS         ([PPOTMacros deviceSystemMajorVersion] >= 9)
#define iOS_8_PLUS         ([PPOTMacros deviceSystemMajorVersion] >= 8)
#define iOS_7_PLUS         ([PPOTMacros deviceSystemMajorVersion] >= 7)
#define iOS_6_PLUS         ([PPOTMacros deviceSystemMajorVersion] >= 6)
#define iOS_6              ([PPOTMacros deviceSystemMajorVersion] == 6)
#define iOS_5              ([PPOTMacros deviceSystemMajorVersion] == 5)

#define FORCE_VALUE_OR_NULL(x)   (x ? x : [NSNull null])

// Use the CARDIO_STR() macro around sensitive string literals.
// E.g., `CARDIO_STR(@"http://top_secret_url.paypal.com")`.
// For release builds, uses of this macro get preprocessed by fabfile.py to obfuscate the string.
// PLEASE do not include any whitespace on either side of the string inside the parentheses;
// i.e., between `CARDIO_STR(` and `@"abc"`, or between `@"abc"` and the closing `)`.
#define CARDIO_STR(string) string

#define PPRGBAUIColor(RR, GG, BB, AA) ([UIColor colorWithRed:(RR)/255.0f green:(GG)/255.0f blue:(BB)/255.0f alpha:(AA)/255.0f])


