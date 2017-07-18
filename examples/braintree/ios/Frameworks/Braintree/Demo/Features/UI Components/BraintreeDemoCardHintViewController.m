#import "BraintreeDemoCardHintViewController.h"

#import "BTUICardHint.h"

@interface BraintreeDemoCardHintViewController ()
@property (weak, nonatomic) IBOutlet BTUICardHint *cardHintView;
@property (weak, nonatomic) IBOutlet BTUICardHint *smallCardHintView;
@end

@implementation BraintreeDemoCardHintViewController

- (IBAction)selectedCardType:(UISegmentedControl *)sender {
    BTUIPaymentOptionType type = BTUIPaymentOptionTypeUnknown;
    switch(sender.selectedSegmentIndex) {
        case 0:
            type = BTUIPaymentOptionTypeUnknown;
            break;
        case 1:
            type = BTUIPaymentOptionTypeVisa;
            break;
        case 2:
            type = BTUIPaymentOptionTypeMasterCard;
            break;
        case 3:
            type = BTUIPaymentOptionTypeAMEX;
            break;
        case 4:
            type = BTUIPaymentOptionTypeDiscover;
            break;
    }
    [self.cardHintView setCardType:type animated:YES];
    [self.smallCardHintView setCardType:type animated:YES];
}

- (IBAction)selectedHintMode:(UISegmentedControl *)sender {
    [self.cardHintView setDisplayMode:(sender.selectedSegmentIndex == 0 ? BTCardHintDisplayModeCardType : BTCardHintDisplayModeCVVHint) animated:YES];
    [self.smallCardHintView setDisplayMode:(sender.selectedSegmentIndex == 0 ? BTCardHintDisplayModeCardType : BTCardHintDisplayModeCVVHint) animated:YES];
}

@end
