#import "BTUIFormField.h"
#import "BTUICardType.h"

@interface BTUICardNumberField : BTUIFormField

@property (nonatomic, strong, readonly) BTUICardType *cardType;
@property (nonatomic, strong) NSString *number;

@end
