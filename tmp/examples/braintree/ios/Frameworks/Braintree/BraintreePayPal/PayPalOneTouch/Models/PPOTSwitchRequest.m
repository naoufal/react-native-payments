//
//  PPOTSwitchRequest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTSwitchRequest.h"
#import "PPOTMacros.h"
#import "PPDataCollector_Internal.h"

@implementation PPOTSwitchRequest

- (instancetype)initWithProtocolVersion:(NSNumber *)protocolVersion
                                appGuid:(NSString *)appGuid
                               clientID:(NSString *)clientID
                            environment:(NSString *)environment
                      callbackURLScheme:(NSString *)callbackURLScheme {
    return [self initWithProtocolVersion:protocolVersion appGuid:appGuid clientID:clientID environment:environment callbackURLScheme:callbackURLScheme pairingId:nil];
}

- (instancetype)initWithProtocolVersion:(NSNumber *)protocolVersion
                                appGuid:(NSString *)appGuid
                               clientID:(NSString *)clientID
                            environment:(NSString *)environment
                      callbackURLScheme:(NSString *)callbackURLScheme
                              pairingId:(NSString *)pairingId {
    self = [super init];
    if (self) {
        _protocolVersion = protocolVersion;
        _appGuid = appGuid;
        _clientID = clientID;
        _environment = environment;
        _responseType = PPAppSwitchResponseTypeUnknown;
        _callbackURLScheme = callbackURLScheme;
        _clientMetadataID = [PPDataCollector generateClientMetadataID:pairingId];
    }
    return self;
}

- (NSDictionary *)payloadDictionary {

    // mangle with environment for name "custom"
    NSString *environment = self.environment;
    if (![environment isEqualToString:PPRequestEnvironmentProduction] && ![environment isEqualToString:PPRequestEnvironmentNoNetwork] &&
        ![environment isEqualToString:PPRequestEnvironmentSandbox]) {
        // extract baseURL
        NSURL *serviceURL = [NSURL URLWithString:environment];
        if (!serviceURL.host.length) {
            serviceURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@", environment]];
        }
        self.customURL = [NSString stringWithFormat:@"%@://%@:%@", serviceURL.scheme, serviceURL.host, serviceURL.port];
        environment = kPPOTAppSwitchCustomEnvironmentKey;
    }

    NSMutableDictionary *payload = [NSMutableDictionary dictionaryWithCapacity:11];

    payload[kPPOTAppSwitchProtocolVersionKey] = self.protocolVersion;
    payload[kPPOTAppSwitchClientIdKey] = [self.clientID copy];
    // use environment or custom
    payload[kPPOTAppSwitchEnvironmentKey] = [environment copy];
    payload[kPPOTAppSwitchAppNameKey] = FORCE_VALUE_OR_NULL([PPOTAppSwitchUtil bundleName]);

    switch (self.responseType) {
        case PPAppSwitchResponseTypeToken:
            payload[kPPOTAppSwitchResponseTypeKey] = kPPOTAppSwitchResponseTypeToken;
            break;
        case PPAppSwitchResponseTypeAuthorizationCode:
            payload[kPPOTAppSwitchResponseTypeKey] = kPPOTAppSwitchResponseTypeCode;
            break;
        case PPAppSwitchResponseTypeWeb:
            payload[kPPOTAppSwitchResponseTypeKey] = kPPOTAppSwitchResponseTypeWeb;
            break;
        default:
            PPAssert(YES, @"Response type unsupported");
            break;
    }

    if (self.customURL.length) {
        payload[kPPOTAppSwitchEnvironmentURLKey] = self.customURL;
    }

    // dyson pairing id
    payload[kPPOTAppSwitchMetadataClientIDKey] = FORCE_VALUE_OR_NULL(self.clientMetadataID);

    return payload;
}

// default version of encodedURL (for v1, v2, and v3)
- (NSURL *)encodedURL {
    NSDictionary *payload = [self payloadDictionary];

    NSURL *url = [PPOTAppSwitchUtil URLAction:kPPOTAppSwitchAuthenticateAction
                           targetAppURLScheme:self.targetAppURLScheme
                            callbackURLScheme:self.callbackURLScheme
                                      payload:payload];
    return url;
}

- (void)addDataToPersistentRequestDataDictionary:(__attribute__((unused)) NSMutableDictionary *)requestDataDictionary {
    // subclasses each call [super] add then add their own relevant data, if any, to be retrieved when the response comes back to us
}

@end
