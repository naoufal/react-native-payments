#import "BTPayPalAccountNonce_Internal.h"

@interface BTPayPalCreditFinancingAmount ()

@property (nonatomic, readwrite, copy) NSString *currency;
@property (nonatomic, readwrite, copy) NSString *value;

@end

@implementation BTPayPalCreditFinancingAmount

- (instancetype)initWithCurrency:(NSString *)currency value:(NSString *)value {
    if (self = [super init]) {
        _currency = currency;
        _value = value;
    }
    return self;
}

@end
