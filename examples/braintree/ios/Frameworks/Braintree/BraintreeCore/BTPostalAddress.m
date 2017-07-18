#import "BTPostalAddress.h"

@implementation BTPostalAddress

// Property names follow the `Braintree_Address` convention as documented at:
// https://developers.braintreepayments.com/ios+php/reference/response/address

- (id)copyWithZone:(__unused NSZone *)zone {
    BTPostalAddress *address = [[BTPostalAddress alloc] init];
    address.recipientName = self.recipientName;
    address.streetAddress = self.streetAddress;
    address.extendedAddress = self.extendedAddress;
    address.locality = self.locality;
    address.countryCodeAlpha2 = self.countryCodeAlpha2;
    address.postalCode = self.postalCode;
    address.region = self.region;
    return address;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@:%p \"%@\" %@, %@, %@, %@, %@ %@ %@>", NSStringFromClass([self class]), self, [self description], self.recipientName, self.streetAddress, self.extendedAddress, self.locality, self.region, self.postalCode, self.countryCodeAlpha2];
}

@end
