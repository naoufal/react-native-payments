#import "BTUIFormField.h"

@interface BTUICardExpiryField : BTUIFormField

@property (nonatomic, strong, readonly) NSString *expirationMonth;
@property (nonatomic, strong, readonly) NSString *expirationYear;

/*!
 @brief The expiration date in MMYYYY format.
*/
@property (nonatomic, copy) NSString *expirationDate;

@end

