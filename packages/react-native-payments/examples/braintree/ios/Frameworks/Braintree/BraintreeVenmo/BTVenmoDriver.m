#import "BTConfiguration+Venmo.h"
#if __has_include("BTLogger_Internal.h")
#import "BTLogger_Internal.h"
#else
#import <BraintreeCore/BTLogger_Internal.h>
#endif
#import "BTVenmoDriver_Internal.h"
#import "BTVenmoAccountNonce_Internal.h"
#import "BTAPIClient_Internal.h"
#import "BTVenmoAppSwitchRequestURL.h"
#import "BTVenmoAppSwitchReturnURL.h"
#import "Braintree-Version.h"
#import <UIKit/UIKit.h>

@interface BTVenmoDriver ()

@property (nonatomic, copy) void (^appSwitchCompletionBlock)(BTVenmoAccountNonce *, NSError *);

@end

NSString * const BTVenmoDriverErrorDomain = @"com.braintreepayments.BTVenmoDriverErrorDomain";

@implementation BTVenmoDriver

static BTVenmoDriver *appSwitchedDriver;

+ (void)load {
    if (self == [BTVenmoDriver class]) {
        [[BTAppSwitch sharedInstance] registerAppSwitchHandler:self];
        [[BTTokenizationService sharedService] registerType:@"Venmo" withTokenizationBlock:^(BTAPIClient *apiClient, __unused NSDictionary *options, void (^completionBlock)(BTPaymentMethodNonce *paymentMethodNonce, NSError *error)) {
            BTVenmoDriver *driver = [[BTVenmoDriver alloc] initWithAPIClient:apiClient];
            driver.appSwitchDelegate = options[BTTokenizationServiceAppSwitchDelegateOption];
            [driver authorizeAccountAndVault:YES completion:completionBlock];
        }];
        
        [[BTPaymentMethodNonceParser sharedParser] registerType:@"VenmoAccount" withParsingBlock:^BTPaymentMethodNonce * _Nullable(BTJSON * _Nonnull venmoJSON) {
            return [BTVenmoAccountNonce venmoAccountWithJSON:venmoJSON];
        }];
    }
}

- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient {
    if (self = [super init]) {
        _apiClient = [apiClient copyWithSource:BTClientMetadataSourceVenmoApp integration:apiClient.metadata.integration];
    }
    return self;
}

- (instancetype)init {
    return nil;
}

#pragma mark - Accessors

- (id)application {
    if (!_application) {
        _application = [UIApplication sharedApplication];
    }
    return _application;
}

- (NSBundle *)bundle {
    if (!_bundle) {
        _bundle = [NSBundle mainBundle];
    }
    return _bundle;
}

- (UIDevice *)device {
    if (!_device) {
        _device = [UIDevice currentDevice];
    }
    return _device;
}

- (NSString *)returnURLScheme {
    if (!_returnURLScheme) {
        _returnURLScheme = [BTAppSwitch sharedInstance].returnURLScheme;
    }
    return _returnURLScheme;
}

#pragma mark - Tokenization

- (void)authorizeAccountWithCompletion:(void (^)(BTVenmoAccountNonce *venmoAccount, NSError *configurationError))completionBlock {
    [self authorizeAccountAndVault:NO completion:completionBlock];
}

- (void)authorizeAccountAndVault:(BOOL)vault completion:(void (^)(BTVenmoAccountNonce *venmoAccount, NSError *configurationError))completionBlock {
    if (!self.apiClient) {
        NSError *error = [NSError errorWithDomain:BTVenmoDriverErrorDomain
                                             code:BTVenmoDriverErrorTypeIntegration
                                         userInfo:@{NSLocalizedDescriptionKey: @"BTVenmoDriver failed because BTAPIClient is nil."}];
        completionBlock(nil, error);
        return;
    }
    
    if (self.returnURLScheme == nil || [self.returnURLScheme isEqualToString:@""]) {
        [[BTLogger sharedLogger] critical:@"Venmo requires a return URL scheme to be configured via [BTAppSwitch setReturnURLScheme:]"];
        NSError *error = [NSError errorWithDomain:BTVenmoDriverErrorDomain
                                    code:BTVenmoDriverErrorTypeAppNotAvailable
                                userInfo:@{NSLocalizedDescriptionKey: @"UIApplication failed to perform app switch to Venmo."}];
        completionBlock(nil, error);
        return;
    } else if (![NSBundle mainBundle].bundleIdentifier || ![self.returnURLScheme hasPrefix:[NSBundle mainBundle].bundleIdentifier]) {
        [[BTLogger sharedLogger] critical:@"Venmo requires [BTAppSwitch setReturnURLScheme:] to be configured to begin with your app's bundle ID (%@). Currently, it is set to (%@) ", [NSBundle mainBundle].bundleIdentifier, self.returnURLScheme];
    }

    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *configurationError) {
        if (configurationError) {
            completionBlock(nil, configurationError);
            return;
        }
        
        NSError *error;
        if (![self verifyAppSwitchWithConfiguration:configuration error:&error]) {
            completionBlock(nil, error);
            return;
        }

        BTMutableClientMetadata *metadata = [self.apiClient.metadata mutableCopy];
        metadata.source = BTClientMetadataSourceVenmoApp;
        NSString *bundleDisplayName = [self.bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        
        BTJSON *venmoMerchantId = configuration.json[@"payWithVenmo"][@"merchantId"];
        if ([venmoMerchantId isError]) {
            completionBlock(nil, [venmoMerchantId asError]);
            return;
        }
        
        BTJSON *venmoMerchantEnvironment = configuration.json[@"payWithVenmo"][@"environment"];
        if ([venmoMerchantEnvironment isError]) {
            completionBlock(nil, [venmoMerchantEnvironment asError]);
            return;
        }

        NSURL *appSwitchURL = [BTVenmoAppSwitchRequestURL appSwitchURLForMerchantID:[venmoMerchantId asString]
                                                                        accessToken:configuration.venmoAccessToken
                                                                    returnURLScheme:self.returnURLScheme
                                                                  bundleDisplayName:bundleDisplayName
                                                                        environment:[venmoMerchantEnvironment asString]
                                                                           metadata:[self.apiClient metadata]];
        
        if (!appSwitchURL) {
            error = [NSError errorWithDomain:BTVenmoDriverErrorDomain
                                        code:BTVenmoDriverErrorTypeInvalidRequestURL
                                    userInfo:@{NSLocalizedDescriptionKey: @"Failed to create Venmo app switch request URL."}];
            completionBlock(nil, error);
            return;
        }
        
        [self informDelegateWillPerformAppSwitch];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
        if ([self.application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [self.application openURL:appSwitchURL options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
                [self invokedOpenURLSuccessfully:success shouldVault:vault completion:completionBlock];
            }];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            BOOL success = [self.application openURL:appSwitchURL];
            [self invokedOpenURLSuccessfully:success shouldVault:vault completion:completionBlock];
#pragma clang diagnostic pop
        }
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        BOOL success = [self.application openURL:appSwitchURL];
        [self invokedOpenURLSuccessfully:success shouldVault:vault completion:completionBlock];
#pragma clang diagnostic pop
#endif
    }];
}

- (void)invokedOpenURLSuccessfully:(BOOL)success shouldVault:(BOOL)vault completion:(void (^)(BTVenmoAccountNonce *venmoAccount, NSError *configurationError))completionBlock {
    self.shouldVault = success && vault;
    
    if (success) {
        [self informDelegateDidPerformAppSwitch];
        self.appSwitchCompletionBlock = completionBlock;
        appSwitchedDriver = self;
        [self.apiClient sendAnalyticsEvent:@"ios.pay-with-venmo.appswitch.initiate.success"];
    } else {
        [self.apiClient sendAnalyticsEvent:@"ios.pay-with-venmo.appswitch.initiate.error.failure"];
        NSError *error = [NSError errorWithDomain:BTVenmoDriverErrorDomain
                                    code:BTVenmoDriverErrorTypeAppSwitchFailed
                                userInfo:@{NSLocalizedDescriptionKey: @"UIApplication failed to perform app switch to Venmo."}];
        completionBlock(nil, error);
    }
}

#pragma mark - Vaulting

- (void)vaultVenmoAccountNonce:(NSString *)nonce {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"venmoAccount"] = @{
                                @"nonce": nonce
                                };
    
    [self.apiClient POST:@"v1/payment_methods/venmo_accounts"
              parameters:params
              completion:^(BTJSON *body, __unused NSHTTPURLResponse *response, NSError *error) {
                  [self informDelegateWillProcessAppSwitchReturn];
                  
                  if (error) {
                      [self.apiClient sendAnalyticsEvent:@"ios.pay-with-venmo.vault.failure"];
                      self.appSwitchCompletionBlock(nil, error);
                  } else {
                      [self.apiClient sendAnalyticsEvent:@"ios.pay-with-venmo.vault.success"];
                      BTJSON *venmoAccountJson = body[@"venmoAccounts"][0];
                      self.appSwitchCompletionBlock([BTVenmoAccountNonce venmoAccountWithJSON:venmoAccountJson], venmoAccountJson.asError);
                  }
                  self.appSwitchCompletionBlock = nil;
    }];
}

#pragma mark - App switch

- (BOOL)isiOSAppAvailableForAppSwitch {
    BOOL isAtLeastIos9 = ([[self.device systemVersion] intValue] >= 9);
    return [self.application canOpenURL:[BTVenmoAppSwitchRequestURL baseAppSwitchURL]] && isAtLeastIos9;
}

+ (void)handleAppSwitchReturnURL:(NSURL *)url {
    [appSwitchedDriver handleOpenURL:url];
    appSwitchedDriver = nil;
}

+ (BOOL)canHandleAppSwitchReturnURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    return [BTVenmoAppSwitchReturnURL isValidURL:url sourceApplication:sourceApplication];
}

- (void)handleOpenURL:(NSURL *)url {
    BTVenmoAppSwitchReturnURL *returnURL = [[BTVenmoAppSwitchReturnURL alloc] initWithURL:url];
    
    switch (returnURL.state) {
        case BTVenmoAppSwitchReturnURLStateSucceeded: {
            
            NSError *error = nil;
            if (!returnURL.nonce) {
                error = [NSError errorWithDomain:BTVenmoDriverErrorDomain code:BTVenmoDriverErrorTypeInvalidReturnURL userInfo:@{NSLocalizedDescriptionKey: @"Return URL is missing nonce"}];
            } else if (!returnURL.username) {
                error = [NSError errorWithDomain:BTVenmoDriverErrorDomain code:BTVenmoDriverErrorTypeInvalidReturnURL userInfo:@{NSLocalizedDescriptionKey: @"Return URL is missing username"}];
            }
            
            if (error) {
                [self.apiClient sendAnalyticsEvent:@"ios.pay-with-venmo.appswitch.handle.client-failure"];
                self.appSwitchCompletionBlock(nil, error);
                self.appSwitchCompletionBlock = nil;
                return;
            }
            
            [self.apiClient sendAnalyticsEvent:@"ios.pay-with-venmo.appswitch.handle.success"];
            
            if (self.shouldVault) {
                [self vaultVenmoAccountNonce:returnURL.nonce];
            } else {
                [self informDelegateWillProcessAppSwitchReturn];
                
                BTJSON *json = [[BTJSON alloc] initWithValue:@{
                                                               @"nonce": returnURL.nonce,
                                                               @"details": @{@"username": returnURL.username},
                                                               @"description": returnURL.username
                                                               }];
                BTVenmoAccountNonce *card = [BTVenmoAccountNonce venmoAccountWithJSON:json];
                self.appSwitchCompletionBlock(card, nil);
                self.appSwitchCompletionBlock = nil;
            }
            break;
        }
        case BTVenmoAppSwitchReturnURLStateFailed: {
            [self.apiClient sendAnalyticsEvent:@"ios.pay-with-venmo.appswitch.handle.failed"];
            self.appSwitchCompletionBlock(nil, returnURL.error);
            self.appSwitchCompletionBlock = nil;
            break;
        }
        case BTVenmoAppSwitchReturnURLStateCanceled: {
            [self.apiClient sendAnalyticsEvent:@"ios.pay-with-venmo.appswitch.handle.cancel"];
            self.appSwitchCompletionBlock(nil, nil);
            self.appSwitchCompletionBlock = nil;
            break;
        }
        default:
            // should not happen
            break;
    }
}

#pragma mark - Helpers

- (BOOL)verifyAppSwitchWithConfiguration:(BTConfiguration *)configuration error:(NSError * __autoreleasing *)error {
    
    if (!configuration.isVenmoEnabled) {
        [self.apiClient sendAnalyticsEvent:@"ios.pay-with-venmo.appswitch.initiate.error.disabled"];
        if (error) {
            *error = [NSError errorWithDomain:BTVenmoDriverErrorDomain
                                         code:BTVenmoDriverErrorTypeDisabled
                                     userInfo:@{ NSLocalizedDescriptionKey:@"Venmo is not enabled for this merchant account." }];
        }
        return NO;
    }
    
    if (![self isiOSAppAvailableForAppSwitch]) {
        [self.apiClient sendAnalyticsEvent:@"ios.pay-with-venmo.appswitch.initiate.error.unavailable"];
        if (error) {
            *error = [NSError errorWithDomain:BTVenmoDriverErrorDomain
                                         code:BTVenmoDriverErrorTypeAppNotAvailable
                                     userInfo:@{ NSLocalizedDescriptionKey:@"The Venmo app is not installed on this device, or it is not configured or available for app switch." }];
        }
        return NO;
    }
    
    NSString *bundleDisplayName = [self.bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!bundleDisplayName) {
        if (error) {
            *error = [NSError errorWithDomain:BTVenmoDriverErrorDomain
                                         code:BTVenmoDriverErrorTypeBundleDisplayNameMissing
                                     userInfo:@{NSLocalizedDescriptionKey: @"CFBundleDisplayName must be non-nil. Please set 'Bundle display name' in your Info.plist."}];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark - Delegate Informers

- (void)informDelegateWillPerformAppSwitch {
    NSNotification *notification = [[NSNotification alloc] initWithName:BTAppSwitchWillSwitchNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    if ([self.appSwitchDelegate respondsToSelector:@selector(appSwitcherWillPerformAppSwitch:)]) {
        [self.appSwitchDelegate appSwitcherWillPerformAppSwitch:self];
    }
}

- (void)informDelegateDidPerformAppSwitch {
    NSNotification *notification = [[NSNotification alloc] initWithName:BTAppSwitchDidSwitchNotification object:self userInfo:@{ BTAppSwitchNotificationTargetKey : @(BTAppSwitchTargetNativeApp) } ];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    if ([self.appSwitchDelegate respondsToSelector:@selector(appSwitcher:didPerformSwitchToTarget:)]) {
        [self.appSwitchDelegate appSwitcher:self didPerformSwitchToTarget:BTAppSwitchTargetNativeApp];
    }
}

- (void)informDelegateWillProcessAppSwitchReturn {
    NSNotification *notification = [[NSNotification alloc] initWithName:BTAppSwitchWillProcessPaymentInfoNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    if ([self.appSwitchDelegate respondsToSelector:@selector(appSwitcherWillProcessPaymentInfo:)]) {
        [self.appSwitchDelegate appSwitcherWillProcessPaymentInfo:self];
    }
}


@end

