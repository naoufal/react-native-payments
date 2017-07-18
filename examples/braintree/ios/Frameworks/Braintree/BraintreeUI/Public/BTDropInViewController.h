#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BTAPIClient, BTUI, BTPaymentRequest, BTPaymentMethodNonce;
@protocol BTDropInViewControllerDelegate;

/*!
 @class BTDropInViewController
 @brief A view controller that provides a quick and easy payment experience.

 @discussion When initialized with a Braintree client, the Drop In will prompt a user for payment details,
 based on your Gateway configuration. The Drop In payment form supports cards and PayPal. When
 using Drop In, you don't need to worry about which methods are already on file with Braintree;
 newly created methods are saved as part of the Drop In flow as needed.

 Upon successful form submission, you will receive a payment method nonce, which you can
 transact with on your server. Client and validation errors are handled internally by Drop In;
 other types of Errors are rare and generally irrecoverable.

 The Drop In view controller delegates presentation and dismissal to the developer. It has been
 most thoroughly tested in the context of a UINavigationController.

 The Drop In can send success and cancelation messages to the developer via the
 delegate. See `delegate` and `BTDropInViewControllerDelegate`.

 You can customize Drop In in various ways, for example, you can change the primary Call To
 Action button text. For visual customzation options see `theme` and `BTUI`. Like any
 UIViewController, you can setup properties like `title` or `navigationBar.rightBarButtonItem`.
*/
@interface BTDropInViewController : UIViewController

/*!
 @brief Initialize a new Drop-in view controller.

 @param apiClient A BTAPIClient used for communicating with Braintree servers. Required.

 @return A new Drop-in view controller that is ready to be presented.
*/
- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient;

/*!
 @brief The API Client used for communication with Braintree servers.
*/
@property (nonatomic, strong) BTAPIClient *apiClient;

/*!
 @brief The BTPaymentRequest that defines the Drop-in experience.

 @note The properties of this payment request are used to customize Drop-in.
*/
@property (nonatomic, strong, nullable) BTPaymentRequest *paymentRequest;

/*!
 @brief The array of `BTPaymentMethodNonce` payment method nonces on file. 
 @discussion The payment method nonces may be in the Vault.
 Most payment methods are automatically Vaulted if the client token was generated with a customer ID.
*/
@property (nonatomic, strong) NSArray *paymentMethodNonces;

#pragma mark State Change Notifications

/*!
 @brief The delegate that, if set, is notified of success or failure.
*/
@property (nonatomic, weak, nullable) id<BTDropInViewControllerDelegate> delegate;

#pragma mark Customization

/*!
 @brief The presentation theme to use for the Drop In.
*/
@property (nonatomic, strong, nullable) BTUI *theme;

/*!
 @brief Fetches the customer's saved payment methods and populates Drop In with them.

 @discussion For the best user experience, you should call this method as early as
       possible (after initializing BTDropInViewController, before presenting it)
       in order to avoid a loading spinner.

 @param completionBlock A block that gets called on completion.
*/
- (void)fetchPaymentMethodsOnCompletion:(void(^)())completionBlock;

/*!
 @brief Sets the card number in the card form.
*/
- (void)setCardNumber:(nullable NSString *)cardNumber;

/*!
 @brief Sets the expiration month and year in the card form.

 @note The expiration date uses the Gregorian calendar.

 @param expirationMonth The expiration month as a one- or two-digit number.
 @param expirationYear The expiration year as a four-digit number.
*/
- (void)setCardExpirationMonth:(NSInteger)expirationMonth year:(NSInteger)expirationYear;

@end

/*!
 @brief A protocol for BTDropInViewController completion notifications.
*/
@protocol BTDropInViewControllerDelegate <NSObject>

/*!
 @brief Informs the delegate when the user has successfully provided payment info that has been successfully tokenized.

 @discussion Upon receiving this message, you should dismiss Drop In.

 @param viewController The Drop In view controller informing its delegate of success
 @param paymentMethodNonce The selected (and possibly newly created) tokenized payment information.
*/
- (void)dropInViewController:(BTDropInViewController *)viewController didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce;

/*!
 @brief Informs the delegate when the user has decided to cancel out of the Drop-in payment form.

 @discussion Drop-in handles its own error cases, so this cancelation is user initiated and
 irreversable. Upon receiving this message, you should dismiss Drop-in.

 @param viewController The Drop-in view controller informing its delegate of failure or cancelation.
*/
- (void)dropInViewControllerDidCancel:(BTDropInViewController *)viewController;

@optional

/*!
 @brief Informs the delegate when the Drop-in view controller has finished loading.

 @param viewController The Drop-in view controller informing its delegate
*/
- (void)dropInViewControllerDidLoad:(BTDropInViewController *)viewController;

/*!
 @brief Informs the delegate when the user has entered or selected payment information.

 @param viewController The Drop-in view controller informing its delegate
*/
- (void)dropInViewControllerWillComplete:(BTDropInViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
