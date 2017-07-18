#import <Foundation/Foundation.h>
#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/*!
 @brief Payment intent.

 @discussion Must be set to sale for immediate payment, authorize to authorize a payment for capture later, or order to create an order. Defaults to authorize. Only works in the Single Payment flow.

  @see https://developer.paypal.com/docs/integration/direct/payments/capture-payment/ Capture payments later
  @see https://developer.paypal.com/docs/integration/direct/payments/create-process-order/ Create and process orders
*/
typedef NS_ENUM(NSInteger, BTPayPalRequestIntent) {
    BTPayPalRequestIntentAuthorize = 1,
    BTPayPalRequestIntentSale,
    BTPayPalRequestIntentOrder,
};

/*!
 @brief Use this option to specify the PayPal page to display when a user lands on the PayPal site to complete the payment.
*/
typedef NS_ENUM(NSInteger, BTPayPalRequestLandingPageType) {
    BTPayPalRequestLandingPageTypeDefault = 1,
    BTPayPalRequestLandingPageTypeLogin,
    BTPayPalRequestLandingPageTypeBilling,
};

/*!
 @brief The call-to-action in the PayPal one-time payment checkout flow.

 @discussion By default the final button will show the localized word for "Continue" and implies that the final amount billed is not yet known.
             Setting the BTPayPalRequest's userAction to `BTPayPalRequestUserActionCommit` changes the button text to "Pay Now", conveying to
             the user that billing will take place immediately.
*/
typedef NS_ENUM(NSInteger, BTPayPalRequestUserAction) {
    BTPayPalRequestUserActionDefault = 1,
    BTPayPalRequestUserActionCommit,
};

/*!
 @brief A PayPal request specifies options that control the PayPal flow.

 @discussion For a one-time payment, the request must specify a transaction amount.

 @see BTPayPalDriver
*/
@interface BTPayPalRequest : NSObject

/*!
 @brief Initialize a PayPal request with an amount for a one-time payment.

 @param amount Used for a one-time payment. Amount must be greater than or equal to zero, may optionally contain exactly 2 decimal places separated by '.', optional thousands separator ',', and is limited to 7 digits before the decimal point.
 @return A PayPal request.
*/
- (instancetype)initWithAmount:(NSString *)amount;

/*!
 @brief Used for a one-time payment.

 @discussion Amount must be greater than or equal to zero, may optionally contain exactly 2 decimal places separated by '.', optional thousands separator ',', and is limited to 7 digits before the decimal point.
*/
@property (nonatomic, readonly, strong) NSString *amount;

/*!
 @brief Defaults to false. When set to true, the shipping address selector will be displayed.
*/
@property (nonatomic, getter=isShippingAddressRequired) BOOL shippingAddressRequired;

/*!
 @brief Optional: A valid ISO currency code to use for the transaction. Defaults to merchant currency code if not set.
 @note This is only used for one-time payments.
*/
@property (nonatomic, nullable, copy) NSString *currencyCode;

/*!
 @brief Optional: A locale code to use for the transaction.

 @discussion Supported locales are:

 `da_DK`,
 `de_DE`,
 `en_AU`,
 `en_GB`,
 `en_US`,
 `es_ES`,
 `es_XC`,
 `fr_CA`,
 `fr_FR`,
 `fr_XC`,
 `id_ID`,
 `it_IT`,
 `ja_JP`,
 `ko_KR`,
 `nl_NL`,
 `no_NO`,
 `pl_PL`,
 `pt_BR`,
 `pt_PT`,
 `ru_RU`,
 `sv_SE`,
 `th_TH`,
 `tr_TR`,
 `zh_CN`,
 `zh_HK`,
 `zh_TW`,
 `zh_XC`.
*/
@property (nonatomic, nullable, copy) NSString *localeCode;

/*!
 @brief Optional: A valid shipping address to be displayed in the transaction flow. An error will occur if this address is not valid.
*/
@property (nonatomic, nullable, strong) BTPostalAddress *shippingAddressOverride;

/*!
 @brief Optional: Display a custom description to the user for a billing agreement.
*/
@property (nonatomic, nullable, copy) NSString *billingAgreementDescription;

/*!
 @brief Optional: Payment intent. Only applies when using checkout flow. Defaults to `BTPayPalRequestIntentAuthorize`.
*/
@property (nonatomic) BTPayPalRequestIntent intent;

/*!
 @brief Optional: Changes the call-to-action in the PayPal flow. This option works for both checkout and vault flows. Defaults to `BTPayPalRequestUserActionDefault`.
*/
@property (nonatomic) BTPayPalRequestUserAction userAction;

/*!
 @brief Optional: Landing page type. Defaults to `BTPayPalRequestLandingPageTypeDefault`.

 @discussion Setting the BTPayPalRequest's landingPageType changes the PayPal page to display when a user lands on the PayPal site to complete the payment. BTPayPalRequestLandingPageTypeLogin specifies a PayPal account login page is used. BTPayPalRequestLandingPageTypeBilling specifies a non-PayPal account landing page is used.
 */
@property (nonatomic) BTPayPalRequestLandingPageType landingPageType;

/*!
 @brief Optional: The merchant name displayed inside of the PayPal flow; defaults to the company name on your Braintree account
*/
@property (nonatomic, nullable, copy) NSString *displayName;

/*!
 @brief Optional: Offers PayPal Credit if the customer qualifies. Defaults to false. Only available with PayPal Checkout and PayPal Billing Agreement.
 */
@property (nonatomic) BOOL offerCredit;

@end

NS_ASSUME_NONNULL_END
