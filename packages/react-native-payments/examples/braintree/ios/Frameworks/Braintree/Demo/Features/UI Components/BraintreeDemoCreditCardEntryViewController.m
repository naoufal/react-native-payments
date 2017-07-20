#import "BraintreeDemoCreditCardEntryViewController.h"
#import <CardIO/CardIO.h>

@interface BraintreeDemoCreditCardEntryViewController ()<BTUICardFormViewDelegate, CardIOPaymentViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *successOutputTextView;

@end

@implementation BraintreeDemoCreditCardEntryViewController

- (void)cardFormViewDidChange:(BTUICardFormView *)cardFormView {
    if (cardFormView.valid) {
        self.successOutputTextView.text = [NSString stringWithFormat:
                                           @"😍 YOU DID IT \n"
                                            "Number:     %@\n"
                                            "Expiration: %@/%@\n"
                                            "CVV:        %@\n"
                                            "Postal:     %@",
                                           cardFormView.number,
                                           cardFormView.expirationMonth,
                                           cardFormView.expirationYear,
                                           cardFormView.cvv,
                                           cardFormView.postalCode];
    } else {
        self.successOutputTextView.text = @"INVALID 🐴";
    }
}
- (IBAction)toggleCVV:(__unused id)sender {
    self.cardFormView.optionalFields = self.cardFormView.optionalFields ^ BTUICardFormOptionalFieldsCvv;
}
- (IBAction)togglePostalCode:(__unused id)sender {
    self.cardFormView.optionalFields = self.cardFormView.optionalFields ^ BTUICardFormOptionalFieldsPostalCode;
}
- (IBAction)toggleVibrate:(UISwitch *)sender {
    self.cardFormView.vibrate = sender.on;
}

#pragma mark card.io

- (IBAction)cardIoPressed:(__unused id)sender {
    if (![CardIOUtilities canReadCardWithCamera]) {
        // Hide your "Scan Card" button, or take other appropriate action...
        NSLog(@"can NOT read card with camera");

        [self addCardFormWithInfo:nil];
    } else {
        CardIOPaymentViewController *v = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];

        [self presentViewController:v
                           animated:YES
                         completion:nil];
    }
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", cardInfo.redactedCardNumber, (unsigned long)cardInfo.expiryMonth, (unsigned long)cardInfo.expiryYear, cardInfo.cvv);
    // Use the card info...

    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        [self addCardFormWithInfo:cardInfo];
    }];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES
                                              completion:nil];
}

- (void)addCardFormWithInfo:(CardIOCreditCardInfo *)info {
    BTUICardFormView *cardForm = self.cardFormView;

    if (info) {
        cardForm.number = info.cardNumber;

        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = info.expiryMonth;
        dateComponents.year = info.expiryYear;
        dateComponents.calendar = [NSCalendar calendarWithIdentifier:NSGregorianCalendar];

        [cardForm setExpirationDate:dateComponents.date];
        [cardForm setCvv:info.cvv];
        [cardForm setPostalCode:info.postalCode];
    } else {
        cardForm.number = @"4111111111111111";
        [cardForm setExpirationDate:[NSDate date]];
        [cardForm setCvv:@"123"];
        [cardForm setPostalCode:@"60606"];
    }

    [self.view addSubview:cardForm];
}

@end
