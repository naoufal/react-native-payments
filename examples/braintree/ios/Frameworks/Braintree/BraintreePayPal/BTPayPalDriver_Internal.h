#import "BTPayPalDriver.h"
#import "BTPayPalRequestFactory.h"
#import <SafariServices/SafariServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTPayPalDriver ()

/*!
 @brief Set up the callback to be invoked on return from browser or app switch for PayPal Express Checkout (Checkout Flow)

 @discussion Exposed internally to test BTPayPalDriver app switch return behavior by simulating an app switch return
*/
- (void)setOneTimePaymentAppSwitchReturnBlock:(void (^)(BTPayPalAccountNonce * _Nullable tokenizedCheckout, NSError * _Nullable error))completionBlock;

/*!
 @brief Set up the callback to be invoked on return from browser or app switch for PayPal Billing Agreement (Vault Flow)

 @discussion Exposed internally to test BTPayPalDriver app switch return behavior by simulating an app switch return
*/
- (void)setBillingAgreementAppSwitchReturnBlock:(void (^)(BTPayPalAccountNonce * _Nullable tokenizedAccount, NSError * _Nullable error))completionBlock;

/*!
 @brief Set up the callback to be invoked on return from browser or app switch for PayPal Future Payments (Vault Flow)

 @discussion Exposed internally to test BTPayPalDriver app switch return behavior by simulating an app switch return
*/
- (void)setAuthorizationAppSwitchReturnBlock:(void (^)(BTPayPalAccountNonce * _Nullable tokenizedAccount, NSError * _Nullable error))completionBlock;

- (void)informDelegatePresentingViewControllerRequestPresent:(NSURL*) appSwitchURL;

- (void)informDelegatePresentingViewControllerNeedsDismissal;

/*!
 @brief Exposed for testing to create stubbed versions of `PayPalOneTouchAuthorizationRequest` and `PayPalOneTouchCheckoutRequest`
*/
@property (nonatomic, strong) BTPayPalRequestFactory *requestFactory;

/*!
 @brief Exposed for testing to provide subclasses of PayPalOneTouchCore to stub class methods
*/
+ (Class)payPalClass;
+ (void)setPayPalClass:(Class)payPalClass;

/*!
 @brief Exposed for testing to provide a convenient way to inject custom return URL schemes
*/
@property (nonatomic, copy) NSString *returnURLScheme;

/*!
 @brief Exposed for testing to get the instance of BTAPIClient after it has been copied by `copyWithSource:integration:`
*/
@property (nonatomic, strong, nullable) BTAPIClient *apiClient;

/*!
 @brief Exposed for testing the clientMetadataId associated with this request
*/
@property (nonatomic, strong) NSString *clientMetadataId;

/*!
 @brief Exposed for testing the intent associated with this request
*/
@property (nonatomic, strong) BTPayPalRequest *payPalRequest;

/*!
 @brief Exposed for testing, the safariViewController instance used for the paypal flow on iOS >=9
*/
@property (nonatomic, strong, nullable) SFSafariViewController *safariViewController;

/*!
 @brief Used to test the Future Payments flow by force
*/
- (void)authorizeAccountWithAdditionalScopes:(NSSet<NSString *> *)additionalScopes forceFuturePaymentFlow:(BOOL)forceFuturePaymentFlow completion:(void (^)(BTPayPalAccountNonce *, NSError *))completionBlock;

+ (nullable BTPayPalCreditFinancingAmount *)creditFinancingAmountFromJSON:(BTJSON *)amountJSON;

+ (nullable BTPayPalCreditFinancing *)creditFinancingFromJSON:(BTJSON *)creditFinancingOfferedJSON;

@end

NS_ASSUME_NONNULL_END
