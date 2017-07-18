#import <Foundation/Foundation.h>
#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif
#import "BTCard.h"
#import "BTCardNonce.h"

@class BTCardRequest;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const BTCardClientErrorDomain;

typedef NS_ENUM(NSInteger, BTCardClientErrorType) {
    BTCardClientErrorTypeUnknown = 0,
    
    /// Braintree SDK is integrated incorrectly
    BTCardClientErrorTypeIntegration,
   
    /// Payment option (e.g. UnionPay) is not enabled for this merchant account
    BTCardClientErrorTypePaymentOptionNotEnabled,

    /// Customer provided invalid input
    BTCardClientErrorTypeCustomerInputInvalid,
};

@interface BTCardClient : NSObject

/*!
 @brief Creates a card client.

 @param apiClient An API client
*/
- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient NS_DESIGNATED_INITIALIZER;

- (instancetype)init __attribute__((unavailable("Please use initWithAPIClient:")));

/*!
 @brief Tokenizes a card.

 @param card The card to tokenize. It must have a valid number and expiration date.
 @param completion A completion block that is invoked when card tokenization has completed. If tokenization succeeds,
        `tokenizedCard` will contain a nonce and `error` will be `nil`; if it fails, `tokenizedCard` will be `nil` and `error`
        will describe the failure.
*/
- (void)tokenizeCard:(BTCard *)card completion:(void (^)(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error))completion;

/*!
 @brief Tokenizes a card.

 @param request A card tokenization request that contains an enrolled card, the enrollment ID from `enrollUnionPayCard:completion:`,
 and the enrollment auth code sent to the mobile phone number.
 @param options A dictionary containing additional options to send when performing tokenization. Optional.
 @param completion A completion block that is invoked when card tokenization has completed. If tokenization succeeds, `tokenizedCard` will contain a nonce and `error` will be `nil`; if it fails, `tokenizedCard` will be `nil` and `error` will describe the failure.
*/
- (void)tokenizeCard:(BTCardRequest *)request
             options:(nullable NSDictionary *)options
          completion:(void (^)(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
