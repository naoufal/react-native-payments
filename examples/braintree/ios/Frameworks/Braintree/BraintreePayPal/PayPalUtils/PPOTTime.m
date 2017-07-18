//
//  PPOTTime.m
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTMacros.h"
#import "PPOTTime.h"

@implementation PPOTTime

+ (NSDateFormatter *)rfc3339DateFormatter {
    /*
     Adapted from the Apple docs someplace...

     Note that this does not handle all possible
     RFC 3339 date time strings, just one of the most common styles.
     */
    static NSDateFormatter *rfc3339DateFormatter;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        rfc3339DateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

        [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
        [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });

    return rfc3339DateFormatter;
}

+ (NSDateFormatter *)rfc3339MillisecondDateFormatter {
    static NSDateFormatter* rfc3339millisecondDateFormatter;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        rfc3339millisecondDateFormatter = [[PPOTTime rfc3339DateFormatter] copy];
        [rfc3339millisecondDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
    });

    return rfc3339millisecondDateFormatter;
}

// sometimes the server supplied date has a millisecond component. Sometimes not. Easier to just deal with it.
+ (NSDate *)dateFromRFC3339LikeString:(NSString *)dateStr {
    if (dateStr == nil) {
        return nil;
    }

    NSDate* result = [[PPOTTime rfc3339DateFormatter] dateFromString:dateStr];
    if (!result) {
        result = [[PPOTTime rfc3339MillisecondDateFormatter] dateFromString:dateStr];

        if (!result) {
            PPLog(@"WARNING - could not parse '%@' into date!", dateStr);
        }
    }

    return result;
}

@end
