#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

@interface BTConfiguration (DataCollector)

/*!
 @brief Indicates whether Kount is enabled for the merchant account.
*/
@property (nonatomic, readonly, assign) BOOL isKountEnabled;

/*!
 @brief Returns the Kount merchant id set in the Gateway
*/
@property (nonatomic, readonly, assign) NSString *kountMerchantId;

@end
