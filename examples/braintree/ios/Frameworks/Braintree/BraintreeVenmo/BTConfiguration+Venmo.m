#import "BTConfiguration+Venmo.h"

@implementation BTConfiguration (Venmo)

+ (void)enableVenmo:(BOOL) __unused isEnabled { /* NO OP */ }

- (BOOL)isVenmoEnabled {
    return (self.venmoAccessToken != nil);
}

- (NSString*)venmoAccessToken {
    return [self.json[@"payWithVenmo"][@"accessToken"] asString];
}

@end
