#import "BTSpecHelper.h"

@implementation NSString (Nonce)

- (BOOL)isANonce {
    NSString *nonceRegularExpressionString = @"\\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\\Z";

    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:nonceRegularExpressionString
                                                                      options:0
                                                                        error:&error];
    if (error) {
        NSLog(@"Error parsing regex: %@", error);
        return NO;
    }

    return [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])] > 0;
}

@end
