//
//  PPOTBillingAgreementRequest.m
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

#pragma mark - PPOTBillingAgreementRequest implementation

@implementation PPOTBillingAgreementRequest

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
    PPOTConfigurationBillingAgreementRecipe *bestConfigurationRecipe = nil;
    for (PPOTConfigurationBillingAgreementRecipe *configurationRecipe in currentConfiguration.prioritizedBillingAgreementRecipes) {
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
