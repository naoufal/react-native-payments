//
//  PPOTCheckoutRequest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTRequest_Internal.h"
#import "PPOTCheckoutAppSwitchRequest.h"
#import "PPOTCheckoutBrowserSwitchRequest.h"
#import "PPOTConfiguration.h"
#import "PPOTDevice.h"
#import "PPOTMacros.h"

#pragma mark - PPOTCheckoutRequest implementation

@implementation PPOTCheckoutRequest

- (instancetype)initWithApprovalURL:(NSURL *)approvalURL
                          pairingId:(NSString *)pairingId
                           clientID:(NSString *)clientID environment:(NSString *)environment
                  callbackURLScheme:(NSString *)callbackURLScheme {
    if (!approvalURL
        || ([environment isEqualToString:PPRequestEnvironmentProduction]
            && ![approvalURL.absoluteString hasPrefix:@"https://"])) {
            PPSDKLog(@"invalid approval URL, or scheme is not https:");
            return nil;
        }

    NSDictionary *queryDictionary = [PPOTAppSwitchUtil parseQueryString:[approvalURL query]];
    NSString *hermesToken = queryDictionary[kPPOTAppSwitchHermesTokenKey];
    if (!hermesToken) {
        hermesToken = queryDictionary[kPPOTAppSwitchHermesBATokenKey];
    }

    if (!hermesToken) {
        PPSDKLog(@"approval URL lacks a Hermes token");
        return nil;
    }

    self = [super initWithClientID:clientID environment:environment callbackURLScheme:callbackURLScheme];
    if (self) {
        _approvalURL = approvalURL;

        _pairingId = pairingId;
    }
    return self;
}

+ (instancetype)requestWithApprovalURL:(NSURL *)approvalURL
                              clientID:(NSString *)clientID
                           environment:(NSString *)environment
                     callbackURLScheme:(NSString *)callbackURLScheme {
    return [PPOTCheckoutRequest requestWithApprovalURL:approvalURL pairingId:nil clientID:clientID environment:environment callbackURLScheme:callbackURLScheme];
}

+ (instancetype)requestWithApprovalURL:(NSURL *)approvalURL
                             pairingId:(NSString *)pairingId
                              clientID:(NSString *)clientID
                           environment:(NSString *)environment
                     callbackURLScheme:(NSString *)callbackURLScheme {
    PPOTCheckoutRequest *request = [[[self class] alloc] initWithApprovalURL:approvalURL
                                                                   pairingId:pairingId
                                                                    clientID:clientID
                                                                 environment:environment
                                                           callbackURLScheme:callbackURLScheme];
    return request;
}

#pragma mark - add subclass-specific info to appSwitchRequest

- (PPOTSwitchRequest *)getAppSwitchRequestForConfigurationRecipe:(PPOTConfigurationRecipe *)configurationRecipe {

    PPOTCheckoutSwitchRequest *appSwitchRequest = nil;

    switch (configurationRecipe.target) {
        case PPOTRequestTargetOnDeviceApplication: {
            appSwitchRequest = [[PPOTCheckoutAppSwitchRequest alloc] initWithProtocolVersion:configurationRecipe.protocolVersion
                                                                                     appGuid:[PPOTDevice appropriateIdentifier]
                                                                                    clientID:self.clientID
                                                                                 environment:self.environment
                                                                           callbackURLScheme:self.callbackURLScheme
                                                                                   pairingId:self.pairingId];
            break;
        }
        case PPOTRequestTargetBrowser: {
            PPOTCheckoutBrowserSwitchRequest *browserSwitchRequest =
            [[PPOTCheckoutBrowserSwitchRequest alloc] initWithProtocolVersion:configurationRecipe.protocolVersion
                                                                      appGuid:[PPOTDevice appropriateIdentifier]
                                                                     clientID:self.clientID
                                                                  environment:self.environment
                                                            callbackURLScheme:self.callbackURLScheme
                                                                    pairingId:self.pairingId];
            appSwitchRequest = browserSwitchRequest;
            break;
        }
        default: {
            break;
        }
    }

    if (appSwitchRequest) {
        appSwitchRequest.targetAppURLScheme = configurationRecipe.targetAppURLScheme;
        appSwitchRequest.responseType = PPAppSwitchResponseTypeWeb;
        appSwitchRequest.approvalURL = [self.approvalURL absoluteString];
    }

    return appSwitchRequest;
}

#pragma mark - configuration methods

- (void)getAppropriateConfigurationRecipe:(void (^)(PPOTConfigurationRecipe *configurationRecipe))completionBlock {
    PPAssert(completionBlock, @"getAppropriateConfigurationRecipe: completionBlock is required");

    PPOTConfiguration *currentConfiguration = [PPOTConfiguration getCurrentConfiguration];
    PPOTConfigurationCheckoutRecipe *bestConfigurationRecipe = nil;
    for (PPOTConfigurationCheckoutRecipe *configurationRecipe in currentConfiguration.prioritizedCheckoutRecipes) {
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
