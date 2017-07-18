#import "BTPayPalRequestFactory.h"
#import "PPOTCore.h"
#import "PPOTRequest.h"

#pragma mark - FakePayPalOneTouchCoreResult

@interface FakePayPalOneTouchCoreResult : PPOTResult
@property (nonatomic, strong, nullable) NSError *cannedError;
@property (nonatomic, assign) PPOTResultType cannedType;
@property (nonatomic, assign) PPOTRequestTarget cannedTarget;
@end

#pragma mark - FakePayPalOneTouchCore

@interface FakePayPalOneTouchCore : PPOTCore
+ (nullable FakePayPalOneTouchCoreResult *)cannedResult;
+ (void)setCannedResult:(nullable FakePayPalOneTouchCoreResult *)result;
+ (BOOL)cannedIsWalletAppAvailable;
+ (void)setCannedIsWalletAppAvailable:(BOOL)isWalletAppAvailable;
@end

#pragma mark - FakePayPalCheckoutRequest

@interface FakePayPalCheckoutRequest : PPOTCheckoutRequest
@property (nonatomic, strong, nullable) NSError *cannedError;
@property (nonatomic, assign) BOOL cannedSuccess;
@property (nonatomic, assign) PPOTRequestTarget cannedTarget;
@property (nonatomic, strong, nullable) NSString *cannedMetadataId;
@property (nonatomic, assign) BOOL appSwitchPerformed;
@end

#pragma mark - FakePayPalAuthorizationRequest

@interface FakePayPalAuthorizationRequest : PPOTAuthorizationRequest
@property (nonatomic, strong, nullable) NSError *cannedError;
@property (nonatomic, assign) BOOL cannedSuccess;
@property (nonatomic, assign) PPOTRequestTarget cannedTarget;
@property (nonatomic, strong, nullable) NSString *cannedMetadataId;
@property (nonatomic, assign) BOOL appSwitchPerformed;
@property (nonatomic, strong, nullable) NSURL *cannedURL;
@end

#pragma mark - FakePayPalBillingAgreementRequest

@interface FakePayPalBillingAgreementRequest : PPOTBillingAgreementRequest
@property (nonatomic, strong, nullable) NSError *cannedError;
@property (nonatomic, assign) BOOL cannedSuccess;
@property (nonatomic, assign) PPOTRequestTarget cannedTarget;
@property (nonatomic, strong, nullable) NSString *cannedMetadataId;
@property (nonatomic, assign) BOOL appSwitchPerformed;
@end

#pragma mark - FakePayPalRequestFactory

@interface FakePayPalRequestFactory : BTPayPalRequestFactory
@property (nonatomic, strong, nonnull) FakePayPalCheckoutRequest *checkoutRequest;
@property (nonatomic, strong, nonnull) FakePayPalAuthorizationRequest *authorizationRequest;
@property (nonatomic, strong, nonnull) FakePayPalBillingAgreementRequest *billingAgreementRequest;
@property (nonatomic, strong, nullable) NSSet<NSObject *> *lastScopeValues;
@property (nonatomic, strong, nullable) NSURL *lastApprovalURL;

@end
