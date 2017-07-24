#import "BTThreeDSecureLookupResult.h"

@implementation BTThreeDSecureLookupResult

- (BOOL)requiresUserAuthentication {
    return self.acsURL != nil;
}

@end
