#import "BTDropInErrorState.h"
#import "BTUICardFormView.h"
#import "BTErrors.h"

@interface BTDropInErrorState ()
@property (nonatomic, strong) NSError *error;

@end

@implementation BTDropInErrorState

- (instancetype)initWithError:(__unused NSError *)error{
    self = [super init];
    if (self != nil) {
        self.error = error;
    }
    return self;
}

- (NSString *)errorTitle {
    return self.validationErrors[@"error"][@"message"];
}

- (NSDictionary *)validationErrors {
    return self.error.userInfo[BTCustomerInputBraintreeValidationErrorsKey];
}

- (NSSet *)highlightedFields{
    NSMutableSet *fieldsToHighlight = [[NSMutableSet alloc] init];
    NSArray *fieldErrors = self.validationErrors[@"fieldErrors"];

    NSArray *creditCardFieldErrors = @[];
    for (NSDictionary *fieldError in fieldErrors) {
        if ([fieldError[@"field"] isEqualToString:@"creditCard"]) {
            creditCardFieldErrors = fieldError[@"fieldErrors"];
            break;
        }
    }

    for (NSDictionary *creditCardFieldError in creditCardFieldErrors) {
        NSString *field = creditCardFieldError[@"field"];
        if([field isEqualToString:@"cvv"]){
            [fieldsToHighlight addObject:@(BTUICardFormFieldCvv)];
        } else if ([field isEqualToString:@"billingAddress"]) {
            for (NSDictionary *billingAddressFieldError in creditCardFieldError[@"fieldErrors"]) {
                NSString *billingAddressField = billingAddressFieldError[@"field"];
                if ([billingAddressField isEqualToString:@"postalCode"]) {
                    [fieldsToHighlight addObject:@(BTUICardFormFieldPostalCode)];
                }
            }
        } else if ([field isEqualToString:@"number"]) {
            [fieldsToHighlight addObject:@(BTUICardFormFieldNumber)];
        } else if ([field isEqualToString:@"expirationDate"] || [field isEqualToString:@"expirationMonth"] || [field isEqualToString:@"expirationYear"]) {
            [fieldsToHighlight addObject:@(BTUICardFormFieldExpiration)];
        }
    }
    return fieldsToHighlight;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<BTDropInErrorState:%p errorTitle:%@ highlightedFields:%@ >", self, self.errorTitle, self.highlightedFields];
}

@end
