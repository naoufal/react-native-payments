//
//  PPOTAuthorizationRequest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTRequest_Internal.h"
#import "PPOTAppSwitchUtil.h"
#import "PPOTConfiguration.h"
#import "PPOTDevice.h"
#import "PPOTMacros.h"
#import "PPOTOAuth2AppSwitchRequest.h"
#import "PPOTOAuth2BrowserSwitchRequest.h"
#import "PPOTEncryptionHelper.h"
#import "PPOTString.h"

#define PPRequestEnvironmentDevelop  @"develop"

@interface PPOTAuthorizationRequest ()

/// Set of requested scope-values.
/// Available scope-values are listed at https://developer.paypal.com/webapps/developer/docs/integration/direct/identity/attributes/
@property (nonatomic, readwrite) NSSet *scopeValues;

/// The URL of the merchant's privacy policy
@property (nonatomic, readwrite) NSURL *privacyURL;

/// The URL of the merchant's user agreement
@property (nonatomic, readwrite) NSURL *agreementURL;

@end

#pragma mark - PPOTAuthorizationRequest implementation

@implementation PPOTAuthorizationRequest

- (instancetype)initWithScopeValues:(NSSet *)scopeValues
                         privacyURL:(NSURL *)privacyURL
                       agreementURL:(NSURL *)agreementURL
                           clientID:(NSString *)clientID
                        environment:(NSString *)environment
                  callbackURLScheme:(NSString *)callbackURLScheme {
    if (scopeValues.count == 0) {
        PPSDKLog(@"scope is required.");
        return nil;
    }

    if (privacyURL == nil) {
        PPSDKLog(@"merchantPrivacyPolicyURL is required.");
        return nil;
    }
    if (agreementURL == nil) {
        PPSDKLog(@"merchantUserAgreementURL is required.");
        return nil;
    }

    self = [super initWithClientID:clientID environment:environment callbackURLScheme:callbackURLScheme];
    if (self) {
        _scopeValues = scopeValues;
        _privacyURL = privacyURL;
        _agreementURL = agreementURL;
    }

    return self;
}

+ (instancetype)requestWithScopeValues:(NSSet *)scopeValues
                            privacyURL:(NSURL *)privacyURL
                          agreementURL:(NSURL *)agreementURL
                              clientID:(NSString *)clientID
                           environment:(NSString *)environment
                     callbackURLScheme:(NSString *)callbackURLScheme {
    PPOTAuthorizationRequest *request = [[PPOTAuthorizationRequest alloc] initWithScopeValues:scopeValues
                                                                                   privacyURL:privacyURL
                                                                                 agreementURL:agreementURL
                                                                                     clientID:clientID
                                                                                  environment:environment
                                                                            callbackURLScheme:callbackURLScheme];
    return request;
}

#pragma mark - add subclass-specific info to appSwitchRequest

- (PPOTSwitchRequest *)getAppSwitchRequestForConfigurationRecipe:(PPOTConfigurationRecipe *)configurationRecipe {

    PPOTOAuth2SwitchRequest *appSwitchRequest = nil;

    switch (configurationRecipe.target) {
        case PPOTRequestTargetOnDeviceApplication: {
            appSwitchRequest = [[PPOTOAuth2AppSwitchRequest alloc] initWithProtocolVersion:configurationRecipe.protocolVersion
                                                                                   appGuid:[PPOTDevice appropriateIdentifier]
                                                                                  clientID:self.clientID
                                                                               environment:self.environment
                                                                         callbackURLScheme:self.callbackURLScheme];
            break;
        }
        case PPOTRequestTargetBrowser: {
            PPOTOAuth2BrowserSwitchRequest *browserSwitchRequest = [[PPOTOAuth2BrowserSwitchRequest alloc] initWithProtocolVersion:configurationRecipe.protocolVersion
                                                                                                                           appGuid:[PPOTDevice appropriateIdentifier]
                                                                                                                          clientID:self.clientID
                                                                                                                       environment:self.environment
                                                                                                                 callbackURLScheme:self.callbackURLScheme];
            PPOTConfigurationOAuthRecipe *ooauthRecipe = (PPOTConfigurationOAuthRecipe *)configurationRecipe;
            NSString *relevantEnvironment = nil;
            if (ooauthRecipe.endpoints[self.environment]) {
                relevantEnvironment = self.environment;
            } else if (![self.environment isEqualToString:PPRequestEnvironmentProduction] &&
                       ![self.environment isEqualToString:PPRequestEnvironmentNoNetwork] &&
                       ooauthRecipe.endpoints[PPRequestEnvironmentDevelop]) {
                relevantEnvironment = PPRequestEnvironmentDevelop;
            } else if (ooauthRecipe.endpoints[PPRequestEnvironmentProduction]) {
                relevantEnvironment = PPRequestEnvironmentProduction;
            }

            if (relevantEnvironment) {  // this is merely a sanity check; presence of "live" was guaranteed in [PPOTConfigurationOAuthRecipe initWithDictionary:]
                PPOTConfigurationRecipeEndpoint *endpoint = ooauthRecipe.endpoints[relevantEnvironment];
                browserSwitchRequest.endpoint = endpoint.url;
                browserSwitchRequest.keyID = endpoint.certificateSerialNumber;
                browserSwitchRequest.certificate = [[NSData alloc] initWithBase64EncodedString:endpoint.base64EncodedCertificate
                                                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];

                browserSwitchRequest.encryptionKey = [PPOTString hexStringFromData:[PPOTEncryptionHelper generate256BitKey]];
                browserSwitchRequest.additionalPayloadAttributes = self.additionalPayloadAttributes;
                appSwitchRequest = browserSwitchRequest;
            }

            break;
        }
        default: {
            break;
        }
    }

    if (appSwitchRequest) {
        appSwitchRequest.targetAppURLScheme = configurationRecipe.targetAppURLScheme;
        appSwitchRequest.responseType = PPAppSwitchResponseTypeAuthorizationCode;
        appSwitchRequest.scope = [self.scopeValues allObjects];
        // mandatory field
        appSwitchRequest.merchantName = [PPOTAppSwitchUtil bundleName];
        appSwitchRequest.privacyURL = [self.privacyURL absoluteString];
        appSwitchRequest.agreementURL = [self.agreementURL absoluteString];
    }

    return appSwitchRequest;
}

#pragma mark - configuration methods

- (BOOL)scopeIsSupportedByConfigurationRecipe:(PPOTConfigurationOAuthRecipe *)configurationRecipe {
    if ([configurationRecipe.scope count] == 1 && [configurationRecipe.scope containsObject:@"*"]) {
        return YES;
    }

    return ([self.scopeValues isSubsetOfSet:configurationRecipe.scope]);
}

- (void)getAppropriateConfigurationRecipe:(void (^)(PPOTConfigurationRecipe *configurationRecipe))completionBlock {
    PPAssert(completionBlock, @"getAppropriateConfigurationRecipe: completionBlock is required");

    PPOTConfiguration *currentConfiguration = [PPOTConfiguration getCurrentConfiguration];
    PPOTConfigurationOAuthRecipe *bestConfigurationRecipe = nil;
    for (PPOTConfigurationOAuthRecipe *configurationRecipe in currentConfiguration.prioritizedOAuthRecipes) {
        if (![self scopeIsSupportedByConfigurationRecipe:configurationRecipe]) {
            continue;
        }
        
        if (![self isConfigurationRecipeTargetSupported:configurationRecipe] ||
            ![self isConfigurationRecipeLocaleSupported:configurationRecipe]) {
            continue;
        }
        
        bestConfigurationRecipe = configurationRecipe;
        break;
    }
    
    completionBlock(bestConfigurationRecipe);
}

@end
