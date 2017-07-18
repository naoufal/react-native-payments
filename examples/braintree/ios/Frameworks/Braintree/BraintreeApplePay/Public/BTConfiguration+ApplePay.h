#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif
#import <PassKit/PassKit.h>

@interface BTConfiguration (ApplePay)

/*!
 @brief Indicates whether Apple Pay is enabled for your merchant account.
*/
@property (nonatomic, readonly, assign) BOOL isApplePayEnabled;

/*!
 @brief The Apple Pay payment networks supported by your Braintree merchant account.
*/
@property (nonatomic, readonly, nullable) NSArray <PKPaymentNetwork> *applePaySupportedNetworks;

/*!
 @brief Indicates if the Apple Pay merchant enabled payment networks are supported on this device.
*/
@property (nonatomic, readonly, assign) BOOL canMakeApplePayPayments;

/*!
 @brief The country code for your Braintree merchant account.
*/
@property (nonatomic, readonly, nullable) NSString *applePayCountryCode;

/*!
 @brief The Apple Pay currency code supported by your Braintree merchant account.
*/
@property (nonatomic, readonly, nullable) NSString *applePayCurrencyCode;

/*!
 @brief The Apple Pay merchant identifier associated with your Braintree merchant account.
*/
@property (nonatomic, readonly, nullable) NSString *applePayMerchantIdentifier;

@end
