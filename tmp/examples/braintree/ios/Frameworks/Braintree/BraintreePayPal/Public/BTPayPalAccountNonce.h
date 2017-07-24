#import <Foundation/Foundation.h>
#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif
#import "BTPayPalCreditFinancing.h"

@interface BTPayPalAccountNonce : BTPaymentMethodNonce

/*!
 @brief Payer's email address
*/
@property (nonatomic, nullable, readonly, copy) NSString *email;

/*!
 @brief Payer's first name.
*/
@property (nonatomic, nullable, readonly, copy) NSString *firstName;

/*!
 @brief Payer's last name.
*/
@property (nonatomic, nullable, readonly, copy) NSString *lastName;

/*!
 @brief Payer's phone number.
*/
@property (nonatomic, nullable, readonly, copy) NSString *phone;

/*!
 @brief The billing address.
*/
@property (nonatomic, nullable, readonly, strong) BTPostalAddress *billingAddress;

/*!
 @brief The shipping address.
*/
@property (nonatomic, nullable, readonly, strong) BTPostalAddress *shippingAddress;

/*!
 @brief Client Metadata Id associated with this transaction.
*/
@property (nonatomic, nullable, readonly, copy) NSString *clientMetadataId;

/*!
 @brief Optional. Payer Id associated with this transaction.

 @discussion Will be provided for Billing Agreement and Checkout.
*/
@property (nonatomic, nullable, readonly, copy) NSString *payerId;

/*!
 @brief Optional. Credit financing details if the customer pays with PayPal Credit.

 @discussion Will be provided for Billing Agreement and Checkout.
 */
@property (nonatomic, nullable, readonly, strong) BTPayPalCreditFinancing *creditFinancing;

@end
