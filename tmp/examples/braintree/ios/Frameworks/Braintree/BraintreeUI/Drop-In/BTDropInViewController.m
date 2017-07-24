#import "BTAPIClient_Internal.h"
#import "BTCard.h"
#import "BTCardClient.h"
#import "BTCardRequest.h"
#import "BTDropInViewController_Internal.h"
#import "BTLogger_Internal.h"
#import "BTDropInErrorAlert.h"
#import "BTDropInErrorState.h"
#import "BTDropInLocalizedString.h"
#import "BTDropInSelectPaymentMethodViewController.h"
#import "BTDropInUtil.h"
#import "BTPaymentMethodNonceParser.h"
#import "BTTokenizationService.h"
#import "BTUICardFormView.h"
#import "BTUIScrollView.h"

@interface BTDropInViewController () <BTUIScrollViewScrollRectToVisibleDelegate, BTUICardFormViewDelegate, BTDropInViewControllerDelegate, BTDropInSelectPaymentMethodViewControllerDelegate, BTViewControllerPresentingDelegate>

@property (nonatomic, strong) BTUIScrollView *scrollView;
@property (nonatomic, assign) NSInteger selectedPaymentMethodNonceIndex;
@property (nonatomic, strong) UIBarButtonItem *submitBarButtonItem;

/// Whether currently visible.
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) NSTimeInterval visibleStartTime;

/// If YES, fetch and display payment methods on file, summary view, CTA control.
/// If NO, do not fetch payment methods, and just show UI to add a new method.
///
/// Defaults to `YES`.
@property (nonatomic, assign) BOOL fullForm;

@property (nonatomic, assign) BOOL cardEntryDidBegin;
@property (nonatomic, assign) BOOL cardEntryDidFocus;

@property (nonatomic, assign) BOOL originalCoinbaseStoreInVault;

/// Used to strongly retain any BTDropInErrorAlert instances in case UIViewAlert is used
@property (nonatomic, strong, nonnull) NSMutableSet *errorAlerts;

@end

@implementation BTDropInViewController

- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient {
    if (self = [super init]) {
        self.theme = [BTUI braintreeTheme];
        self.dropInContentView = [[BTDropInContentView alloc] init];
        self.dropInContentView.paymentButton.viewControllerPresentingDelegate = self;

        self.apiClient = [apiClient copyWithSource:apiClient.metadata.source integration:BTClientMetadataIntegrationDropIn];
        self.dropInContentView.paymentButton.apiClient = self.apiClient;

        __weak typeof(self) weakSelf = self;
        self.dropInContentView.paymentButton.completion = ^(BTPaymentMethodNonce *paymentMethodNonce, NSError *error) {
            [weakSelf paymentButtonDidCompleteTokenization:paymentMethodNonce fromViewController:weakSelf error:error];
        };

        self.dropInContentView.hidePaymentButton = !self.dropInContentView.paymentButton.hasAvailablePaymentMethod;

        self.selectedPaymentMethodNonceIndex = NSNotFound;
        self.dropInContentView.state = BTDropInContentViewStateActivity;
        self.fullForm = YES;

        self.errorAlerts = [NSMutableSet set];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor = self.theme.viewBackgroundColor;

    // Configure Subviews
    self.scrollView = [[BTUIScrollView alloc] init];
    self.scrollView.scrollRectToVisibleDelegate = self;
    self.scrollView.bounces = YES;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    self.dropInContentView.translatesAutoresizingMaskIntoConstraints = NO;

    self.dropInContentView.cardForm.delegate = self;
    self.dropInContentView.cardForm.alphaNumericPostalCode = YES;

    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {

        if (!self.delegate) {
            // Log integration error, as a delegate is required by this point
            [[BTLogger sharedLogger] critical:@"ERROR: Drop-in delegate not set"];
        }

        self.dropInContentView.hidePaymentButton = !self.dropInContentView.paymentButton.hasAvailablePaymentMethod;

        if (![self isAddPaymentMethodDropInViewController]) {
            [self fetchPaymentMethodsOnCompletion:^{}];
        }
        
        if (error) {
            BTDropInErrorAlert *errorAlert = [[BTDropInErrorAlert alloc] initWithPresentingViewController:self];
            errorAlert.title = error.localizedDescription ?: BTDropInLocalizedString(ERROR_ALERT_CONNECTION_ERROR);
            [self.errorAlerts addObject:errorAlert];
            [errorAlert showWithDismissalHandler:^{
                [self.errorAlerts removeObject:errorAlert];
            }];
        }

        NSArray <NSString *> *challenges = [configuration.json[@"challenges"] asStringArray];

        static NSString *cvvChallenge = @"cvv";
        static NSString *postalCodeChallenge = @"postal_code";

        BTUICardFormOptionalFields optionalFields;
        if ([challenges containsObject:cvvChallenge] && [challenges containsObject:postalCodeChallenge]) {
            optionalFields = BTUICardFormOptionalFieldsCvv | BTUICardFormFieldPostalCode;
        } else if ([challenges containsObject:cvvChallenge]) {
            optionalFields = BTUICardFormOptionalFieldsCvv;
        } else if ([challenges containsObject:postalCodeChallenge]) {
            optionalFields = BTUICardFormOptionalFieldsPostalCode;
        } else {
            optionalFields = BTUICardFormOptionalFieldsNone;
        }

        self.dropInContentView.cardForm.optionalFields = optionalFields;

        [self informDelegateDidLoad];
    }];

    [self.dropInContentView.changeSelectedPaymentMethodButton addTarget:self
                                                                 action:@selector(tappedChangePaymentMethod)
                                                       forControlEvents:UIControlEventTouchUpInside];

    [self.dropInContentView.ctaControl addTarget:self
                                          action:@selector(tappedSubmitForm)
                                forControlEvents:UIControlEventTouchUpInside];

    self.dropInContentView.cardFormSectionHeader.textColor = self.theme.sectionHeaderTextColor;
    self.dropInContentView.cardFormSectionHeader.font = self.theme.sectionHeaderFont;
    self.dropInContentView.cardFormSectionHeader.text = BTDropInLocalizedString(CARD_FORM_SECTION_HEADER);


    // Call the setters explicitly
    [self updateDropInContentViewFromPaymentRequest];

    [self.dropInContentView setNeedsUpdateConstraints];

    // Add Subviews
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.dropInContentView];

    // Add initial constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"scrollView": self.scrollView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"scrollView": self.scrollView}]];

    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.dropInContentView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1
                                                                 constant:0]];

    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dropInContentView]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"dropInContentView": self.dropInContentView}]];

    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dropInContentView]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"dropInContentView": self.dropInContentView}]];

    if (!self.fullForm) {
        self.dropInContentView.state = BTDropInContentViewStateForm;
    }

    [self updateValidity];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.visible = YES;
    self.visibleStartTime = [NSDate timeIntervalSinceReferenceDate];

    // Ensure dropInContentView is visible. See viewWillDisappear below
    self.dropInContentView.alpha = 1.0f;

    if (self.fullForm) {
        [self.apiClient sendAnalyticsEvent:@"dropin.ios.appear"];
    }
    [self.apiClient sendAnalyticsEvent:@"ios.dropin.appear.succeeded"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Quickly fade out the content view to prevent a jarring effect
    // as keyboard dimisses.
    [UIView animateWithDuration:self.theme.quickTransitionDuration animations:^{
        self.dropInContentView.alpha = 0.0f;
    }];
    if (self.fullForm) {
        [self.apiClient sendAnalyticsEvent:@"dropin.ios.disappear"];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.visible = NO;
}

#pragma mark - BTUIScrollViewScrollRectToVisibleDelegate implementation

// Delegate implementation to handle "custom" autoscrolling via the BTUIScrollView class
//
// Scroll priorities are:
// 1. Attempt to display the submit button, even if it means the card form title is not visible.
// 2. If that isn't possible, at least attempt to show the card form title.
// 3. If that fails, fail just do the default behavior (relevant in landscape).
//
// Some cleanup here could attempt to parameterize or make sane some of the magic number pixel nudging.
- (void)scrollView:(BTUIScrollView *)scrollView requestsScrollRectToVisible:(CGRect)rect animated:(BOOL)animated {

    CGRect targetRect = rect;

    CGRect desiredVisibleTopRect = [self.scrollView convertRect:self.dropInContentView.cardFormSectionHeader.frame fromView:self.dropInContentView];
    desiredVisibleTopRect.origin.y -= 7;
    CGRect desiredVisibleBottomRect;
    if (self.dropInContentView.ctaControl.hidden) {
        desiredVisibleBottomRect = desiredVisibleTopRect;
    } else {
        desiredVisibleBottomRect = [self.scrollView convertRect:self.dropInContentView.ctaControl.frame fromView:self.dropInContentView];
    }

    CGFloat visibleAreaHeight = self.scrollView.frame.size.height - self.scrollView.contentInset.bottom - self.scrollView.contentInset.top;

    CGRect weightedBottomRect = CGRectUnion(targetRect, desiredVisibleBottomRect);
    if (weightedBottomRect.size.height <= visibleAreaHeight) {
        targetRect = weightedBottomRect;
    }

    CGRect weightedTopRect = CGRectUnion(targetRect, desiredVisibleTopRect);

    if (weightedTopRect.size.height <= visibleAreaHeight) {
        targetRect = weightedTopRect;
        targetRect.size.height = MIN(visibleAreaHeight, CGRectGetMaxY(weightedBottomRect) - CGRectGetMinY(targetRect));
    }

    [scrollView defaultScrollRectToVisible:targetRect animated:animated];
}

#pragma mark - Keyboard behavior

- (void)keyboardWillHide:(__unused NSNotification *)inputViewNotification {
    UIEdgeInsets ei = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    [UIView animateWithDuration:self.theme.transitionDuration animations:^{
        self.scrollView.scrollIndicatorInsets = ei;
        self.scrollView.contentInset = ei;
    }];
}

- (void)keyboardWillShow:(__unused NSNotification *)inputViewNotification {
    CGRect inputViewFrame = [[[inputViewNotification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect inputViewFrameInView = [self.view convertRect:inputViewFrame fromView:nil];
    CGRect intersection = CGRectIntersection(self.scrollView.frame, inputViewFrameInView);
    UIEdgeInsets ei = UIEdgeInsetsMake(0.0, 0.0, intersection.size.height, 0.0);
    self.scrollView.scrollIndicatorInsets = ei;
    self.scrollView.contentInset = ei;
}

#pragma mark - Handlers

- (void)tappedChangePaymentMethod {
    UIViewController *rootViewController;
    if (self.paymentMethodNonces.count == 1) {
        rootViewController = self.addPaymentMethodDropInViewController;
    } else {
        BTDropInSelectPaymentMethodViewController *selectPaymentMethod = [[BTDropInSelectPaymentMethodViewController alloc] init];
        selectPaymentMethod.title = BTDropInLocalizedString(SELECT_PAYMENT_METHOD_TITLE);
        selectPaymentMethod.theme = self.theme;
        selectPaymentMethod.paymentMethodNonces = self.paymentMethodNonces;
        selectPaymentMethod.selectedPaymentMethodIndex = self.selectedPaymentMethodNonceIndex;
        selectPaymentMethod.delegate = self;
        selectPaymentMethod.client = self.apiClient;
        rootViewController = selectPaymentMethod;
    }
    rootViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                        target:self
                                                                                                        action:@selector(didCancelChangePaymentMethod)];

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)tappedSubmitForm {
    [self showLoadingState:YES];

    BTPaymentMethodNonce *paymentInfo = [self selectedPaymentMethod];
    if (paymentInfo != nil) {
        [self showLoadingState:NO];
        [self informDelegateWillComplete];
        [self informDelegateDidAddPaymentInfo:paymentInfo];
    } else if (!self.dropInContentView.cardForm.hidden) {
        BTUICardFormView *cardForm = self.dropInContentView.cardForm;

        if (cardForm.valid) {
            [self informDelegateWillComplete];

            BTCard *card = [[BTCard alloc] initWithNumber:cardForm.number expirationMonth:cardForm.expirationMonth expirationYear:cardForm.expirationYear cvv:cardForm.cvv];
            card.postalCode = cardForm.postalCode;
            card.shouldValidate = self.apiClient.tokenizationKey ? NO : YES;
            BTCardRequest *request = [[BTCardRequest alloc] initWithCard:card];
            BTAPIClient *copiedAPIClient = [self.apiClient copyWithSource:BTClientMetadataSourceForm integration:BTClientMetadataIntegrationDropIn];
            BTCardClient *cardClient = [[BTCardClient alloc] initWithAPIClient:copiedAPIClient];
            
            [cardClient tokenizeCard:request options:nil completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
                [self showLoadingState:NO];

                if (error) {
                    if ([error.domain isEqualToString:@"com.braintreepayments.BTCardClientErrorDomain"] && error.code == BTCardClientErrorTypeCustomerInputInvalid) {
                        [self informUserDidFailWithError:error];
                    } else {
                        BTDropInErrorAlert *errorAlert = [[BTDropInErrorAlert alloc] initWithPresentingViewController:self];
                        errorAlert.title = BTDropInLocalizedString(ERROR_SAVING_CARD_ALERT_TITLE);
                        errorAlert.message = error.localizedDescription;
                        __weak typeof(self) weakSelf = self;
                        errorAlert.cancelBlock = ^{
                            // Use the paymentMethodNonces setter to update state
                            weakSelf.paymentMethodNonces = weakSelf.paymentMethodNonces;
                        };
                        [self.errorAlerts addObject:errorAlert];
                        [errorAlert showWithDismissalHandler:^{
                            [self.errorAlerts removeObject:errorAlert];
                        }];
                    }
                    return;
                }

                [self informDelegateDidAddPaymentInfo:tokenizedCard];
            }];
        } else {
            BTDropInErrorAlert *errorAlert = [[BTDropInErrorAlert alloc] initWithPresentingViewController:self];
            errorAlert.title = BTDropInLocalizedString(ERROR_SAVING_CARD_ALERT_TITLE);
            errorAlert.message = BTDropInLocalizedString(ERROR_SAVING_CARD_MESSAGE);
            [self.errorAlerts addObject:errorAlert];
            [errorAlert showWithDismissalHandler:^{
                [self.errorAlerts removeObject:errorAlert];
            }];
        }
    }
}

- (void)didCancelChangePaymentMethod {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Progress UI

- (void)cardFormViewDidBeginEditing:(__unused BTUICardFormView *)cardFormView {
    if (!self.cardEntryDidFocus) {
        [self.apiClient sendAnalyticsEvent:@"ios.dropin.card.focus"];
        self.cardEntryDidFocus = YES;
    }
}


- (void)showLoadingState:(BOOL)loadingState {
    [self.dropInContentView.ctaControl showLoadingState:loadingState];
    self.submitBarButtonItem.enabled = !loadingState;
    if (self.submitBarButtonItem != nil) {
        [BTUI activityIndicatorViewStyleForBarTintColor:self.navigationController.navigationBar.barTintColor];
        UIActivityIndicatorView *submitInProgressActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [submitInProgressActivityIndicator startAnimating];
        UIBarButtonItem *submitInProgressActivityIndicatorBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitInProgressActivityIndicator];
        [self.navigationItem setRightBarButtonItem:(loadingState ? submitInProgressActivityIndicatorBarButtonItem : self.submitBarButtonItem) animated:YES];
    }
}

#pragma mark Error UI

- (void)informUserDidFailWithError:(__unused NSError *)error {
    BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];

    [self.dropInContentView.cardForm showTopLevelError:state.errorTitle];
    for (NSNumber *fieldNumber in state.highlightedFields) {
        BTUICardFormField field = [fieldNumber unsignedIntegerValue];
        [self.dropInContentView.cardForm showErrorForField:field];
    }
}

#pragma mark Card Form Delegate methods

- (void)cardFormViewDidChange:(__unused BTUICardFormView *)cardFormView {

    if (!self.cardEntryDidBegin) {
        [self.apiClient sendAnalyticsEvent:@"dropin.ios.add-card.start"];
        self.cardEntryDidBegin = YES;
    }

    [self updateValidity];
}

#pragma mark Drop In Select Payment Method Table View Controller Delegate methods

- (void)selectPaymentMethodViewController:(BTDropInSelectPaymentMethodViewController *)viewController
            didSelectPaymentMethodAtIndex:(NSUInteger)index {
    self.selectedPaymentMethodNonceIndex = index;
    [viewController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectPaymentMethodViewControllerDidRequestNew:(BTDropInSelectPaymentMethodViewController *)viewController {
    [viewController.navigationController pushViewController:self.addPaymentMethodDropInViewController animated:YES];
}

#pragma mark BTDropInViewControllerDelegate implementation

- (void)dropInViewController:(BTDropInViewController *)viewController didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    [viewController.navigationController dismissViewControllerAnimated:YES completion:nil];

    NSMutableArray *newPaymentMethodNonces = [NSMutableArray arrayWithArray:self.paymentMethodNonces];
    [newPaymentMethodNonces insertObject:paymentMethodNonce atIndex:0];
    self.paymentMethodNonces = newPaymentMethodNonces;
}

- (void)dropInViewControllerDidCancel:(BTDropInViewController *)viewController {
    [viewController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark BTAppSwitchDelegate

- (void)paymentDriverWillPerformAppSwitch:(__unused id)sender {
    // If there is a presented view controller, dismiss it before app switch
    // so that the result of the app switch can be shown in this view controller.
    if ([self presentedViewController]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark Delegate Notifications

- (void)informDelegateDidLoad {
    if ([self.delegate respondsToSelector:@selector(dropInViewControllerDidLoad:)]) {
        [self.delegate dropInViewControllerDidLoad:self];
    }
}

- (void)informDelegateWillComplete {
    if ([self.delegate respondsToSelector:@selector(dropInViewControllerWillComplete:)]) {
        [self.delegate dropInViewControllerWillComplete:self];
    }
}

- (void)informDelegateDidAddPaymentInfo:(BTPaymentMethodNonce *)paymentMethodNonce {
    if ([self.delegate respondsToSelector:@selector(dropInViewController:didSucceedWithTokenization:)]) {
        [self.delegate dropInViewController:self
                didSucceedWithTokenization:paymentMethodNonce];
    }
}

- (void)informDelegateDidCancel {
    if ([self.delegate respondsToSelector:@selector(dropInViewControllerDidCancel:)]) {
        [self.delegate dropInViewControllerDidCancel:self];
    }
}

#pragma mark User Supplied Parameters

- (void)setFullForm:(BOOL)fullForm {
    _fullForm = fullForm;
    if (!self.fullForm) {
        self.dropInContentView.state = BTDropInContentViewStateForm;
    }
}

- (void)setShouldHideCallToAction:(BOOL)shouldHideCallToAction {
    self.dropInContentView.hideCTA = shouldHideCallToAction;

    self.submitBarButtonItem = shouldHideCallToAction ? [[UIBarButtonItem alloc]
                                                         initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                         target:self
                                                         action:@selector(tappedSubmitForm)] : nil;
    self.submitBarButtonItem.style = UIBarButtonItemStyleDone;
    self.navigationItem.rightBarButtonItem = self.submitBarButtonItem;
}

- (void)setSummaryTitle:(NSString *)summaryTitle {
    self.dropInContentView.summaryView.slug = summaryTitle;
    self.dropInContentView.hideSummary = (summaryTitle == nil || self.dropInContentView.summaryView.summary == nil);
}

- (void)setSummaryDescription:(NSString *)summaryDescription {
    self.dropInContentView.summaryView.summary = summaryDescription;
    self.dropInContentView.hideSummary = (self.dropInContentView.summaryView.slug == nil || summaryDescription == nil);
}

- (void)setDisplayAmount:(NSString *)displayAmount {
    self.dropInContentView.summaryView.amount = displayAmount;
}

- (void)setCallToActionText:(NSString *)callToActionText {
    self.dropInContentView.ctaControl.callToAction = callToActionText;
}

- (void)setCardNumber:(NSString *)cardNumber {
    self.dropInContentView.cardForm.number = cardNumber;
}

- (void)setCardExpirationMonth:(NSInteger)expirationMonth year:(NSInteger)expirationYear {
    [self.dropInContentView.cardForm setExpirationMonth:expirationMonth year:expirationYear];
}

#pragma mark Data

- (void)setPaymentMethodNonces:(NSArray *)paymentMethodNonces {
    _paymentMethodNonces = paymentMethodNonces;
    BTDropInContentViewStateType newState;

    if ([self.paymentMethodNonces count] == 0) {
        self.selectedPaymentMethodNonceIndex = NSNotFound;
        newState = BTDropInContentViewStateForm;
    } else {
        self.selectedPaymentMethodNonceIndex = 0;
        newState = BTDropInContentViewStatePaymentMethodsOnFile;
    }
    if (self.visible) {
        NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - self.visibleStartTime;
        if (elapsed < self.theme.minimumVisibilityTime) {
            NSTimeInterval delay = self.theme.minimumVisibilityTime - elapsed;

            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.dropInContentView setState:newState animate:YES completion:^{
                    [weakSelf updateValidity];
                }];
            });
            return;
        }
    }
    [self.dropInContentView setState:newState animate:self.visible];
    [self updateValidity];
}

- (void)setSelectedPaymentMethodNonceIndex:(NSInteger)selectedPaymentMethodNonceIndex {
    _selectedPaymentMethodNonceIndex = selectedPaymentMethodNonceIndex;
    if (_selectedPaymentMethodNonceIndex != NSNotFound) {
        BTPaymentMethodNonce *defaultPaymentMethod = [self selectedPaymentMethod];
        BTUIPaymentOptionType paymentMethodType = [BTUI paymentOptionTypeForPaymentInfoType:defaultPaymentMethod.type];
        self.dropInContentView.selectedPaymentMethodView.type = paymentMethodType;
        self.dropInContentView.selectedPaymentMethodView.detailDescription = defaultPaymentMethod.localizedDescription;
    }
    [self updateValidity];
}

- (BTPaymentMethodNonce *)selectedPaymentMethod {
    return self.selectedPaymentMethodNonceIndex != NSNotFound ? self.paymentMethodNonces[self.selectedPaymentMethodNonceIndex] : nil;
}

- (void)updateValidity {
    BTPaymentMethodNonce *paymentMethod = [self selectedPaymentMethod];
    BOOL valid = (paymentMethod != nil) || (!self.dropInContentView.cardForm.hidden && self.dropInContentView.cardForm.valid);

    [self.navigationItem.rightBarButtonItem setEnabled:valid];
    [UIView animateWithDuration:self.theme.quickTransitionDuration animations:^{
        self.dropInContentView.ctaControl.enabled = valid;
        self.dropInContentView.paymentButton.alpha = valid ? 0.3 : 1.0;
    }];
}

- (void)fetchPaymentMethodsOnCompletion:(void(^)())completionBlock {
    // Check for proper authorization before fetching payment methods to suppress errors when using tokenization key
    if (!self.apiClient.clientToken) {
        self.paymentMethodNonces = @[];
        if (completionBlock) {
            completionBlock();
        }
        return;
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self.apiClient fetchPaymentMethodNonces:self.paymentRequest.showDefaultPaymentMethodNonceFirst completion:^(NSArray<BTPaymentMethodNonce *> *paymentMethodNonces, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        if (error) {
            BTDropInErrorAlert *errorAlert = [[BTDropInErrorAlert alloc] initWithPresentingViewController:self];
            errorAlert.title = error.localizedDescription;
            BTJSON *errorBody = error.userInfo[BTHTTPJSONResponseBodyKey];
            errorAlert.message = [errorBody[@"error"][@"message"] asString];
            errorAlert.cancelBlock = ^{
                [self informDelegateDidCancel];
                if (completionBlock) completionBlock();
            };
            errorAlert.retryBlock = ^{
                [self fetchPaymentMethodsOnCompletion:completionBlock];
            };
            [self.errorAlerts addObject:errorAlert];
            [errorAlert showWithDismissalHandler:^{
                [self.errorAlerts removeObject:errorAlert];
            }];
        } else {
            self.paymentMethodNonces = [paymentMethodNonces copy];
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

#pragma mark - BTPaymentRequest

@synthesize paymentRequest = _paymentRequest;

- (BTPaymentRequest *)paymentRequest {
    if (!_paymentRequest) {
        _paymentRequest = [[BTPaymentRequest alloc] init];
    }
    return _paymentRequest;
}

- (void)setPaymentRequest:(BTPaymentRequest *)paymentRequest {
    _paymentRequest = paymentRequest;
    [self updateDropInContentViewFromPaymentRequest];
}

- (void)updateDropInContentViewFromPaymentRequest {
    self.dropInContentView.paymentButton.paymentRequest = self.paymentRequest;
    [self setShouldHideCallToAction:self.paymentRequest.shouldHideCallToAction];
    [self setSummaryTitle:self.paymentRequest.summaryTitle];
    [self setSummaryDescription:self.paymentRequest.summaryDescription];
    [self setDisplayAmount:self.paymentRequest.displayAmount];
    [self setCallToActionText:self.paymentRequest.callToActionText];
}

#pragma mark - Helpers

- (BTDropInViewController *)addPaymentMethodDropInViewController {
    BTDropInViewController *addPaymentMethodDropInViewController = [[BTDropInViewController alloc] initWithAPIClient:self.apiClient];

    addPaymentMethodDropInViewController.title = BTDropInLocalizedString(ADD_PAYMENT_METHOD_VIEW_CONTROLLER_TITLE);
    addPaymentMethodDropInViewController.fullForm = NO;

    BTPaymentRequest *paymentRequest = [BTPaymentRequest new];
    paymentRequest.shouldHideCallToAction = YES;
    addPaymentMethodDropInViewController.paymentRequest = paymentRequest;

    addPaymentMethodDropInViewController.delegate = self;

    __weak typeof(self) weakSelf = self;
    __weak typeof(addPaymentMethodDropInViewController) weakAddPaymentMethodController = addPaymentMethodDropInViewController;
    addPaymentMethodDropInViewController.dropInContentView.paymentButton.completion = ^(BTPaymentMethodNonce *paymentMethodNonce, NSError *error) {
        [weakSelf paymentButtonDidCompleteTokenization:paymentMethodNonce fromViewController:weakAddPaymentMethodController error:error];
    };

    return addPaymentMethodDropInViewController;
}

- (void)paymentButtonDidCompleteTokenization:(BTPaymentMethodNonce *)paymentMethodNonce
                          fromViewController:(UIViewController *)viewController
                                       error:(NSError *)error {
    if (error) {
        NSString *savePaymentMethodErrorAlertTitle = error.localizedDescription ?: BTDropInLocalizedString(ERROR_ALERT_CONNECTION_ERROR);
        
        BTDropInErrorAlert *errorAlert = [[BTDropInErrorAlert alloc] initWithPresentingViewController:viewController];
        errorAlert.title = savePaymentMethodErrorAlertTitle;
        errorAlert.message = error.localizedFailureReason;
        errorAlert.cancelBlock = ^{
            // Use the paymentMethodNonces setter to update state
            self.paymentMethodNonces = self.paymentMethodNonces;
        };

        [self.errorAlerts addObject:errorAlert];
        [errorAlert showWithDismissalHandler:^{
            [self.errorAlerts removeObject:errorAlert];
        }];
    } else if (paymentMethodNonce) {
        NSMutableArray *newPaymentMethods = [NSMutableArray arrayWithArray:self.paymentMethodNonces];
        [newPaymentMethods insertObject:paymentMethodNonce atIndex:0];
        self.paymentMethodNonces = newPaymentMethods;
        [self informDelegateDidAddPaymentInfo:paymentMethodNonce];
    } else {
        // Refresh payment methods display
        self.paymentMethodNonces = self.paymentMethodNonces;
    }
}

- (BOOL)isAddPaymentMethodDropInViewController {
    return [self.delegate isKindOfClass:[BTDropInViewController class]];
}

#pragma mark - BTViewControllerPresentingDelegate

- (void)paymentDriver:(__unused id)driver requestsPresentationOfViewController:(UIViewController *)viewController {
    UIViewController *presentingViewController = self.paymentRequest.presentViewControllersFromTop? [BTDropInUtil topViewController] : self;
    [presentingViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)paymentDriver:(__unused id)driver requestsDismissalOfViewController:(__unused UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
