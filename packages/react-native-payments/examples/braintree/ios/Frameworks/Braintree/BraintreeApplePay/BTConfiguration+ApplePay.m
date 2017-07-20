#import "BTConfiguration+ApplePay.h"
#import <PassKit/PassKit.h>

@implementation BTConfiguration (ApplePay)

- (BOOL)isApplePayEnabled {
    BTJSON *applePayConfiguration = self.json[@"applePay"];
    return [applePayConfiguration[@"status"] isString] && ![[applePayConfiguration[@"status"] asString] isEqualToString:@"off"];
}

- (BOOL)canMakeApplePayPayments {
    return [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:self.applePaySupportedNetworks];
}

- (NSString *)applePayCountryCode {
    return [self.json[@"applePay"][@"countryCode"] asString];
}

- (NSString *)applePayCurrencyCode {
    return [self.json[@"applePay"][@"currencyCode"] asString];
}

- (NSString *)applePayMerchantIdentifier {
    return [self.json[@"applePay"][@"merchantIdentifier"] asString];
}

- (NSArray<PKPaymentNetwork> *)applePaySupportedNetworks {
    NSArray <NSString *> *gatewaySupportedNetworks = [self.json[@"applePay"][@"supportedNetworks"] asStringArray];

    NSMutableArray <PKPaymentNetwork> *supportedNetworks = [NSMutableArray new];

    for (NSString *gatewaySupportedNetwork in gatewaySupportedNetworks) {
        if ([gatewaySupportedNetwork localizedCaseInsensitiveCompare:@"visa"] == NSOrderedSame) {
            [supportedNetworks addObject:PKPaymentNetworkVisa];
        } else if ([gatewaySupportedNetwork localizedCaseInsensitiveCompare:@"mastercard"] == NSOrderedSame) {
            [supportedNetworks addObject:PKPaymentNetworkMasterCard];
        } else if ([gatewaySupportedNetwork localizedCaseInsensitiveCompare:@"amex"] == NSOrderedSame) {
            [supportedNetworks addObject:PKPaymentNetworkAmex];
        } else if (&PKPaymentNetworkDiscover != NULL && [gatewaySupportedNetwork localizedCaseInsensitiveCompare:@"discover"] == NSOrderedSame) { // Very important to check that this constant is available first!
            [supportedNetworks addObject:PKPaymentNetworkDiscover];
        }
    }

    return [supportedNetworks copy];
}

@end
