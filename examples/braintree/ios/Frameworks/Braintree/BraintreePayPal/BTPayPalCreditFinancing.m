#import "BTPayPalAccountNonce_Internal.h"

@interface BTPayPalCreditFinancing ()

@property (nonatomic, readwrite) BOOL cardAmountImmutable;
@property (nonatomic, readwrite, strong) BTPayPalCreditFinancingAmount *monthlyPayment;
@property (nonatomic, readwrite) BOOL payerAcceptance;
@property (nonatomic, readwrite) NSInteger term;
@property (nonatomic, readwrite, strong) BTPayPalCreditFinancingAmount *totalCost;
@property (nonatomic, readwrite, strong) BTPayPalCreditFinancingAmount *totalInterest;

@end

@implementation BTPayPalCreditFinancing

- (instancetype)initWithCardAmountImmutable:(BOOL)cardAmountImmutable
                             monthlyPayment:(BTPayPalCreditFinancingAmount *)monthlyPayment
                            payerAcceptance:(BOOL)payerAcceptance
                                       term:(NSInteger)term
                                  totalCost:(BTPayPalCreditFinancingAmount *)totalCost
                              totalInterest:(BTPayPalCreditFinancingAmount *)totalInterest
{
    if (self = [super init]) {
        _cardAmountImmutable = cardAmountImmutable;
        _monthlyPayment = monthlyPayment;
        _payerAcceptance = payerAcceptance;
        _term = term;
        _totalCost = totalCost;
        _totalInterest = totalInterest;
    }
    return self;
}

@end
