#import <Braintree/BTUICardFormView.h>
#import "BTUICardType.h"
#import "BTUIFormField.h"
#import <KIF/KIF.h>
#import <KIF/UIAccessibilityElement-KIFAdditions.h>
#import <PureLayout/PureLayout.h>

@interface BTUICardFormViewSpecCardEntryViewController : UIViewController
@property (nonatomic, strong) BTUICardFormView *cardFormView;
@end

@implementation BTUICardFormViewSpecCardEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardFormView = [[BTUICardFormView alloc] initWithFrame:self.view.frame];

    [self.view addSubview:self.cardFormView];

    [self.cardFormView autoPinEdgeToSuperviewMargin:ALEdgeLeading];
    [self.cardFormView autoPinEdgeToSuperviewMargin:ALEdgeTrailing];
    [self.cardFormView autoPinToTopLayoutGuideOfViewController:self withInset:10];
}

@end

SpecBegin(BTUICardFormView)

describe(@"Card Form", ^{
    describe(@"accepting and validating credit card details", ^{
        it(@"accepts a number, an expiry, a cvv and a postal code", ^{
            BTUICardFormViewSpecCardEntryViewController *viewController = [[BTUICardFormViewSpecCardEntryViewController alloc] init];
            
            [system presentViewController:viewController];

            [[tester usingTimeout:1] enterText:@"4111111111111111" intoViewWithAccessibilityLabel:@"Card Number"];
            [[tester usingTimeout:1] tapViewWithAccessibilityLabel:@"MM/YY"];
            [[tester usingTimeout:1] enterTextIntoCurrentFirstResponder:@"122018"];
            [[tester usingTimeout:1] enterText:@"100" intoViewWithAccessibilityLabel:@"CVV"];
            [[tester usingTimeout:1] enterText:@"60606" intoViewWithAccessibilityLabel:@"Postal Code"];

            expect(viewController.cardFormView.valid).to.beTruthy();
        });
    });

    describe(@"auto advancing", ^{
        it(@"auto advances from field to field", ^{
            [system presentViewController:[[BTUICardFormViewSpecCardEntryViewController alloc] init]];
            [[tester usingTimeout:1] tapViewWithAccessibilityLabel:@"Card Number"];
            [[tester usingTimeout:1] enterTextIntoCurrentFirstResponder:@"4111111111111111"];
            [[tester usingTimeout:1] waitForFirstResponderWithAccessibilityLabel:@"MM/YY"];
        });
    });

    describe(@"retreat on backspace", ^{
        it(@"retreats on backspace and deletes one digit", ^{
            [system presentViewController:[[BTUICardFormViewSpecCardEntryViewController alloc] init]];
            [[tester usingTimeout:1] tapViewWithAccessibilityLabel:@"Card Number"];
            [[tester usingTimeout:1] enterTextIntoCurrentFirstResponder:@"4111111111111111"];
            [[tester usingTimeout:1] enterTextIntoCurrentFirstResponder:@"\b"];
            [[tester usingTimeout:1] waitForFirstResponderWithAccessibilityLabel:@"Card Number"];
            [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"Card Number" value:@"411111111111111" traits:0];
        });
    });

    describe(@"setting the form programmatically", ^{
        __block BTUICardFormView *cardFormView;

        beforeEach(^{
            cardFormView = [[BTUICardFormView alloc] init];
        });
        
        describe(@"card number field", ^{
            it(@"sets the field text", ^{
                cardFormView.number = @"411111";
                [system presentView:cardFormView];
                [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"Card Number" value:@"411111" traits:0];
            });

            describe(@"number of digits", ^{
                context(@"unknown card type", ^{
                    it(@"allows max digits", ^{
                        NSString *cardNumber = [@"" stringByPaddingToLength:[BTUICardType maxNumberLength] withString:@"0" startingAtIndex:0];
                        cardFormView.number = cardNumber;
                        [system presentView:cardFormView];
                        [[[tester usingTimeout:1] usingTimeout:1] waitForViewWithAccessibilityLabel:@"Card Number" value:cardNumber traits:0];
                    });

                    it(@"doesn't set field if max digits exceeded", ^{
                        cardFormView.number = @"1234";
                        cardFormView.number = [@"" stringByPaddingToLength:[BTUICardType maxNumberLength]+1 withString:@"0" startingAtIndex:0];;
                        [system presentView:cardFormView];
                        [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"Card Number" value:@"1234" traits:0];
                    });
                });

                context(@"known card type", ^{
                    it(@"allows max digits", ^{
                        cardFormView.number = @"4111111111111111";
                        [system presentView:cardFormView];
                        [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"Card Number" value:@"4111111111111111" traits:0];
                    });

                    it(@"doesn't set field if max digits exceeded", ^{
                        cardFormView.number = @"41111111111111111";
                        cardFormView.number = @"1234";
                        [system presentView:cardFormView];
                        [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"Card Number" value:@"1234" traits:0];
                    });
                });
            });

            it(@"doesn't allow invalid characters", ^{
                cardFormView.number = @"1234";
                cardFormView.number = @"4111 1111-1111";
                [system presentView:cardFormView];
                [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"Card Number" value:@"411111111111" traits:0];
            });
        });

        describe(@"expiry field", ^{
            it(@"accepts a date and displays as valid", ^{
                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.month = 1;
                dateComponents.year = 2016;
                dateComponents.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

                NSDate *date = [dateComponents date];
                [cardFormView setExpirationDate:date];
                [system presentView:cardFormView];
                [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"01/2016"];

                UIAccessibilityElement *element = [[[UIApplication sharedApplication] keyWindow] accessibilityElementWithLabel:@"01/2016"];
                BTUIFormField *expiryField = (BTUIFormField *)([UIAccessibilityElement viewContainingAccessibilityElement:element].superview.superview);
                expect(expiryField.displayAsValid).to.beTruthy();
            });

            it(@"accepts a well-formed invalid date and displays as invalid", ^{
                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.month = 2;
                dateComponents.year = 2000;
                dateComponents.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

                NSDate *date = [dateComponents date];
                [cardFormView setExpirationDate:date];
                [system presentView:cardFormView];
                [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"02/2000"];

                UIAccessibilityElement *element = [[[UIApplication sharedApplication] keyWindow] accessibilityElementWithLabel:@"02/2000"];
                BTUIFormField *expiryField = (BTUIFormField *)([UIAccessibilityElement viewContainingAccessibilityElement:element].superview.superview);
                expect(expiryField.displayAsValid).to.beFalsy();
            });

            it(@"can be set when visible", ^{
                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.month = 1;
                dateComponents.year = 2016;
                dateComponents.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDate *date = [dateComponents date];

                [system presentView:cardFormView];
                [cardFormView setExpirationDate:date];
                [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"01/2016"];
            });
        });

        describe(@"CVV field", ^{
            it(@"accepts a CVV number", ^{
                cardFormView.cvv = @"123";
                [system presentView:cardFormView];
                [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"123"];
            });

            it(@"doesn't set field if max digits exceeded", ^{
                cardFormView.cvv = @"543";
                cardFormView.cvv = @"12345";
                [system presentView:cardFormView];
                [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"543"];
            });
        });

        describe(@"Postal code field", ^{
            it(@"accepts a zipcode number", ^{
                cardFormView.postalCode = @"12345";
                [system presentView:cardFormView];
                [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"12345"];
            });

            it(@"accepts a postal code string", ^{
                cardFormView.postalCode = @"WC2E 9RZ";
                [system presentView:cardFormView];
                [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"WC2E 9RZ"];
            });

            it(@"won't accept an alphanumeric string if alphanumericPostalCode is NO", ^{
                cardFormView.postalCode = @"123";
                cardFormView.alphaNumericPostalCode = NO;
                cardFormView.postalCode = @"WC2E 9RZ";
                
                [system presentView:cardFormView];
                
                [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"123"];
            });
        });
    });
});

SpecEnd
