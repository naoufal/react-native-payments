#import "BTWebViewController.h"
#import "BTThreeDSecureLocalizedString.h"

static NSString *BTWebViewControllerPopupOpenDummyURLScheme = @"com.braintreepayments.popup.open";
static NSString *BTWebViewControllerPopupCloseDummyURLScheme = @"com.braintreepayments.popup.close";

@protocol BTThreeDSecurePopupDelegate <NSObject>

- (void)popupWebViewViewControllerDidFinish:(BTWebViewController *)viewController;

@end

@interface BTWebViewController () <UIWebViewDelegate, BTThreeDSecurePopupDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, weak) id<BTThreeDSecurePopupDelegate> delegate;

@end

@implementation BTWebViewController

- (instancetype)initWithCoder:(__unused NSCoder *)decoder {
    @throw [[NSException alloc] initWithName:@"Invalid initializer" reason:@"Use designated initializer" userInfo:nil];
}

- (instancetype)initWithNibName:(__unused NSString *)nibName bundle:(__unused NSBundle *)nibBundle {
    @throw [[NSException alloc] initWithName:@"Invalid initializer" reason:@"Use designated initializer" userInfo:nil];
}

- (instancetype)initWithRequest:(NSURLRequest *)request {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.webView = [[UIWebView alloc] init];
        self.webView.accessibilityIdentifier = @"Web View";
        [self.webView loadRequest:request];
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request delegate:(id<BTThreeDSecurePopupDelegate>)delegate {
    self = [self initWithRequest:request];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)setDelegate:(id<BTThreeDSecurePopupDelegate>)delegate {
    _delegate = delegate;
    if (delegate) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:BTThreeDSecureLocalizedString(ERROR_ALERT_CANCEL_BUTTON_TEXT) style:UIBarButtonItemStyleDone target:self action:@selector(informDelegateDidFinish)];
    }
}

- (void)loadView {
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateNetworkActivityIndicatorForWebView:self.webView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    [self updateNetworkActivityIndicatorForWebView:self.webView];
}

- (void)updateNetworkActivityIndicatorForWebView:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:webView.isLoading];
}


#pragma mark Delegate Informers

- (void)informDelegateDidFinish {
    if ([self.delegate respondsToSelector:@selector(popupWebViewViewControllerDidFinish:)]) {
        [self.delegate popupWebViewViewControllerDidFinish:self];
    }
}


#pragma mark UIWebViewDelegate

- (BOOL)webView:(__unused UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(__unused UIWebViewNavigationType)navigationType {
    NSURL *requestURL = request.URL;
    if ([self isURLPopupOpenLink:requestURL]) {
        [self openPopupWithURLRequest:request];
        return NO;
    } else if ([self isURLPopupCloseLink:requestURL]) {
        [self informDelegateDidFinish];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self updateNetworkActivityIndicatorForWebView:webView];
    self.title = [self parseTitleFromWebView:webView];;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateNetworkActivityIndicatorForWebView:webView];
    [self prepareTargetLinks:webView];
    [self prepareWindowOpenAndClosePopupLinks:webView];
    self.title = [self parseTitleFromWebView:webView];
}

- (void)webView:(__unused UIWebView *)webView didFailLoadWithError:(__unused NSError *)error {
    if ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102) {
        // Not a real error; occurs when webView:shouldStartLoadWithRequest:navigationType: returns NO
        return;
    } else {
        if ([UIAlertController class]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.localizedDescription
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:BTThreeDSecureLocalizedString(ERROR_ALERT_OK_BUTTON_TEXT)
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(__unused UIAlertAction *action) {
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:BTThreeDSecureLocalizedString(ERROR_ALERT_OK_BUTTON_TEXT)
                              otherButtonTitles:nil] show];
#pragma clang diagnostic pop
        }
    }
}


#pragma mark Web View Inspection

- (NSString *)parseTitleFromWebView:(UIWebView *)webView {
    return [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


#pragma mark Web View Popup Links

- (void)prepareTargetLinks:(UIWebView *)webView {
    NSString *js = [NSString stringWithFormat:@"var as = document.getElementsByTagName('a');\
                    for (var i = 0; i < as.length; i++) {\
                    if (as[i]['target']) { as[i]['href'] = '%@+' + as[i]['href']; }\
                    }\
                    true;", BTWebViewControllerPopupOpenDummyURLScheme];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)prepareWindowOpenAndClosePopupLinks:(UIWebView *)webView {
    NSString *js = [NSString stringWithFormat:@"(function(window) {\
                    function FakeWindow () {\
                    var fakeWindow = {};\
                    for (key in window) {\
                    if (typeof window[key] == 'function') {\
                    fakeWindow[key] = function() { console.log(\"FakeWindow received method call: \", key); };\
                    }\
                    }\
                    return fakeWindow;\
                    }\
                    function absoluteUrl (relativeUrl) { var a = document.createElement('a'); a.href = relativeUrl; return a.href; }\
                    window.open = function (url) { window.location = '%@+' + absoluteUrl(url); return new FakeWindow(); };\
                    window.close = function () { window.location = '%@://'; };\
                    })(window)", BTWebViewControllerPopupOpenDummyURLScheme, BTWebViewControllerPopupCloseDummyURLScheme];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (BOOL)isURLPopupOpenLink:(NSURL *)URL {
    NSString *schemePrefix = [[URL.scheme componentsSeparatedByString:@"+"] firstObject];
    return [schemePrefix isEqualToString:BTWebViewControllerPopupOpenDummyURLScheme];
}

- (BOOL)isURLPopupCloseLink:(NSURL *)URL {
    NSString *schemePrefix = [[URL.scheme componentsSeparatedByString:@"+"] firstObject];
    return [schemePrefix isEqualToString:BTWebViewControllerPopupCloseDummyURLScheme];
}

- (NSURL *)extractPopupLinkURL:(NSURL *)URL {
    NSURLComponents *c = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    c.scheme = [[URL.scheme componentsSeparatedByString:@"+"] lastObject];
    
    return c.URL;
}

- (void)openPopupWithURLRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = request.mutableCopy;
    mutableRequest.URL = [self extractPopupLinkURL:request.URL];
    request = mutableRequest.copy;
    BTWebViewController *popup = [[BTWebViewController alloc] initWithRequest:request delegate:self];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:popup];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}


#pragma mark delegate

- (void)popupWebViewViewControllerDidFinish:(BTWebViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
