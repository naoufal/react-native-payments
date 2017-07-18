#import "BTClientToken.h"

NSString *const BTClientTokenKeyVersion = @"version";
NSString *const BTClientTokenKeyAuthorizationFingerprint = @"authorizationFingerprint";
NSString *const BTClientTokenKeyConfigURL = @"configUrl";
NSString * const BTClientTokenErrorDomain = @"com.braintreepayments.BTClientTokenErrorDomain";

@interface BTClientToken ()

@property (nonatomic, readwrite, copy) NSString *authorizationFingerprint;
@property (nonatomic, readwrite, strong) NSURL *configURL;
@property (nonatomic, copy) NSString *originalValue;
@property (nonatomic, readwrite, strong) BTJSON *json;

@end

@implementation BTClientToken

- (instancetype)init {
    return nil;
}

- (instancetype)initWithClientToken:(NSString *)clientToken error:(NSError * __autoreleasing *)error {
    if (self = [super init]) {
        // Client token must be decoded first because the other values are retrieved from it
        _json = [self decodeClientToken:clientToken error:error];
        _authorizationFingerprint = [_json[BTClientTokenKeyAuthorizationFingerprint] asString];
        _configURL = [_json[BTClientTokenKeyConfigURL] asURL];
        _originalValue = clientToken;

        if (![self validateClientToken:error]) {
            return nil;
        }
    }
    return self;
}

- (BOOL)validateClientToken:(NSError *__autoreleasing*)error {
    if (error != NULL && *error) {
        return NO;
    }

    if ([self.authorizationFingerprint length] == 0) {
        if (error != NULL) {
        *error = [NSError errorWithDomain:BTClientTokenErrorDomain
                                         code:BTClientTokenErrorInvalid
                                     userInfo:@{
                                                NSLocalizedDescriptionKey: @"Invalid client token. Please ensure your server is generating a valid Braintree ClientToken.",
                                                NSLocalizedFailureReasonErrorKey: @"Authorization fingerprint was not present or invalid." }];
        }
        return NO;
    }

    if (![self.configURL isKindOfClass:[NSURL class]] || self.configURL.absoluteString.length == 0) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:BTClientTokenErrorDomain
                                         code:BTClientTokenErrorInvalid
                                     userInfo:@{
                                                NSLocalizedDescriptionKey: @"Invalid client token: config url was missing or invalid. Please ensure your server is generating a valid Braintree ClientToken."
                                                }];
        }
        return NO;
    }

    return YES;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    BTClientToken *copiedClientToken = [[[self class] allocWithZone:zone] initWithClientToken:self.originalValue error:NULL];
    return copiedClientToken;
}

#pragma mark JSON Parsing

- (NSDictionary *)parseJSONString:(NSString *)rawJSONString error:(NSError * __autoreleasing *)error {
    NSData *rawJSONData = [rawJSONString dataUsingEncoding:NSUTF8StringEncoding];

    return [NSJSONSerialization JSONObjectWithData:rawJSONData options:0 error:error];
}

#pragma mark NSCoding 

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.originalValue forKey:@"originalValue"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    return [self initWithClientToken:[decoder decodeObjectForKey:@"originalValue"] error:NULL];
}

#pragma mark Client Token Parsing

- (BTJSON *)decodeClientToken:(NSString *)rawClientTokenString error:(NSError * __autoreleasing *)error {
    NSError *JSONError = nil;
    NSData *base64DecodedClientToken = [[NSData alloc] initWithBase64EncodedString:rawClientTokenString
                                                                           options:0];

    NSDictionary *rawClientToken;
    if (base64DecodedClientToken) {
        rawClientToken = [NSJSONSerialization JSONObjectWithData:base64DecodedClientToken options:0 error:&JSONError];
    } else {
        rawClientToken = [self parseJSONString:rawClientTokenString error:&JSONError];
    }

    if (!rawClientToken) {
        if (error) {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                 NSLocalizedDescriptionKey: @"Invalid client token. Please ensure your server is generating a valid Braintree ClientToken.",
                                                 NSLocalizedFailureReasonErrorKey: @"Invalid JSON"
                                                                                              }];
            if (JSONError) {
                userInfo[NSUnderlyingErrorKey] = JSONError;
            }
            *error = [NSError errorWithDomain:BTClientTokenErrorDomain
                                         code:BTClientTokenErrorInvalid
                                     userInfo:userInfo];
        }
        return nil;
    }

    if (![rawClientToken isKindOfClass:[NSDictionary class]]) {
        if (error) {
            *error = [NSError errorWithDomain:BTClientTokenErrorDomain
                                         code:BTClientTokenErrorInvalid
                                     userInfo:@{
                                                NSLocalizedDescriptionKey: @"Invalid client token. Please ensure your server is generating a valid Braintree ClientToken.",
                                                NSLocalizedFailureReasonErrorKey: @"Invalid JSON. Expected to find an object at JSON root."
                                                }];
        }
        return nil;
    }

    NSError *clientTokenFormatError = [NSError errorWithDomain:BTClientTokenErrorDomain
                                                          code:BTClientTokenErrorInvalid
                                                      userInfo:@{
                                                                 NSLocalizedDescriptionKey: @"Invalid client token format. Please pass the client token string directly as it is generated by the server-side SDK.",
                                                                 NSLocalizedFailureReasonErrorKey: @"Unsupported client token format."
                                                                 }];

    switch ([rawClientToken[BTClientTokenKeyVersion] integerValue]) {
        case 1:
            if (base64DecodedClientToken) {
                if (error) {
                    *error = clientTokenFormatError;
                }
                return nil;
            }
            break;
        case 2:
            /* FALLTHROUGH */
        case 3:
            if (!base64DecodedClientToken) {
                if (error) {
                    *error = clientTokenFormatError;
                }
                return nil;
            }
            break;
        default:
            if (error) {
                *error = [NSError errorWithDomain:BTClientTokenErrorDomain
                                             code:BTClientTokenErrorUnsupportedVersion
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey: @"Unsupported client token version. Please ensure your server is generating a valid Braintree ClientToken with a server-side SDK that is compatible with this version of Braintree iOS.",
                                                    NSLocalizedFailureReasonErrorKey: @"Unsupported client token version."
                                                    }];
            }
            return nil;
    }

    return [[BTJSON alloc] initWithValue:rawClientToken];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<BTClientToken: authorizationFingerprint:%@ configURL:%@>", self.authorizationFingerprint, self.configURL];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if ([object isKindOfClass:[BTClientToken class]]) {
        BTClientToken *otherToken = object;
        return [self.json.asDictionary isEqualToDictionary:otherToken.json.asDictionary];
    }

    return NO;
}

@end
