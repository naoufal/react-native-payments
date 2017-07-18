//
//  PPOTOAuth2SwitchRequest.m
//  PayPalOneTouch
//
//  Copyright © 2014 PayPal, Inc. All rights reserved.
//

#import "PPOTOAuth2SwitchRequest.h"
#import "PPOTMacros.h"

@implementation PPOTOAuth2SwitchRequest

- (NSDictionary *)payloadDictionary {
    NSMutableDictionary *payload = [[super payloadDictionary] mutableCopy];

    if (self.scope.count) {
        payload[kPPOTAppSwitchScopesKey] = [self.scope componentsJoinedByString:@" "];
    }

    if (self.customURL.length) {
        payload[kPPOTAppSwitchEnvironmentURLKey] = self.customURL;
    }

    if (self.privacyURL.length) {
        payload[kPPOTAppSwitchPrivacyURLKey] = self.privacyURL;
    }

    if (self.agreementURL.length) {
        payload[kPPOTAppSwitchAgreementURLKey] = self.agreementURL;
    }

    if (self.merchantName.length) {
        // update name, the reason it can be localized or maybe more complete and shortcuted for better display
        payload[kPPOTAppSwitchAppNameKey] = self.merchantName;
    }

    return payload;
}

@end
