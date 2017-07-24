#import "BTVenmoAccountNonce.h"
#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

@interface BTVenmoAccountNonce ()

- (instancetype)initWithPaymentMethodNonce:(NSString *)nonce
                               description:(NSString *)description
                                  username:(NSString *)username
                                 isDefault:(BOOL)isDefault;

+ (instancetype)venmoAccountWithJSON:(BTJSON *)venmoAccountJSON;

@end
