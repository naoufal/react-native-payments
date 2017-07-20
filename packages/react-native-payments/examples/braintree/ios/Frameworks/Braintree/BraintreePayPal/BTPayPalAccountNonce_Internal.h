#import "BTPayPalAccountNonce.h"
#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

@interface BTPayPalCreditFinancingAmount ()

- (instancetype)initWithCurrency:(NSString *)currency value:(NSString *)value;

@end

@interface BTPayPalCreditFinancing ()

- (instancetype)initWithCardAmountImmutable:(BOOL)cardAmountImmutable
                             monthlyPayment:(BTPayPalCreditFinancingAmount *)monthlyPayment
                            payerAcceptance:(BOOL)payerAcceptance
                                       term:(NSInteger)term
                                  totalCost:(BTPayPalCreditFinancingAmount *)totalCost
                              totalInterest:(BTPayPalCreditFinancingAmount *)totalInterest;

@end

@interface BTPayPalAccountNonce ()

- (instancetype)initWithNonce:(NSString *)nonce
                  description:(NSString *)description
                        email:(NSString *)email
                    firstName:(NSString *)firstName
                     lastName:(NSString *)lastName
                        phone:(NSString *)phone
               billingAddress:(BTPostalAddress *)billingAddress
              shippingAddress:(BTPostalAddress *)shippingAddress
             clientMetadataId:(NSString *)clientMetadataId
                      payerId:(NSString *)payerId
                    isDefault:(BOOL)isDefault
              creditFinancing:(BTPayPalCreditFinancing *)creditFinancing;

@end
