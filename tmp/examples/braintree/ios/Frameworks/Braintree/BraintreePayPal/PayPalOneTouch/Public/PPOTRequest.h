//
//  PPOTRequest.h
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPOTResult.h"

/*!
 @brief Completion block for receiving the result of preflighting a request
*/
typedef void (^PPOTRequestPreflightCompletionBlock) (PPOTRequestTarget target);

/*!
 @brief Adapter block for app switching.
*/
typedef void (^PPOTRequestAdapterBlock) (BOOL success, NSURL * _Nonnull url, PPOTRequestTarget target, NSString * _Nullable clientMetadataId, NSError * _Nullable error);

/*!
 @brief This environment MUST be used for App Store submissions.
*/
extern NSString * _Nonnull const PayPalEnvironmentProduction;

/*!
 @brief Sandbox: Uses the PayPal sandbox for transactions. Useful for development.
*/
extern NSString * _Nonnull const PayPalEnvironmentSandbox;

/*!
 @brief Mock: Mock mode. Does not submit transactions to PayPal. Fakes successful responses. Useful for unit tests.
*/
extern NSString * _Nonnull const PayPalEnvironmentMock;

/*!
 @brief Base class for all One Touch requests
*/
@interface PPOTRequest : NSObject

/*!
 @brief Optional preflight method, to determine in advance to which app we will switch when this request's `performWithCompletionBlock:` method is called.

 @note As currently implemented, `completionBlock` will be called synchronously.
 We use a completion block here to allow for future changes in implementation that might cause
 delays (such as time-consuming cryptographic operations, or server interactions).
*/
- (void)getTargetApp:(nullable PPOTRequestPreflightCompletionBlock)completionBlock;

/*!
 @brief Ask the One Touch library to carry out a request.

 @discussion Will app switch to the PayPal Wallet app if present, or to the mobile browser otherwise.

 @param adapterBlock Block that makes the URL request.

 @note The adapter block is responsible for determining which app to app switch to (Wallet, browser, or neither).
 The `completionBlock` is called synchronously.
 We use a completion block here to allow for future changes in implementation that might cause
 delays (such as time-consuming cryptographic operations, or server interactions).
*/
- (void)performWithAdapterBlock:(nullable PPOTRequestAdapterBlock)adapterBlock;

/*!
 @brief Get token from approval URL
*/
+ (nullable NSString *)tokenFromApprovalURL:(nonnull NSURL *)approvalURL;

/*!
 @brief All requests MUST include the app's Client ID, as obtained from developer.paypal.com
*/
@property (nonnull, nonatomic, readonly) NSString *clientID;

/*!
 @discussion All requests MUST indicate the environment -
 `PayPalEnvironmentProduction`, `PayPalEnvironmentMock`, or `PayPalEnvironmentSandbox`;
 or else a stage indicated as `base-url:port`
*/
@property (nonnull, nonatomic, readonly) NSString *environment;

/*!
 @brief All requests MUST indicate the URL scheme to be used for returning to this app, following an app switch
*/
@property (nonnull, nonatomic, readonly) NSString *callbackURLScheme;

/*!
 @brief Requests MAY include additional key/value pairs that One Touch will add to the payload
 @discussion (For example, the Braintree client_token, which is required by the temporary Braintree Future Payments consent webpage.)
*/
@property (nonnull, nonatomic, strong) NSDictionary *additionalPayloadAttributes;

#if DEBUG
/*!
 @brief DEBUG-only: don't use downloaded configuration file; defaults to NO
*/
@property (nonatomic, assign, readwrite) BOOL useHardcodedConfiguration;
#endif

@end


/*!
 @brief Request consent for Profile Sharing (e.g., for Future Payments)
*/
@interface PPOTAuthorizationRequest : PPOTRequest

/*!
 @brief Set of requested scope-values.

 @discussion Available scope-values are listed at https://developer.paypal.com/webapps/developer/docs/integration/direct/identity/attributes/
*/
@property (nonnull, nonatomic, readonly) NSSet *scopeValues;

/*!
 @brief The URL of the merchant's privacy policy
*/
@property (nonnull, nonatomic, readonly) NSURL *privacyURL;

/*!
 @brief The URL of the merchant's user agreement
*/
@property (nonnull, nonatomic, readonly) NSURL *agreementURL;

@end


/*!
 @brief Request approval of a payment
*/
@interface PPOTCheckoutRequest : PPOTRequest

@property (nonnull, nonatomic, strong) NSString *pairingId;

/*!
 @brief Client has already created a payment on PayPal server; this is the resulting HATEOS ApprovalURL
*/
@property (nonnull, nonatomic, readonly) NSURL *approvalURL;

@end

/*!
 @brief Request approval of a Billing Agreement
*/
@interface PPOTBillingAgreementRequest : PPOTCheckoutRequest

@end

