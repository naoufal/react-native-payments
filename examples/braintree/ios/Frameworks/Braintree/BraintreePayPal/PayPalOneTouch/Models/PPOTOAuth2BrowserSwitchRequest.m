//
//  PPOTOAuth2BrowserSwitchRequest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTOAuth2BrowserSwitchRequest.h"
#import "PPOTTime.h"
#import "PPOTString.h"
#import "PPOTMacros.h"
#import "PPOTPersistentRequestData.h"
#import "PPOTJSONHelper.h"
#import "PPOTEncryptionHelper.h"


@interface PPOTOAuth2BrowserSwitchRequest ()
@property (nonatomic, readwrite) NSString *msgID;
@end

@implementation PPOTOAuth2BrowserSwitchRequest

- (NSString *)msgID {
    if (!_msgID.length) {
        _msgID = [PPOTString generateUniquishIdentifier];
    }
    return _msgID;
}

- (NSDictionary *)payloadDictionary {
    NSMutableDictionary *payload = [[super payloadDictionary] mutableCopy];

    payload[kPPOTAppSwitchKeyIDKey] = FORCE_VALUE_OR_NULL(self.keyID);

    if (self.additionalPayloadAttributes.count) {
        for (id key in self.additionalPayloadAttributes) {
            // avoid overriding defaults
            if (![payload objectForKey:key]) {
                payload[key] = FORCE_VALUE_OR_NULL(self.additionalPayloadAttributes[key]);
            }
        }
    }
    return payload;
}

- (NSData *)encryptedPayload {
    NSMutableDictionary *unencryptedPayload = [NSMutableDictionary dictionaryWithCapacity:6];
    unencryptedPayload[kPPOTAppSwitchTimestampKey] = FORCE_VALUE_OR_NULL([[PPOTTime rfc3339DateFormatter] stringFromDate:[NSDate date]]);
    unencryptedPayload[kPPOTAppSwitchMsgGUIDKey] = FORCE_VALUE_OR_NULL(self.msgID);
    //unencryptedPayload[kPPOTAppSwitchAppGuidKey] = FORCE_VALUE_OR_NULL(self.appGuid);
    unencryptedPayload[kPPOTAppSwitchSymKey] = FORCE_VALUE_OR_NULL(self.encryptionKey);
    NSString *currentDeviceName = [[UIDevice currentDevice] name];
    if (currentDeviceName != nil && ![currentDeviceName isEqualToString:@""]) {
        unencryptedPayload[kPPOTAppSwitchKeyDeviceName] = FORCE_VALUE_OR_NULL(currentDeviceName);
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:unencryptedPayload options:0 error:nil];
    if (!data) {
        return nil;
    }

    NSData *cipherData = [PPOTEncryptionHelper encryptRSAData:data certificate:self.certificate];
    return cipherData;
}

- (NSURL *)encodedURL {
    NSDictionary *payload = [self payloadDictionary];
    NSData *encryptedPayload = [self encryptedPayload];
    if (!encryptedPayload) {
        return nil;
    }
    NSURL *url = [PPOTAppSwitchUtil URLAction:self.endpoint callbackURLScheme:self.callbackURLScheme payload:payload];
    // cheat for now and add encrypted payload
    NSString *urlString = [url absoluteString];
    NSString *encodedEncryptedPayload = [encryptedPayload base64EncodedStringWithOptions:0];
    encodedEncryptedPayload = [PPOTString stringByURLEncodingAllCharactersInString:encodedEncryptedPayload];
    NSString *urlQuery = [NSString stringWithFormat:@"&%@=%@",kPPOTAppSwitchEncryptedPayloadKey, encodedEncryptedPayload];
    urlString = [urlString stringByAppendingString:urlQuery];

    url = [NSURL URLWithString:urlString];

    return url;
}

- (void)addDataToPersistentRequestDataDictionary:(NSMutableDictionary *)requestDataDictionary {
    [super addDataToPersistentRequestDataDictionary:requestDataDictionary];
    requestDataDictionary[kPPOTRequestDataDataDictionaryMsgIdKey] = FORCE_VALUE_OR_NULL(self.msgID);
    requestDataDictionary[kPPOTRequestDataDataDictionaryEncryptionKey] = FORCE_VALUE_OR_NULL(self.encryptionKey);
}

@end
