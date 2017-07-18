//
//  PPOTAppSwitchResponse.m
//  PayPalOneTouch
//
//  Copyright © 2014 PayPal, Inc. All rights reserved.
//

#import "PPOTAppSwitchResponse.h"
#import "PPOTString.h"
#import "PPOTTime.h"
#import "PPOTEncryptionHelper.h"
#import "PPOTJSONHelper.h"

@implementation PPOTAppSwitchResponse

- (instancetype)initWithEncodedURL:(NSURL *)url encryptionKey:(NSString *)encryptionKey {
    if (!url) {
        return nil;
    }
    self = [self initWithURL:url];
    if (self) {
        _encryptionKey = encryptionKey;

        // convert query string to dictionary, handles URLEncoding
        NSDictionary *query = [PPOTAppSwitchUtil parseQueryString:[url query]];


        // base64 encoded payload
        NSString *encodedPayload = [PPOTJSONHelper stringFromDictionary:query withKey:kPPOTAppSwitchPayloadKey];
        if (encodedPayload.length) {
            // parse payload
            _decodedPayload = [PPOTJSONHelper dictionaryWithBase64EncodedJSONString:encodedPayload];
        }

        if (_encryptionKey.length) {
            // base64 encoded encrypted payload
            NSString *encodedEncryptedPayload = [PPOTJSONHelper stringFromDictionary:query withKey:kPPOTAppSwitchEncryptedPayloadKey];
            if (encodedEncryptedPayload.length) {
                // parse encrypted payload
                NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:encodedEncryptedPayload
                                                                            options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [self parseEncryptedPayload:encryptedData];
            }
        }

        [self parsePayload];
    }
    return self;
}

- (instancetype)initWithHermesURL:(NSURL *)url environment:(NSString *)environment {
    if (!url) {
        return nil;
    }
    self = [self initWithURL:url];
    if (self) {
        // TODO: add error parsing since hermes may pass a error or abroted flag.
        _responseType = PPAppSwitchResponseTypeWeb;
        _webURL = [url absoluteString];
        _environment = environment;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [self init];
    if (self) {
        // extract action from URL
        if ([[PPOTAppSwitchUtil actionFromURLAction:url] isEqualToString:kPPOTAppSwitchCancelAction]) {
            _action = PPAppSwitchResponseActionCancel;
        } else if ([[PPOTAppSwitchUtil actionFromURLAction:url] isEqualToString:kPPOTAppSwitchSuccessAction]) {
            _action = PPAppSwitchResponseActionSuccess;
        } else {
            _action = PPAppSwitchResponseActionUnknown;
        }
    }
    return self;
}

- (void)parsePayload {

    NSNumber *version = [PPOTJSONHelper numberFromDictionary:_decodedPayload withKey:kPPOTAppSwitchProtocolVersionKey];
    // Wallet not always sends version, default to 1
    _version = version ? [version integerValue] : 1;

    // in version 3+ the response_type is no longer sent
    NSString *responseType = nil;
    if (_version >= 3) {
        responseType = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchPaymentCodeTypeKey];
        if (responseType == nil) {
            responseType = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchResponseTypeKey];
        }
    } else {
        responseType = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchResponseTypeKey];
    }

    if ([responseType isEqualToString:kPPOTAppSwitchResponseTypeCode] || [responseType isEqualToString:kPPOTAppSwitchResposneAuthCodeKey]) {
        _responseType = PPAppSwitchResponseTypeAuthorizationCode;
    } else if ([responseType isEqualToString:kPPOTAppSwitchResponseTypeToken]) {
        _responseType = PPAppSwitchResponseTypeToken;
    } else if ([responseType isEqualToString:kPPOTAppSwitchResponseTypeWeb]) {
        _responseType = PPAppSwitchResponseTypeWeb;
    } else {
        _responseType = PPAppSwitchResponseTypeUnknown;
    }

    _displayName = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchDisplayNameKey];
    _email = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchEmailKey];
    // TODO: remove check until we fix with BT
    if (!_email.length) {
        _email = [_displayName copy];
    }
    _accessToken = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchAccessTokenKey];

    if (_version >= 3) {
        _authorizationCode = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchPaymentCodeKey];;
        if (![_authorizationCode length]) {
            _authorizationCode = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchAuthorizationCodeKey];
        }
    } else {
        _authorizationCode = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchAuthorizationCodeKey];
    }

    NSNumber *expiresIn = [PPOTJSONHelper numberFromDictionary:_decodedPayload withKey:kPPOTAppSwitchExpiresInKey];
    if (expiresIn) {
        _expiresIn = [expiresIn integerValue];
    }

    NSString *scope = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchScopesKey];
    if (scope.length) {
        _scope = [scope componentsSeparatedByString:@" "];
    }

    _photoURL = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchPhotoURLKey];

    _webURL = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchWebURLKey];

    // The decoded payload may have been JSON decoded where the error value is already a dictionary
    NSDictionary *errorDict = [PPOTJSONHelper dictionaryFromDictionary:_decodedPayload withKey:kPPOTAppSwitchErrorKey];
    if (errorDict) {
        _error = errorDict;
    } else {
        NSString *error = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchErrorKey];
        if (error.length) {
            _error = [NSJSONSerialization JSONObjectWithData:[error dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        }
    }

    NSString *environment = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchEnvironmentKey];
    if (environment.length) {
        _environment = [environment lowercaseString];
    }

    // TODO: BT not sending at a string and in weird format
    NSString *strTimetamp = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchTimestampKey];
    if (strTimetamp) {
        _timeStamp = [PPOTTime dateFromRFC3339LikeString:strTimetamp];
    } else {
        NSNumber *timestamp = [PPOTJSONHelper numberFromDictionary:_decodedPayload withKey:kPPOTAppSwitchTimestampKey];
        if (timestamp) {
            _timeStamp = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
        }
    }

    _msgID = [PPOTJSONHelper stringFromDictionary:_decodedPayload withKey:kPPOTAppSwitchMsgGUIDKey];
}

- (void)parseEncryptedPayload:(NSData *)encryptedPayload {
    NSData *encryptionKey = [PPOTString dataWithHexString:_encryptionKey];
    NSData *decryptedPayload = [PPOTEncryptionHelper decryptAESCTRData:encryptedPayload encryptionKey:encryptionKey];
    if (decryptedPayload.length && encryptionKey.length) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:decryptedPayload options:0 error:nil];
        if (jsonDictionary) {
            // merge with existing payload
            NSMutableDictionary *mergedDictionary = [NSMutableDictionary dictionaryWithCapacity:_decodedPayload.count + jsonDictionary.count];
            [mergedDictionary addEntriesFromDictionary:_decodedPayload];
            [mergedDictionary addEntriesFromDictionary:jsonDictionary];
            _decodedPayload = mergedDictionary;
        }
    }
}

- (BOOL)validResponse {
    if (self.action == PPAppSwitchResponseActionCancel) {
        return YES;
    }

    if (self.responseType == PPAppSwitchResponseTypeUnknown
        || self.action == PPAppSwitchResponseActionUnknown
        || (self.version < 0 || self.version > kPPOTAppSwitchCurrentVersionNumber)
        ) {
        return NO;
    }

    // TOKEN not supported

    if (self.responseType == PPAppSwitchResponseTypeAuthorizationCode) {
        if (!self.authorizationCode.length
            || !self.email.length
            || !self.displayName.length) {
            return NO;
        }
    }

    if (self.responseType == PPAppSwitchResponseTypeWeb) {
        if (!self.webURL.length) {
            return NO;
        }
    }

    return YES;
}

- (NSString *)description {
    return [_decodedPayload description];
}

@end
