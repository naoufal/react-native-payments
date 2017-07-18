#import "FakePayPalClasses.h"

#pragma mark - FakePayPalOneTouchCoreResult

@implementation FakePayPalOneTouchCoreResult

- (instancetype)init {
    if (self = [super init]) {
        _cannedType = PPOTResultTypeSuccess;
        _cannedTarget = PPOTRequestTargetUnknown;
    }
    return self;
}

- (NSError *)error {
    return self.cannedError;
}

- (PPOTResultType)type {
    return self.cannedType;
}

- (PPOTRequestTarget)target {
    return self.cannedTarget;
}

- (NSDictionary *)response {
    return @{ @"foo" : @"bar", @"correlation_id" : @"a-correlation-id" };
}

@end

#pragma mark - FakePayPalOneTouchCore

@implementation FakePayPalOneTouchCore

static FakePayPalOneTouchCoreResult *cannedResult;
static BOOL cannedIsWalletAppAvailable = YES;

+ (void)initialize {
    cannedResult = [[FakePayPalOneTouchCoreResult alloc] init];
}

+ (BOOL)cannedIsWalletAppAvailable {
    return cannedIsWalletAppAvailable;
}

+ (void)setCannedIsWalletAppAvailable:(BOOL)isWalletAppAvailable {
    cannedIsWalletAppAvailable = isWalletAppAvailable;
}

+ (FakePayPalOneTouchCoreResult *)cannedResult {
    return cannedResult;
}

+ (void)setCannedResult:(FakePayPalOneTouchCoreResult *)result {
    cannedResult = result;
}


+ (void)parseResponseURL:(__unused NSURL *)url completionBlock:(PPOTCompletionBlock)completionBlock {
    completionBlock([self cannedResult]);
}

+ (void)redirectURLsForCallbackURLScheme:(__unused NSString *)callbackURLScheme
                           withReturnURL:(NSString *__autoreleasing *)returnURL
                           withCancelURL:(NSString *__autoreleasing *)cancelURL {
    *cancelURL = @"scheme://cancel";
    *returnURL = @"scheme://return";
}

+ (NSString *)clientMetadataID {
    return @"fake-client-metadata-id";
}

+ (BOOL)doesApplicationSupportOneTouchCallbackURLScheme:(__unused NSString *)callbackURLScheme {
    return YES;
}

+ (BOOL)isWalletAppInstalled {
    return [self cannedIsWalletAppAvailable];
}

@end

#pragma mark - FakePayPalCheckoutRequest

@implementation FakePayPalCheckoutRequest

- (instancetype)init {
    if (self = [super init]) {
        _cannedError = nil;
        _cannedTarget = PPOTRequestTargetBrowser;
        _cannedSuccess = YES;
        _cannedMetadataId = @"fake-canned-metadata-id";
    }
    return self;
}

- (void)performWithAdapterBlock:(PPOTRequestAdapterBlock)adapterBlock {
    self.appSwitchPerformed = YES;
    adapterBlock(self.cannedSuccess, [NSURL URLWithString:@"http://example.com"], self.cannedTarget, self.cannedMetadataId, self.cannedError);
}

@end

#pragma mark - FakePayPalAuthorizationRequest

@implementation FakePayPalAuthorizationRequest

- (instancetype)init {
    if (self = [super init]) {
        _cannedError = nil;
        _cannedTarget = PPOTRequestTargetBrowser;
        _cannedSuccess = YES;
        _cannedMetadataId = @"fake-canned-metadata-id";
    }
    return self;
}

- (void)performWithAdapterBlock:(PPOTRequestAdapterBlock)adapterBlock {
    self.appSwitchPerformed = YES;
    adapterBlock(self.cannedSuccess, self.cannedURL ? self.cannedURL : [NSURL URLWithString:@"http://example.com"], self.cannedTarget, self.cannedMetadataId, self.cannedError);
}

@end

#pragma mark - FakePayPalBillingAgreementRequest

@implementation FakePayPalBillingAgreementRequest

- (instancetype)init {
    if (self = [super init]) {
        _cannedError = nil;
        _cannedTarget = PPOTRequestTargetBrowser;
        _cannedSuccess = YES;
        _cannedMetadataId = @"fake-canned-metadata-id";
    }
    return self;
}

- (void)performWithAdapterBlock:(PPOTRequestAdapterBlock)adapterBlock {
    self.appSwitchPerformed = YES;
    adapterBlock(self.cannedSuccess, [NSURL URLWithString:@"http://example.com"], self.cannedTarget, self.cannedMetadataId, self.cannedError);
}

@end

#pragma mark - FakePayPalRequestFactory

@implementation FakePayPalRequestFactory

- (instancetype)init {
    if (self = [super init]) {
        _authorizationRequest = [[FakePayPalAuthorizationRequest alloc] init];
        _checkoutRequest = [[FakePayPalCheckoutRequest alloc] init];
        _billingAgreementRequest = [[FakePayPalBillingAgreementRequest alloc] init];
    }
    return self;
}

- (PPOTCheckoutRequest *)checkoutRequestWithApprovalURL:(__unused NSURL *)approvalURL
                                               clientID:(__unused NSString *)clientID
                                            environment:(__unused NSString *)environment
                                      callbackURLScheme:(__unused NSString *)callbackURLScheme
{
    self.lastApprovalURL = [approvalURL copy];
    return self.checkoutRequest;
}

- (PPOTBillingAgreementRequest *)billingAgreementRequestWithApprovalURL:(__unused NSURL *)approvalURL
                                                                    clientID:(__unused NSString *)clientID
                                                            environment:(__unused NSString *)environment
                                                      callbackURLScheme:(__unused NSString *)callbackURLScheme
{
    self.lastApprovalURL = [approvalURL copy];
    return self.billingAgreementRequest;
}

- (PPOTAuthorizationRequest *)requestWithScopeValues:(NSSet *)scopeValues
                                          privacyURL:(__unused NSURL *)privacyURL
                                        agreementURL:(__unused NSURL *)agreementURL
                                            clientID:(__unused NSString *)clientID
                                         environment:(__unused NSString *)environment
                                   callbackURLScheme:(__unused NSString *)callbackURLScheme
{
    self.lastScopeValues = scopeValues;
    return self.authorizationRequest;
}

@end


