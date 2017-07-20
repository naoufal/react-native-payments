#import "BTUIFormField.h"

@interface BTUICardPostalCodeField : BTUIFormField

@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, assign) BOOL nonDigitsSupported;

@end
