#import <UIKit/UIKit.h>
#if __has_include("BraintreeCore.h")
#import "BraintreeCard.h"
#import "BraintreeCore.h"
#else
#import <BraintreeCard/BraintreeCard.h>
#import <BraintreeCore/BraintreeCore.h>
#endif
#import "BTThreeDSecureCardNonce.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BTThreeDSecureDriverDelegate;
/*!
 @brief 3D Secure Verification Driver

 @discussion 3D Secure is a protocol that enables cardholders and issuers to add a layer of security
 to e-commerce transactions via password entry at checkout.

 One of the primary reasons to use 3D Secure is to benefit from a shift in liability from the
 merchant to the issuer, which may result in interchange savings. Please read our online
 documentation (https://developers.braintreepayments.com/ios/guides/3d-secure) for a full explanation of 3D Secure.

 After initializing this class with a Braintree client and delegate, you may verify Braintree
 payment methods via the verifyCardWithNonce:amount: method. During verification, the delegate
 may receive a request to present a view controller, as well as a success and failure messages.

 Verification is associated with a transaction amount and your merchant account. To specify a
 different merchant account, you will need to specify the merchant account id
 when generating a client token (See https://developers.braintreepayments.com/ios/sdk/overview/generate-client-token ).

 Your delegate must implement:
   * paymentDriver:requestsPresentationOfViewController:
   * paymentDriver:requestsDismissalOfViewController:

 When verification succeeds, the original payment method nonce is consumed, and you will receive
 a new payment method nonce, which points to the original payment method, as well as the 3D
 Secure Verification. Transactions created with this nonce are eligible for 3D Secure
 liability shift.

 When verification fails, the original payment method nonce is not consumed. While you may choose
 to proceed with transaction creation, using the original payment method nonce, this transaction
 will not be associated with a 3D Secure Verification.

 @note The user authentication view controller is not always necessary to achieve the liabilty
 shift. In these cases, your completionBlock will immediately be called.
*/
@interface BTThreeDSecureDriver : NSObject

/*!
 @brief Initializes a 3D Secure verification manager

 @param apiClient The Braintree API Client
 @param delegate The BTViewControllerPresentingDelegate

 @return An initialized instance of BTThreeDSecureDriver
*/
- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient delegate:(id<BTViewControllerPresentingDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init __attribute__((unavailable("Please use initWithAPIClient: instead.")));

/*!
 @brief Verify a card for a 3D Secure transaction, referring to the card by raw payment method nonce

 @discussion This method is useful for implementations where 3D Secure verification occurs after generating
 a payment method nonce from a vaulted credit card on your backend.
 
 On success, you will receive an instance of `BTCardNonce`. Typically, an implementation will send this tokenized card to your own
 server for further use.
 On failure, you will receive an error.
 
 A failure may occur at any point during tokenization:
 - Payment authorization is initiated with an incompatible configuration (e.g. no authorization
 mechanism possible for specified provider)
 - An authorization provider encounters an error
 - A network or gateway error occurs
 - The user-provided credentials led to a non-transactable payment method.
 
 On user cancellation, you will receive `nil` for both parameters.

 @note This method performs an asynchronous operation and may request presentation of a view
       controller via the delegate. It is the caller's responsibility to present an activity
       indication to the user in the meantime.

 @param nonce  A payment method nonce
 @param amount The amount of the transaction in the current merchant account's currency
 @param completionBlock This completion will be invoked exactly once when authorization is complete, is cancelled, or an error occurs.
*/
- (void)verifyCardWithNonce:(NSString *)nonce
                     amount:(NSDecimalNumber *)amount
                 completion:(void (^)(BTThreeDSecureCardNonce * _Nullable tokenizedCard, NSError * _Nullable error))completionBlock;

#pragma mark - Delegate

/*!
 @brief A delegate that presents and dismisses a view controller, as necessary, for the 3D Secure verification flow.
*/
@property (nonatomic, weak) id<BTViewControllerPresentingDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
