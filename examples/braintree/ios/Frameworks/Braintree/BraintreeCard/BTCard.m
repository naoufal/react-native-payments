#import "BTCard_Internal.h"
#import "BTJSON.h"

@interface BTCard ()
@property (nonatomic, strong) NSMutableDictionary *mutableParameters;
@end

@implementation BTCard

- (instancetype)init {
    return [self initWithParameters:@{}];
}

- (nonnull instancetype)initWithParameters:(NSDictionary *)parameters {
    if (self = [super init]) {
        _mutableParameters = [parameters mutableCopy];
        _number = parameters[@"number"];
        NSArray *components = [parameters[@"expiration_date"] componentsSeparatedByString:@"/"];
        if (components.count == 2) {
            _expirationMonth = components[0];
            _expirationYear = components[1];
        }
        _postalCode = parameters[@"billing_address"][@"postal_code"];
        _cvv = parameters[@"cvv"];
        
        _streetAddress = parameters[@"billing_address"][@"street_address"];
        _locality = parameters[@"billing_address"][@"locality"];
        _region = parameters[@"billing_address"][@"region"];
        _countryName = parameters[@"billing_address"][@"country_name"];
        _countryCodeAlpha2 = parameters[@"billing_address"][@"country_code_alpha2"];
        _cardholderName = parameters[@"cardholder_name"];
        
        _shouldValidate = [parameters[@"options"][@"validate"] boolValue];
    }
    return self;
}

- (instancetype)initWithNumber:(NSString *)number
               expirationMonth:(NSString *)expirationMonth
                expirationYear:(NSString *)expirationYear
                           cvv:(NSString *)cvv
{
    if (self = [self initWithParameters:@{}]) {
        _number = number;
        _expirationMonth = expirationMonth;
        _expirationYear = expirationYear;
        _cvv = cvv;
    }
    return self;
}

#pragma mark -

- (NSDictionary *)parameters {
    NSMutableDictionary *p = [self.mutableParameters mutableCopy];
    if (self.number) {
        p[@"number"] = self.number;
    }
    if (self.expirationMonth && self.expirationYear) {
        p[@"expiration_date"] = [NSString stringWithFormat:@"%@/%@", self.expirationMonth, self.expirationYear];
    }
    if (self.cvv) {
        p[@"cvv"] = self.cvv;
    }
    if (self.cardholderName) {
        p[@"cardholder_name"] = self.cardholderName;
    }
    
    NSMutableDictionary *billingAddressDictionary = [NSMutableDictionary new];
    if ([p[@"billing_address"] isKindOfClass:[NSDictionary class]]) {
        [billingAddressDictionary addEntriesFromDictionary:p[@"billing_address"]];
    }

    if (self.postalCode) {
        billingAddressDictionary[@"postal_code"] = self.postalCode;
    }
    
    if (self.streetAddress) {
        billingAddressDictionary[@"street_address"] = self.streetAddress;
    }
    
    if (self.locality) {
        billingAddressDictionary[@"locality"] = self.locality;
    }
    
    if (self.region) {
        billingAddressDictionary[@"region"] = self.region;
    }
    
    if (self.countryName) {
        billingAddressDictionary[@"country_name"] = self.countryName;
    }
    
    if (self.countryCodeAlpha2) {
        billingAddressDictionary[@"country_code_alpha2"] = self.countryCodeAlpha2;
    }

    if (billingAddressDictionary.count > 0) {
        p[@"billing_address"] = [billingAddressDictionary copy];
    }
    
    NSMutableDictionary *optionsDictionary = [NSMutableDictionary new];
    if ([p[@"options"] isKindOfClass:[NSDictionary class]]) {
        [optionsDictionary addEntriesFromDictionary:p[@"options"]];
    }
    optionsDictionary[@"validate"] = @(self.shouldValidate);
    p[@"options"] = [optionsDictionary copy];
    return [p copy];
}

@end
