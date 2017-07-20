#import "BTTestClientTokenFactory.h"

@implementation BTTestClientTokenFactory

+ (NSDictionary *)clientTokenWithVersion:(NSInteger)version configurationURL:(NSURL *)url {
    if (version < 3) {
        return @{
                 @"version": @(version),
                 @"authorizationFingerprint": @"an_authorization_fingerprint",
                 @"configUrl": url.absoluteString,
                 @"challenges": @[
                         @"cvv"
                         ],
                 @"clientApiUrl": @"https://api.example.com:443/merchants/a_merchant_id/client_api",
                 @"assetsUrl": @"https://assets.example.com",
                 @"authUrl": @"https://auth.venmo.example.com",
                 @"analytics": @{
                         @"url": @"https://client-analytics.example.com"
                         },
                 @"threeDSecureEnabled": @NO,
                 @"paypalEnabled": @YES,
                 @"paypal": @{
                         @"displayName": @"Acme Widgets, Ltd. (Sandbox)",
                         @"clientId": @"a_paypal_client_id",
                         @"privacyUrl": @"http://example.com/pp",
                         @"userAgreementUrl": @"http://example.com/tos",
                         @"baseUrl": @"https://assets.example.com",
                         @"assetsUrl": @"https://checkout.paypal.example.com",
                         @"directBaseUrl": [NSNull null],
                         @"allowHttp": @YES,
                         @"environmentNoNetwork": @YES,
                         @"environment": @"offline",
                         @"merchantAccountId": @"a_merchant_account_id",
                         @"currencyIsoCode": @"USD"
                         },
                 @"merchantId": @"a_merchant_id",
                 @"venmo": @"offline",
                 @"applePay": @{
                         @"status": @"mock",
                         @"countryCode": @"US",
                         @"currencyCode": @"USD",
                         @"merchantIdentifier": @"apple-pay-merchant-id",
                         @"supportedNetworks": @[ @"visa",
                                                  @"mastercard",
                                                  @"amex" ]
                         },
                 @"coinbaseEnabled": @YES,
                 @"coinbase": @{
                         @"clientId": @"a_coinbase_client_id",
                         @"merchantAccount": @"coinbase-account@example.com",
                         @"scopes": @"authorizations:braintree user",
                         @"redirectUrl": @"https://assets.example.com/coinbase/oauth/redirect"
                         },
                 @"merchantAccountId": @"some-merchant-account-id",
                 };
    } else {
        return @{
                 @"version": @(version),
                 @"authorizationFingerprint": @"an_authorization_fingerprint",
                 @"configUrl": url.absoluteString,
                 };
    }
}

+ (NSDictionary *)configuration {
    return @{
             @"challenges": @[
                     @"cvv"
                     ],
             @"clientApiUrl": @"https://api.example.com:443/merchants/a_merchant_id/client_api",
             @"assetsUrl": @"https://assets.example.com",
             @"authUrl": @"https://auth.venmo.example.com",
             @"analytics": @{
                     @"url": @"https://client-analytics.example.com"
                     },
             @"threeDSecureEnabled": @NO,
             @"paypalEnabled": @YES,
             @"paypal": @{
                     @"displayName": @"Acme Widgets, Ltd. (Sandbox)",
                     @"clientId": @"a_paypal_client_id",
                     @"privacyUrl": @"http://example.com/pp",
                     @"userAgreementUrl": @"http://example.com/tos",
                     @"baseUrl": @"https://assets.example.com",
                     @"assetsUrl": @"https://checkout.paypal.example.com",
                     @"directBaseUrl": [NSNull null],
                     @"allowHttp": @YES,
                     @"environmentNoNetwork": @YES,
                     @"environment": @"offline",
                     @"merchantAccountId": @"a_merchant_account_id",
                     @"currencyIsoCode": @"USD"
                     },
             @"merchantId": @"a_merchant_id",
             @"venmo": @"offline",
             @"applePay": @{
                     @"status": @"mock",
                     @"countryCode": @"US",
                     @"currencyCode": @"USD",
                     @"merchantIdentifier": @"apple-pay-merchant-id",
                     @"supportedNetworks": @[ @"visa",
                                              @"mastercard",
                                              @"amex" ]

                     },
             @"coinbaseEnabled": @YES,
             @"coinbase": @{
                     @"clientId": @"a_coinbase_client_id",
                     @"merchantAccount": @"coinbase-account@example.com",
                     @"scopes": @"authorizations:braintree user",
                     @"redirectUrl": @"https://assets.example.com/coinbase/oauth/redirect"
                     },
             @"merchantAccountId": @"some-merchant-account-id",
             };
}

+ (NSDictionary *)configurationWithOverrides:(NSDictionary *)overrides {
    return [self extendDictionary:self.configuration withOverrides:overrides];
}

+ (NSString *)tokenWithVersion:(NSInteger)version {
    return [self tokenWithVersion:version overrides:nil];
}

+ (NSString *)tokenWithVersion:(NSInteger)version
                     overrides:(NSDictionary *)overrides {
    BOOL base64Encoded = version == 1 ? NO : YES;

    NSURL *configurationURL = [self dataURLWithJSONObject:[self configurationWithOverrides:overrides]];

    NSDictionary *clientToken = [self extendDictionary:[self clientTokenWithVersion:version configurationURL:configurationURL]
                                         withOverrides:overrides];

    NSError *jsonSerializationError;
    NSData *clientTokenData = [NSJSONSerialization dataWithJSONObject:clientToken
                                                              options:0
                                                                error:&jsonSerializationError];
    NSAssert(jsonSerializationError == nil, @"Failed to generated test client token JSON: %@", jsonSerializationError);

    if (base64Encoded) {
        return [clientTokenData base64EncodedStringWithOptions:0];
    } else {
        return [[NSString alloc] initWithData:clientTokenData
                                     encoding:NSUTF8StringEncoding];
    }
}

+ (NSURL *)dataURLWithJSONObject:(id)object {
    NSError *jsonSerializationError;
    NSData *configurationData = [NSJSONSerialization dataWithJSONObject:object
                                                                options:0
                                                                  error:&jsonSerializationError];
    NSAssert(jsonSerializationError == nil, @"Failed to generated test client token JSON: %@", jsonSerializationError);
    NSString *base64EncodedConfigurationData = [configurationData base64EncodedStringWithOptions:0];
    NSString *dataURLString = [NSString stringWithFormat:@"data:application/json;base64,%@", base64EncodedConfigurationData];
    return [NSURL URLWithString:dataURLString];
}

+ (NSDictionary *)extendDictionary:(NSDictionary *)dictionary withOverrides:(NSDictionary *)overrides {
    NSMutableDictionary *extendedDictionary = [dictionary mutableCopy];

    [overrides enumerateKeysAndObjectsUsingBlock:^(id key, id obj, __unused BOOL *stop){
        if ([obj isKindOfClass:[NSNull class]]) {
            [extendedDictionary removeObjectForKey:key];
        } else if ([obj isKindOfClass:[NSDictionary class]] && [overrides[key] isKindOfClass:[NSDictionary class]]) {
            // Overriding values nested inside a dictionary
            extendedDictionary[key] = [self extendDictionary:obj withOverrides:overrides[key]];
        } else {
            extendedDictionary[key] = obj;
        }
    }];

    return extendedDictionary;
}

@end
