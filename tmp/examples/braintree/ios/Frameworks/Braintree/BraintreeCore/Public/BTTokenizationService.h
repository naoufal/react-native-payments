#import <Foundation/Foundation.h>
#import "BTAPIClient.h"
#import "BTPaymentMethodNonce.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const BTTokenizationServiceErrorDomain;
extern NSString * const BTTokenizationServiceAppSwitchDelegateOption;
extern NSString * const BTTokenizationServiceViewPresentingDelegateOption;
extern NSString * const BTTokenizationServicePayPalScopesOption;
extern NSString * const BTTokenizationServiceAmountOption;
extern NSString * const BTTokenizationServiceNonceOption;

typedef NS_ENUM(NSInteger, BTTokenizationServiceError) {
    BTTokenizationServiceErrorUnknown = 0,
    BTTokenizationServiceErrorTypeNotRegistered,
};

/*!
 @class BTTokenizationService
 @brief A tokenization service that supports registration of tokenizers at runtime.

 @discussion `BTTokenizationService` provides access to tokenization services from payment options
 (e.g. `BTPayPalDriver`) without introducing compile-time dependencies on the frameworks.
*/
@interface BTTokenizationService : NSObject

/*!
 @brief The singleton instance of the tokenization service
*/
+ (instancetype)sharedService;

/*!
 @brief Registers a block to execute for a given type when `tokenizeType:withAPIClient:completion:` or`tokenizeType:options:withAPIClient:completion:` are invoked.

 @param type A type string to identify the tokenization block. Providing a type that has already
        been registered will overwrite the previously registered tokenization block.
 @param tokenizationBlock The tokenization block to register for a type.
*/
- (void)registerType:(NSString *)type withTokenizationBlock:(void(^)(BTAPIClient *apiClient, NSDictionary * _Nullable options, void(^)(BTPaymentMethodNonce * _Nullable paymentMethodNonce, NSError * _Nullable error)))tokenizationBlock;

/*!
 @brief Indicates whether a type has been registered with a valid tokenization block.
*/
- (BOOL)isTypeAvailable:(NSString *)type;

/*!
 @brief Perform tokenization for the given type. This will execute the tokenization block that has been registered for the type.

 @param type The tokenization type to perform
 @param apiClient The API client to use when performing tokenization.
 @param completion The completion block to invoke when tokenization has completed.
*/
- (void)tokenizeType:(NSString *)type
       withAPIClient:(BTAPIClient *)apiClient
          completion:(void(^)(BTPaymentMethodNonce * _Nullable paymentMethodNonce, NSError * _Nullable error))completion;

/*!
 @brief Perform tokenization for the given type. This will execute the tokenization block that has been registered for the type.

 @param type The tokenization type to perform
 @param options A dictionary of data to use when invoking the tokenization block. This can be
        used to pass data into a tokenization client/driver, e.g. credit card raw details.
 @param apiClient The API client to use when performing tokenization.
 @param completion The completion block to invoke when tokenization has completed.
*/
- (void)tokenizeType:(NSString *)type
             options:(nullable NSDictionary<NSString *, id> *)options
       withAPIClient:(BTAPIClient *)apiClient
          completion:(void(^)(BTPaymentMethodNonce * _Nullable paymentMethodNonce, NSError * _Nullable error))completion;

@property (nonatomic, readonly, strong) NSArray <NSString *> *allTypes;

@end

NS_ASSUME_NONNULL_END
