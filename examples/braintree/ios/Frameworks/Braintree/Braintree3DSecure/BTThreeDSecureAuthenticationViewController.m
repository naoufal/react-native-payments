#import "BTThreeDSecureAuthenticationViewController.h"
#import "BTThreeDSecureResponse.h"
#import "BTWebViewController.h"
#import "BTURLUtils.h"
#import "BTCardNonce_Internal.h"

@interface BTThreeDSecureAuthenticationViewController ()
@end

@implementation BTThreeDSecureAuthenticationViewController

- (instancetype)initWithLookupResult:(BTThreeDSecureLookupResult *)lookupResult {
    if (!lookupResult.requiresUserAuthentication) {
        return nil;
    }

    NSURLRequest *acsRequest = [self acsRequestForLookupResult:lookupResult];
    return [super initWithRequest:acsRequest];
}

- (instancetype)initWithRequest:(NSURLRequest *)request {
    return [self initWithRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(tappedCancel)];
}

- (NSURLRequest *)acsRequestForLookupResult:(BTThreeDSecureLookupResult *)lookupResult {
    NSMutableURLRequest *acsRequest = [NSMutableURLRequest requestWithURL:lookupResult.acsURL];
    [acsRequest setHTTPMethod:@"POST"];
    NSDictionary *fields = @{ @"PaReq": lookupResult.PAReq,
                              @"TermUrl": lookupResult.termURL,
                              @"MD": lookupResult.MD };
    [acsRequest setHTTPBody:[[BTURLUtils queryStringWithDictionary:fields] dataUsingEncoding:NSUTF8StringEncoding]];
    [acsRequest setAllHTTPHeaderFields:@{ @"Accept": @"text/html", @"Content-Type": @"application/x-www-form-urlencoded"}];
    return acsRequest;
}

- (void)didCompleteAuthentication:(BTThreeDSecureResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (response.success) {
            if ([self.delegate respondsToSelector:@selector(threeDSecureViewController:didAuthenticateCard:completion:)]) {
                [self.delegate threeDSecureViewController:self
                                      didAuthenticateCard:response.tokenizedCard
                                               completion:^(__unused BTThreeDSecureViewControllerCompletionStatus status) {
                                                   if ([self.delegate respondsToSelector:@selector(threeDSecureViewControllerDidFinish:)]) {
                                                       [self.delegate threeDSecureViewControllerDidFinish:self];
                                                   }
                                               }];
            }
        } else {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
            if (response.threeDSecureInfo) {
                userInfo[BTThreeDSecureInfoKey] = response.threeDSecureInfo;
            }
            if (response.errorMessage) {
                userInfo[NSLocalizedDescriptionKey] = response.errorMessage;
            }
            NSError *error = [NSError errorWithDomain:BTThreeDSecureErrorDomain
                                                 code:BTThreeDSecureErrorTypeFailedAuthentication
                                             userInfo:userInfo];
            if ([self.delegate respondsToSelector:@selector(threeDSecureViewController:didFailWithError:)]) {
                [self.delegate threeDSecureViewController:self didFailWithError:error];
            } else if ([self.delegate respondsToSelector:@selector(threeDSecureViewControllerDidFinish:)]) {
                [self.delegate threeDSecureViewControllerDidFinish:self];
            }
        }
    });
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeFormSubmitted && [request.URL.path rangeOfString:@"authentication_complete_frame"].location != NSNotFound) {
        
        NSString *jsonAuthResponse = [BTURLUtils dictionaryForQueryString:request.URL.query][@"auth_response"];
        BTJSON *authBody = [[BTJSON alloc] initWithValue:[NSJSONSerialization JSONObjectWithData:[jsonAuthResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL]];

        BTThreeDSecureResponse *authResponse = [[BTThreeDSecureResponse alloc] init];
        authResponse.success = [authBody[@"success"] isTrue];
        authResponse.threeDSecureInfo = [authBody[@"threeDSecureInfo"] asDictionary];
        authResponse.tokenizedCard = [BTThreeDSecureCardNonce cardNonceWithJSON:authBody[@"paymentMethod"]];
        authResponse.errorMessage = [authBody[@"error"][@"message"] asString];

        [self didCompleteAuthentication:authResponse];

        return NO;
    } else {
        return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102) {
        // Not a real error; occurs when we return NO from webView:shouldStartLoadWithRequest:navigationType:
        return;
    } else if ([error.domain isEqualToString:BTThreeDSecureErrorDomain]) {
        // Allow delegate to handle 3D Secure authentication errors
        [self.delegate threeDSecureViewController:self didFailWithError:error];
    } else {
        // Otherwise, allow the WebViewController to display the error to the user
        if ([self.delegate respondsToSelector:@selector(threeDSecureViewController:didPresentErrorToUserForURLRequest:)]) {
            [self.delegate threeDSecureViewController:self didPresentErrorToUserForURLRequest:webView.request];
        }
        [super webView:webView didFailLoadWithError:error];
    }
}

#pragma mark User Interaction

- (void)tappedCancel {
    if ([self.delegate respondsToSelector:@selector(threeDSecureViewControllerDidFinish:)]) {
        [self.delegate threeDSecureViewControllerDidFinish:self];
    }
}

@end
