#import "BTThreeDSecureDriver.h"

@class BTThreeDSecureAuthenticationViewController;

@interface BTThreeDSecureDriver ()

@property (nonatomic, strong) BTAPIClient *apiClient;
@property (nonatomic, strong) BTThreeDSecureCardNonce *upgradedTokenizedCard;
@property (nonatomic, copy) void (^completionBlockAfterAuthenticating)(BTThreeDSecureCardNonce *, NSError *);

- (void)threeDSecureViewControllerDidFinish:(BTThreeDSecureAuthenticationViewController *)viewController;

@end

