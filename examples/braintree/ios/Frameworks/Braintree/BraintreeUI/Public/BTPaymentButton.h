#import "BTPaymentRequest.h"
#import "BTUIThemedView.h"
#import <UIKit/UIKit.h>

@protocol BTAppSwitchDelegate, BTViewControllerPresentingDelegate;
@class BTAPIClient, BTPaymentMethodNonce;

NS_ASSUME_NONNULL_BEGIN

@interface BTPaymentButton : BTUIThemedView

/*!
 @brief Initialize a BTPaymentButton.

 @param apiClient A `BTAPIClient` used for communicating with Braintree servers. Required.
 @param completion A completion block. Required.

 @return A new BTPaymentButton.
*/
- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient
                       completion:(void(^)(BTPaymentMethodNonce * _Nullable paymentMethodNonce, NSError * _Nullable error))completion;

/*!
 @brief The `BTAPIClient` used for communicating with Braintree servers.

 @discussion This property is exposed to enable the use of other UIView initializers, e.g.
 when using Storyboards.
*/
@property (nonatomic, strong, nullable) BTAPIClient *apiClient;

/*!
 @brief The `BTPaymentRequest` that customizes the payment experience.
*/
@property (nonatomic, strong, nullable) BTPaymentRequest *paymentRequest;

/*!
 @brief The completion block to handle the result of a payment authorization flow.

 @discussion This property is exposed to enable the use of other `UIView` initializers, e.g.
 when using Storyboards.
*/
@property (nonatomic, copy) void(^completion)(BTPaymentMethodNonce * _Nullable paymentMethodNonce, NSError * _Nullable error);

/*!
 @brief Set of payment options as strings.
 @discussion e.g. `@"PayPal"`, `@"Venmo"`. By default, this is configured
 to the set of payment options that have been included in the client-side app integration,
 e.g. via frameworks.

 Setting this property will force the button to reload and display the specified payment options,
 even if the payment option is disabled in the Control Panel.
*/
@property (nonatomic, strong) NSOrderedSet <NSString *> *enabledPaymentOptions;

/*!
 @brief The configuration from a `BTAPIClient`.
 @discussion This is automatically fetched when the payment button
 is initialized with a `BTAPIClient`, but it can be `nil` if the `BTAPIClient` has not yet been
 set or if the configuration fetch fails.

 Setting this property will force the button to reload using the new configuration.
*/
@property (nonatomic, strong, nullable) BTConfiguration *configuration;

/*!
 @brief Optional delegate for receiving payment lifecycle messages from a payment option that may initiate an app or browser switch to authorize payments.
*/
@property (nonatomic, weak, nullable) id <BTAppSwitchDelegate> appSwitchDelegate;

/*!
 @brief Optional delegate for receiving payment lifecycle messages from a payment driverthat requires presentation of a view controller to authorize a payment.

 @note Required by PayPal.
*/
@property (nonatomic, weak, nullable) id <BTViewControllerPresentingDelegate> viewControllerPresentingDelegate;

/*!
 @brief Indicates whether any payment options available.
*/
@property (nonatomic, readonly) BOOL hasAvailablePaymentMethod;

@end

NS_ASSUME_NONNULL_END
