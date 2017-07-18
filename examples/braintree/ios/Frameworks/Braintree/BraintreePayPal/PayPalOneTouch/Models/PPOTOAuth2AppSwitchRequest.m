//
//  PPOTOAuth2AppSwitchRequest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTOAuth2AppSwitchRequest.h"

@implementation PPOTOAuth2AppSwitchRequest

- (NSDictionary *)payloadDictionary {
    NSMutableDictionary *payload = [[super payloadDictionary] mutableCopy];

    if (self.appGuid.length) {
        payload[kPPOTAppSwitchAppGuidKey] = self.appGuid;
    }

    return payload;
}

@end
