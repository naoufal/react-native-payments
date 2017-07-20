#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class BTCard
 @discussion The card tokenization request represents raw credit or debit card data provided by the customer. Its main purpose is to serve as the input for tokenization.
*/
@interface BTCard : NSObject

/*!
 @brief A convenience initializer for creating a card tokenization request.
*/
- (instancetype)initWithNumber:(NSString *)number
               expirationMonth:(NSString *)expirationMonth
                expirationYear:(NSString *)expirationYear
                           cvv:(nullable NSString *)cvv;

- (instancetype)initWithParameters:(NSDictionary *)parameters NS_DESIGNATED_INITIALIZER;

/*!
 @brief The card number
*/
@property (nonatomic, nullable, copy) NSString *number;

/*!
 @brief The expiration month as a one or two-digit number on the Gregorian calendar
*/
@property (nonatomic, nullable, copy) NSString *expirationMonth;

/*!
 @brief The expiration year as a two or four-digit number on the Gregorian calendar
*/
@property (nonatomic, nullable, copy) NSString *expirationYear;

/*!
 @brief The card CVV
*/
@property (nonatomic, nullable, copy) NSString *cvv;

/*!
 @brief The postal code associated with the card's billing address
*/

@property (nonatomic, nullable, copy) NSString *postalCode;

/*!
 @brief Optional: the cardholder's name.
*/
@property (nonatomic, nullable, copy) NSString *cardholderName;

/*!
 @brief Optional: the street address associated with the card's billing address
*/
@property (nonatomic, nullable, copy) NSString *streetAddress;

/*!
 @brief Optional: the city associated with the card's billing address
*/
@property (nonatomic, nullable, copy) NSString *locality;

/*!
 @brief Optional: the state/province associated with the card's billing address
*/
@property (nonatomic, nullable, copy) NSString *region;

/*!
 @brief Optional: the country name associated with the card's billing address.

 @note Braintree only accepts specific country names.
 @see https://developers.braintreepayments.com/reference/general/countries#list-of-countries
*/
@property (nonatomic, nullable, copy) NSString *countryName;

/*!
 @brief Optional: the ISO 3166-1 alpha-2 country code specified in the card's billing address.

 @note Braintree only accepts specific alpha-2 values.
 @see https://developers.braintreepayments.com/reference/general/countries#list-of-countries
*/
@property (nonatomic, nullable, copy) NSString *countryCodeAlpha2;

/*! 
 @brief Controls whether or not to return validations and/or verification results. By default, this is not enabled.

 @note Use this flag with caution. By enabling client-side validation, certain tokenize card requests may result in adding the card to the vault. These semantics are not currently documented.
*/
@property (nonatomic, assign) BOOL shouldValidate;

@end

NS_ASSUME_NONNULL_END
