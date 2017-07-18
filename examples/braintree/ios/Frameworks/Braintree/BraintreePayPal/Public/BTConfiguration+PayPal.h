#if __has_include("BraintreeCore.h")
#import "BTConfiguration.h"
#else
#import <BraintreeCore/BTConfiguration.h>
#endif

@interface BTConfiguration (PayPal)

/*!
 @brief Indicates whether PayPal is enabled for the merchant account.
*/
@property (nonatomic, readonly, assign) BOOL isPayPalEnabled;
@property (nonatomic, readonly, assign) BOOL isBillingAgreementsEnabled;

@end
