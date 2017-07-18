#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BTDataCollectorEnvironment) {
    BTDataCollectorEnvironmentDevelopment,
    BTDataCollectorEnvironmentQA,
    BTDataCollectorEnvironmentSandbox,
    BTDataCollectorEnvironmentProduction
};

@protocol BTDataCollectorDelegate;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const BTDataCollectorKountErrorDomain;

/*!
 @class BTDataCollector
 @brief Braintree's advanced fraud protection solution
*/
@interface BTDataCollector : NSObject

/*!
 @brief Set a BTDataCollectorDelegate to receive notifications about collector events.
 @see BTDataCollectorDelegate protocol declaration
*/
@property (nonatomic, weak) id<BTDataCollectorDelegate> delegate;

/*!
 @brief Initializes a `BTDataCollector` instance for an environment.

 @param environment The desired environment to target. This setting will determine which default collectorURL is used when collecting fraud data from the device.
*/
- (instancetype)initWithEnvironment:(BTDataCollectorEnvironment)environment DEPRECATED_MSG_ATTRIBUTE("Use BTDataCollector initWithAPIClient: instead");

/*!
 @brief Initializes a `BTDataCollector` instance with a BTAPIClient.

 @param apiClient The API client which can retrieve remote configuration for the data collector.
*/
- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient;

/*!
 @brief Collects device data using Kount and PayPal.

 @discussion This method collects device data using both Kount and PayPal. If you want to collect data for Kount,
 use `-collectCardFraudData`. To collect data for PayPal, integrate PayPalDataCollector and use
 `[PPDataCollector collectPayPalDeviceData]`.

 For lifecycle events such as a completion callback, use BTDataCollectorDelegate. Although you do not need
 to wait for the completion callback before performing the transaction, the data will be most effective if you do.
 Normal response time is less than 1 second, and it should never take more than 10 seconds.

 We recommend that you call this method as early as possible, e.g. at app launch. If that's too early,
 calling it e.g. when the customer initiates checkout should also be fine.

 Store the return value as deviceData to use with debit/credit card transactions on your server,
 e.g. with `Transaction.sale`.

 @param completion A completion block callback that returns a deviceData string that should be passed into server-side calls, such as `Transaction.sale`. This JSON serialized string contains the merchant ID, session ID, and the PayPal fraud ID (if PayPal is available).
*/
- (void)collectFraudData:(void (^)(NSString *deviceData))completion;

/*!
 @brief Collects device data for Kount.

 @discussion This should be used when the user is paying with a card.

 For lifecycle events such as a completion callback, use BTDataCollectorDelegate. Although you do not need
 to wait for the completion callback before performing the transaction, the data will be most effective if you do.
 Normal response time is less than 1 second, and it should never take more than 10 seconds.

 We recommend that you call this method as early as possible, e.g. at app launch. If that's too early,
 calling it e.g. when the customer initiates checkout should also be fine.

 @param completion A completion block callback that returns a deviceData string that should be passed in to server-side calls, such as `Transaction.sale` This JSON serialized string contains the merchant ID and session ID.
*/
- (void)collectCardFraudData:(void (^)(NSString *deviceData))completion;

#pragma mark - Direct Integrations

/*!
 @brief Set your fraud merchant id.

 @note If you do not call this method, a generic Braintree value will be used.

 @param fraudMerchantId The fraudMerchantId you have established with your Braintree account manager.
*/
- (void)setFraudMerchantId:(NSString *)fraudMerchantId;

#pragma mark - Deprecated

/*!
 @brief Set the URL that the Device Collector will use.

 @note If you do not call this method, a generic Braintree value will be used.

 @param url Full URL to device collector 302-redirect page
*/
- (void)setCollectorUrl:(NSString *)url DEPRECATED_MSG_ATTRIBUTE("The collector URL is no longer used. The environment will be automatically chosen.");

/*!
 @brief Generates a new PayPal fraud ID if PayPal is integrated; otherwise returns `nil`.

 @note This returns a raw client metadata ID, which is not the correct format for device datawhen creating a transaction. Instead, use `[PPDataCollector collectPayPalDeviceData]`.

 @return a client metadata ID to send as a header
*/
+ (nullable NSString *)payPalClientMetadataId DEPRECATED_MSG_ATTRIBUTE("Integrate PayPalDataCollector and use PPDataCollector +clientMetadataID instead.");

/*!
 @brief Collects device data for Kount.

 @discussion This should be used when the user is paying with a card.

 For lifecycle events such as a completion callback, use BTDataCollectorDelegate. Although you do not need
 to wait for the completion callback before performing the transaction, the data will be most effective if you do.
 Normal response time is less than 1 second, and it should never take more than 10 seconds.

 @return a deviceData string that should be passed into server-side calls, such as `Transaction.sale`.
         This JSON serialized string contains the merchant ID and session ID.
*/
- (NSString *)collectCardFraudData DEPRECATED_MSG_ATTRIBUTE("Use BTDataCollector -collectCardFraudData: instead");

/*!
 @brief Collects device data for PayPal.

 @discussion This should be used when the user is paying with PayPal or Venmo only.

 @return a deviceData string that should be passed into server-side calls, such as `Transaction.sale`,
         for PayPal transactions. This JSON serialized string contains a PayPal fraud ID.
*/
- (NSString *)collectPayPalClientMetadataId DEPRECATED_MSG_ATTRIBUTE("Integrate PayPalDataCollector and use PPDataCollector +collectPayPalDeviceData instead.");

/*!
 @brief Collects device data using Kount and PayPal.

 @discussion This method collects device data using both Kount and PayPal. If you want to collect data for Kount,
 use `-collectCardFraudData`. To collect data for PayPal, integrate PayPalDataCollector and use
 `[PPDataCollector collectPayPalDeviceData]`.

 For lifecycle events such as a completion callback, use BTDataCollectorDelegate. Although you do not need
 to wait for the completion callback before performing the transaction, the data will be most effective if you do.
 Normal response time is less than 1 second, and it should never take more than 10 seconds.

 Store the return value as deviceData to use with debit/credit card transactions on your server,
 e.g. with `Transaction.sale`.

 @return a deviceData string that should be passed into server-side calls, such as `Transaction.sale`.
         This JSON serialized string contains the merchant ID, session ID, and
         the PayPal fraud ID (if PayPal is available).
*/
- (NSString *)collectFraudData DEPRECATED_MSG_ATTRIBUTE("Use BTDataCollector -collectFraudData: instead");

@end

/*!
 @brief Provides status updates from a BTDataCollector instance. At this time, updates will only be sent for card fraud data (from Kount).
*/
@protocol BTDataCollectorDelegate <NSObject>

/*!
 @brief The collector finished successfully.

 @discussion Use this delegate method if, due to fraud, you want to wait
 until collection completes before performing a transaction.

 This method is required because there's no reason to implement BTDataCollectorDelegate without this method.
*/
- (void)dataCollectorDidComplete:(BTDataCollector *)dataCollector;

@optional

/*!
 @brief The collector has started.
*/
- (void)dataCollectorDidStart:(BTDataCollector *)dataCollector;

/*!
 @brief An error occurred.

 @param error Triggering error. If the error domain is BTDataCollectorKountErrorDomain, then the
              errorCode is a Kount error code. See error.userInfo[NSLocalizedFailureReasonErrorKey]
              for the cause of the failure.
*/
- (void)dataCollector:(BTDataCollector *)dataCollector didFailWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
