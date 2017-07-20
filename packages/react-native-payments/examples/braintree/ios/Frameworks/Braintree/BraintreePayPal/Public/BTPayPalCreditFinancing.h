#import <Foundation/Foundation.h>
#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

@interface BTPayPalCreditFinancingAmount: NSObject

/*!
 @brief 3 letter currency code as defined by <a href="http://www.iso.org/iso/home/standards/currency_codes.htm">ISO 4217</a>.
 */
@property (nonatomic, nullable, readonly, copy) NSString *currency;

/*!
 @brief An amount defined by <a href="http://www.iso.org/iso/home/standards/currency_codes.htm">ISO 4217</a> for the given currency.
 */
@property (nonatomic, nullable, readonly, copy) NSString *value;

@end

@interface BTPayPalCreditFinancing: NSObject

/*!
 @brief Indicates whether the card amount is editable after payer's acceptance on PayPal side.
 */
@property (nonatomic, readonly) BOOL cardAmountImmutable;

/*!
 @brief Estimated amount per month that the customer will need to pay including fees and interest.
 */
@property (nonatomic, nullable, readonly, strong) BTPayPalCreditFinancingAmount *monthlyPayment;

/*!
 @brief Status of whether the customer ultimately was approved for and chose to make the payment using the approved installment credit.
 */
@property (nonatomic, readonly) BOOL payerAcceptance;

/*!
 @brief Length of financing terms in months.
 */
@property (nonatomic, readonly) NSInteger term;

/*!
 @brief Estimated total payment amount including interest and fees the user will pay during the lifetime of the loan.
 */
@property (nonatomic, nullable, readonly, strong) BTPayPalCreditFinancingAmount *totalCost;

/*!
 @brief Estimated interest or fees amount the payer will have to pay during the lifetime of the loan.
 */
@property (nonatomic, nullable, readonly, strong) BTPayPalCreditFinancingAmount *totalInterest;

@end
