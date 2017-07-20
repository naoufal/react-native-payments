#import "BTUIFormField.h"
#import "BTUICardType.h"

@interface BTUICardCvvField : BTUIFormField

@property (nonatomic, strong) BTUICardType *cardType;

@property (nonatomic, copy) NSString *cvv;

@end
