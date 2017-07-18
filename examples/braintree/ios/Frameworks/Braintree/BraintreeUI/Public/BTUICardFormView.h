#import "BTUIThemedView.h"

typedef NS_OPTIONS(NSUInteger, BTUICardFormOptionalFields) {
    BTUICardFormOptionalFieldsNone       = 0,
    BTUICardFormOptionalFieldsCvv        = 1 << 0,
    BTUICardFormOptionalFieldsPostalCode = 1 << 1,
    BTUICardFormOptionalFieldsPhoneNumber= 1 << 2,
    BTUICardFormOptionalFieldsAll        = BTUICardFormOptionalFieldsCvv | BTUICardFormOptionalFieldsPostalCode | BTUICardFormOptionalFieldsPhoneNumber
};

typedef NS_ENUM(NSUInteger, BTUICardFormField) {
    BTUICardFormFieldNumber = 0,
    BTUICardFormFieldExpiration,
    BTUICardFormFieldCvv,
    BTUICardFormFieldPostalCode,
    BTUICardFormFieldPhoneNumber,
};

@protocol BTUICardFormViewDelegate;

@interface BTUICardFormView : BTUIThemedView

@property (nonatomic, weak) IBOutlet id<BTUICardFormViewDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL valid;

/*!
 @brief The card number.

 @discussion If you set a card number longer than is allowed by the card type,
 it will not be set.
*/
@property (nonatomic, copy) NSString *number;

/*!
 @brief The card CVV

 @note this field is only visible when specified in `optionalFields`
*/
@property (nonatomic, copy) NSString *cvv;

/*!
 @brief The card billing address postal code for AVS verifications

 @note this field is only visible when specified in `optionalFields`
*/
@property (nonatomic, copy) NSString *postalCode;

/*!
 @brief The card expiration month
*/
@property (nonatomic, copy, readonly) NSString *expirationMonth;

/*!
 @brief The card expiration year
*/
@property (nonatomic, copy, readonly) NSString *expirationYear;

/*!
 @brief A phone number
*/
@property (nonatomic, copy, readonly) NSString *phoneNumber;

/*!
 @brief Sets the card form view's expiration date

 @param expirationDate The expiration date. Passing in `nil` will clear the
 card form's expiry field.
*/
- (void)setExpirationDate:(NSDate *)expirationDate;

/*!
 @brief Sets the card form view's expiration date

 @param expirationMonth The expiration month
 @param expirationYear The expiration year. Two-digit years are assumed to be 20xx.
*/
- (void)setExpirationMonth:(NSInteger)expirationMonth year:(NSInteger)expirationYear;

/*!
 @brief Immediately present a top level error message to the user.

 @param message The error message to present
*/
- (void)showTopLevelError:(NSString *)message;

/*!
 @brief Immediately present a field-level error to the user.

 @note We do not support field-level error descriptions. This method highlights the field to indicate invalidity.
 @param field The invalid field
*/
- (void)showErrorForField:(BTUICardFormField)field;

/*!
 @brief Configure whether to support complete alphanumeric postal codes. Defaults to YES
 @note If NO, allows only digit entry.
*/
@property (nonatomic, assign) BOOL alphaNumericPostalCode;

/*!
 @brief Which fields should be included. Defaults to BTUICardFormOptionalFieldsAll
*/
@property (nonatomic, assign) BTUICardFormOptionalFields optionalFields;

/*!
 @brief Whether to provide feedback to the user via vibration. Defaults to YES
*/
@property (nonatomic, assign) BOOL vibrate;


@end

/*!
 @brief Delegate protocol for receiving updates about the card form
*/
@protocol BTUICardFormViewDelegate <NSObject>

@optional

/*!
 @brief The card form data has updated.
*/
- (void)cardFormViewDidChange:(BTUICardFormView *)cardFormView;

- (void)cardFormViewDidBeginEditing:(BTUICardFormView *)cardFormView;

- (void)cardFormViewDidEndEditing:(BTUICardFormView *)cardFormView;

@end
