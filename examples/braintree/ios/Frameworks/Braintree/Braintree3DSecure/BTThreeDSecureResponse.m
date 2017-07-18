#import "BTThreeDSecureResponse.h"

@implementation BTThreeDSecureResponse

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<BTThreeDSecureResponse: %p success:%@ tokenizedCard:%@ errorMessage:%@ threeDSecureInfo:%@>", self, self.success ? @"YES" : @"NO", self.tokenizedCard, self.errorMessage, self.threeDSecureInfo];
}

@end
