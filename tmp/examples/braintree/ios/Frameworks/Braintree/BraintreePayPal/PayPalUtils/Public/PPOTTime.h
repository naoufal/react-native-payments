//
//  PPOTTime.h
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief Collection of time utility methods
*/
@interface PPOTTime : NSObject

/*!
 @return A RFC 3339 ( 2012-08-10T14:22:56.864-07:00 ) date formatter.
*/
+ (nonnull NSDateFormatter *)rfc3339DateFormatter;

/*!
 @brief Parses a string for an RFC 3339 like date string. Tries a few different options for misbehaving servers.

 @return Date from RFC339-like string
*/
+ (nullable NSDate *)dateFromRFC3339LikeString:(nullable NSString *)dateStr;

@end
