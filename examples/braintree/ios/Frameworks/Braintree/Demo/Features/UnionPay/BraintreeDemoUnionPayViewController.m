#import "BraintreeDemoUnionPayViewController.h"
#import <BraintreeUnionPay/BraintreeUnionPay.h>
#import "BTUICardFormView.h"

@interface BraintreeDemoUnionPayViewController () <BTUICardFormViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *cardNumberField;
@property (nonatomic, strong) IBOutlet UITextField *expirationMonthField;
@property (nonatomic, strong) IBOutlet UITextField *expirationYearField;
@property (nonatomic, strong) BTUICardFormView *cardForm;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *smsButton;
@property (nonatomic, strong) BTAPIClient *apiClient;
@property (nonatomic, strong) BTCardClient *cardClient;
@property (nonatomic, copy) NSString *lastCardNumber;

@end

@implementation BraintreeDemoUnionPayViewController


- (instancetype)initWithAuthorization:(NSString *)authorization {
    if (self = [super initWithAuthorization:authorization]) {
        _apiClient = [[BTAPIClient alloc] initWithAuthorization:authorization];
        _cardClient = [[BTCardClient alloc] initWithAPIClient:_apiClient];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"UnionPay";
    self.edgesForExtendedLayout = UIRectEdgeBottom;

    self.cardForm = [[BTUICardFormView alloc] init];
    self.cardForm.optionalFields = BTUICardFormOptionalFieldsCvv;
    self.cardForm.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardForm.delegate = self;
    [self.view addSubview:self.cardForm];

    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];

    self.smsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.smsButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.smsButton.hidden = YES;
    [self.smsButton setTitle:@"Send SMS" forState:UIControlStateNormal];
    [self.smsButton addTarget:self action:@selector(enroll:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.smsButton];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[cardForm]|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:@{@"cardForm" : self.cardForm}]];
    [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.submitButton
                               attribute:NSLayoutAttributeCenterX
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.view
                               attribute:NSLayoutAttributeCenterX
                               multiplier:1
                               constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.smsButton
                               attribute:NSLayoutAttributeCenterX
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.view
                               attribute:NSLayoutAttributeCenterX
                               multiplier:1
                               constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.cardForm
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.view
                               attribute:NSLayoutAttributeTop
                               multiplier:1
                               constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.cardForm
                               attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.smsButton
                               attribute:NSLayoutAttributeTop
                               multiplier:1
                               constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.smsButton
                               attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.submitButton
                               attribute:NSLayoutAttributeTop
                               multiplier:1
                               constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.submitButton
                               attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.view
                               attribute:NSLayoutAttributeBottom
                               multiplier:1
                               constant:0]];
}

#pragma mark - Actions

- (void)enroll:(__unused UIButton *)button {
    self.progressBlock(@"Enrolling card");

    BTCard *card = [[BTCard alloc] initWithNumber:self.cardForm.number expirationMonth:self.cardForm.expirationMonth expirationYear:self.cardForm.expirationYear cvv:self.cardForm.cvv];
//    card.shouldValidate = YES;
    BTCardRequest *request = [[BTCardRequest alloc] initWithCard:card];
    request.mobileCountryCode = @"62";
    request.mobilePhoneNumber = self.cardForm.phoneNumber;

    [self.cardClient enrollCard:request completion:^(NSString * _Nullable enrollmentID, BOOL smsCodeRequired, NSError * _Nullable error) {
        if (error) {
            NSMutableString *errorMessage = [NSMutableString stringWithFormat:@"Error enrolling card: %@", error.localizedDescription];
            if (error.localizedFailureReason) {
                [errorMessage appendString:[NSString stringWithFormat:@". %@", error.localizedFailureReason]];
            }
            self.progressBlock(errorMessage);
            return;
        }
        
        request.enrollmentID = enrollmentID;
        
        if (smsCodeRequired) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"SMS Auth Code" message:@"An authorization code has been sent to your mobile phone number. Please enter it here" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:nil];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction * _Nonnull action) {
                UITextField *codeTextField = [alertController.textFields firstObject];
                NSString *authCode = codeTextField.text;
                request.smsCode = authCode;
                
                self.progressBlock(@"Tokenizing card");
                
                [self.cardClient tokenizeCard:request options:nil completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
                    if (error) {
                        self.progressBlock([NSString stringWithFormat:@"Error tokenizing card: %@", error.localizedDescription]);
                        return;
                    }
                    
                    self.completionBlock(tokenizedCard);
                }];
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self.cardClient tokenizeCard:request options:nil completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
                if (error) {
                    NSMutableString *errorMessage = [NSMutableString stringWithFormat:@"Error tokenizing card: %@", error.localizedDescription];
                    if (error.localizedFailureReason) {
                        [errorMessage appendString:[NSString stringWithFormat:@". %@", error.localizedFailureReason]];
                    }
                    self.progressBlock(errorMessage);
                    return;
                }
                
                self.completionBlock(tokenizedCard);
            }];
        }
    }];
}

- (void)submit:(__unused UIButton *)button {
    self.progressBlock(@"Tokenizing card");

    BTCard *card = [[BTCard alloc] initWithNumber:self.cardForm.number expirationMonth:self.cardForm.expirationMonth expirationYear:self.cardForm.expirationYear cvv:self.cardForm.cvv];
    [self.cardClient tokenizeCard:card completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
        if (error) {
            self.progressBlock([NSString stringWithFormat:@"Error tokenizing card: %@", error.localizedDescription]);
            return;
        }

        self.completionBlock(tokenizedCard);
    }];
}

#pragma mark - Private methods

- (void)fetchCapabilities:(NSString *)cardNumber {
    [self.cardClient fetchCapabilities:cardNumber completion:^(BTCardCapabilities * _Nullable cardCapabilities, NSError * _Nullable error) {
        if (error) {
            self.progressBlock([NSString stringWithFormat:@"Error fetching capabilities: %@", error.localizedDescription]);
            return;
        }

        if (cardCapabilities.isSupported) {
            self.cardForm.optionalFields = self.cardForm.optionalFields | BTUICardFormOptionalFieldsPhoneNumber;
            self.smsButton.hidden = NO;
            self.submitButton.hidden = NO;
        } else {
            self.progressBlock([NSString stringWithFormat:@"This UnionPay card cannot be processed, please try another card."]);
            self.submitButton.hidden = YES;
        }

        if (cardCapabilities.isDebit) {
            NSLog(@"Debit card");
        } else {
            NSLog(@"Credit card");
        }
    }];
}

#pragma mark - BTUICardFormViewDelegate methods

- (void)cardFormViewDidEndEditing:(BTUICardFormView *)cardFormView {
    if (cardFormView.number &&
        ![cardFormView.number isEqualToString:self.lastCardNumber]) {
        [self fetchCapabilities:cardFormView.number];
        self.lastCardNumber = cardFormView.number;
    }
}

@end
