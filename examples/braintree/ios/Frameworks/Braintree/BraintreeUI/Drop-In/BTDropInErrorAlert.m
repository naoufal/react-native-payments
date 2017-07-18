#import "BTDropInErrorAlert.h"
#import "BTDropInLocalizedString.h"

@interface BTDropInErrorAlert () <UIAlertViewDelegate>

@property (nonatomic, copy, nullable) void (^dismissalHandler)();

@end

@implementation BTDropInErrorAlert

- (instancetype)initWithPresentingViewController:(UIViewController *)viewController
{
    if (self = [super init]) {
        _presentingViewController = viewController;
    }
    return self;
}


- (void)showWithDismissalHandler:(void (^)())dismissalHandler {
    NSString *localizedOK = BTDropInLocalizedString(ERROR_ALERT_OK_BUTTON_TEXT);
    NSString *localizedCancel = BTDropInLocalizedString(ERROR_ALERT_CANCEL_BUTTON_TEXT);
    self.dismissalHandler = dismissalHandler;

    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:self.retryBlock ? localizedCancel : localizedOK
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(__unused UIAlertAction *action) {
                                                              if (self.cancelBlock) {
                                                                  self.cancelBlock();
                                                              }
                                                              if (self.dismissalHandler) {
                                                                  self.dismissalHandler();
                                                              }
                                                          }]];
        if (self.retryBlock) {
            [alertController addAction:[UIAlertAction actionWithTitle:BTDropInLocalizedString(ERROR_ALERT_TRY_AGAIN_BUTTON_TEXT)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(__unused UIAlertAction *action) {
                if (self.retryBlock) {
                    self.retryBlock();
                }
                if (self.dismissalHandler) {
                    self.dismissalHandler();
                }
            }]];
        }

        [self.presentingViewController presentViewController:alertController animated:YES completion:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title
                                                            message:self.message
                                                           delegate:self
                                                  cancelButtonTitle:self.retryBlock ? localizedCancel : localizedOK
                                                  otherButtonTitles:nil];

        if (self.retryBlock) {
            NSString *localizedTryAgain = BTDropInLocalizedString(ERROR_ALERT_TRY_AGAIN_BUTTON_TEXT);
            [alertView addButtonWithTitle:localizedTryAgain];
        }
        
        [alertView show];
#pragma clang diagnostic pop
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)alertView:(__unused UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && self.cancelBlock) {
        self.cancelBlock();
    } else if (buttonIndex == 1 && self.retryBlock) {
        self.retryBlock();
    }
    self.dismissalHandler();
}
#pragma clang diagnostic pop

- (NSString *)title {
    return _title ?: BTDropInLocalizedString(ERROR_ALERT_CONNECTION_ERROR);
}

@end
