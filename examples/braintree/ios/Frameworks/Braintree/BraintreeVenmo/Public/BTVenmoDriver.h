#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif
#import "BTVenmoAccountNonce.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const BTVenmoDriverErrorDomain;

typedef NS_ENUM(NSInteger, BTVenmoDriverErrorType) {
    BTVenmoDriverErrorTypeUnknown = 0,
    
    /// Venmo is disabled in configuration
    BTVenmoDriverErrorTypeDisabled,
    
    /// App is not installed on device
    BTVenmoDriverErrorTypeAppNotAvailable,
    
    /// Bundle display name must be present
    BTVenmoDriverErrorTypeBundleDisplayNameMissing,
    
    /// UIApplication failed to switch to Venmo app
    BTVenmoDriverErrorTypeAppSwitchFailed,
    
    /// Return URL was invalid
    BTVenmoDriverErrorTypeInvalidReturnURL,
    
    /// Braintree SDK is integrated incorrectly
    BTVenmoDriverErrorTypeIntegration,
    
    /// Request URL was invalid, configuration may be missing required values
    BTVenmoDriverErrorTypeInvalidRequestURL,
};

@interface BTVenmoDriver : NSObject <BTAppSwitchHandler>

/*!
 @brief Initialize a new Venmo driver instance.

 @param apiClient The API client
*/
- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient NS_DESIGNATED_INITIALIZER;


- (instancetype)init __attribute__((unavailable("Please use initWithAPIClient:")));

/*!
 @brief Initiates Venmo login via app switch, which returns a BTVenmoAccountNonce when successful.

 @param vault Whether to automatically vault the Venmo Account. Vaulting will only occur if a client token with a customer_id is being used.
 @param completionBlock This completion will be invoked when app switch is complete or an error occurs.
    On success, you will receive an instance of `BTVenmoAccountNonce`; on failure, an error; on user
    cancellation, you will receive `nil` for both parameters.
*/
- (void)authorizeAccountAndVault:(BOOL)vault completion:(void (^)(BTVenmoAccountNonce * _Nullable venmoAccount, NSError * _Nullable error))completionBlock;

/*!
 @brief Initiates Venmo login via app switch, which returns a BTVenmoAccountNonce when successful.

 @param completionBlock This completion will be invoked when app switch is complete or an error occurs.
    On success, you will receive an instance of `BTVenmoAccountNonce`; on failure, an error; on user
    cancellation, you will receive `nil` for both parameters.
*/
- (void)authorizeAccountWithCompletion:(void (^)(BTVenmoAccountNonce * _Nullable venmoAccount, NSError * _Nullable error))completionBlock DEPRECATED_MSG_ATTRIBUTE("Use [BTVenmoDriver authorizeAccountAndVault:completion instead");

/*!
 @brief Returns true if the proper Venmo app is installed and configured correctly, returns false otherwise.
*/
- (BOOL)isiOSAppAvailableForAppSwitch;

/*!
 @brief An optional delegate for receiving notifications about the lifecycle of a Venmo app switch, as well as updating your UI
*/
@property (nonatomic, weak, nullable) id<BTAppSwitchDelegate> appSwitchDelegate;

@end

NS_ASSUME_NONNULL_END
