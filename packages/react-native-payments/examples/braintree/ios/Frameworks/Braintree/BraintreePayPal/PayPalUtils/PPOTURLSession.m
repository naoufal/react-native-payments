//
//  PPOTSimpleURLConnection.m
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPOTURLSession.h"

#import "PPOTMacros.h"
#import "PPOTPinnedCertificates.h"

#import "PPOTDevice.h"
#import "PPOTVersion.h"

#define STATUS_IS_FAIL(x) (x < 200 || x >= 300)

@interface PPOTURLSession () <NSURLSessionDelegate>

/// An optional array of pinned certificates, each an NSData instance
/// consisting of DER encoded x509 certificates
@property (nonatomic, nullable, strong) NSArray<NSData *> *pinnedCertificates;

@property (nonatomic, strong, readwrite) NSURLSession *session;
@property (nonatomic, strong, readwrite) NSURLSessionConfiguration *sessionConfig;

@end

@implementation PPOTURLSession

+ (PPOTURLSession *)session {
    return [PPOTURLSession sessionWithTimeoutIntervalForRequest:0];
}

+ (PPOTURLSession *)sessionWithTimeoutIntervalForRequest:(NSTimeInterval)timeoutIntervalForRequest {
    PPOTURLSession *session = [[PPOTURLSession alloc] initWithTimeoutIntervalForRequest:timeoutIntervalForRequest];
    return session;
}

- (nonnull instancetype)initWithTimeoutIntervalForRequest:(NSTimeInterval)timeoutIntervalForRequest {
    self = [super init];
    if (self) {
        self.sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        self.sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        self.sessionConfig.HTTPShouldUsePipelining = YES;
        self.sessionConfig.HTTPAdditionalHeaders = @{ @"User-Agent": [PPOTURLSession computeUserAgent] };
        if (timeoutIntervalForRequest > 0) {
            self.sessionConfig.timeoutIntervalForRequest = timeoutIntervalForRequest;
        }
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfig
                                                     delegate:self
                                                delegateQueue:nil];

        self.pinnedCertificates = [PPOTPinnedCertificates trustedCertificates];
    }

    return self;
}

- (void)sendRequest:(nonnull NSURLRequest *)request completionBlock:(nullable PPOTURLSessionCompletionBlock)completionBlock {
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                     completionBlock(data, (NSHTTPURLResponse *)response, error);
                                                 }];
    [task resume];
}

- (void)finishTasksAndInvalidate {
    [self.session finishTasksAndInvalidate];
}

+ (NSString *)computeUserAgent {
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *language = [currentLocale objectForKey:NSLocaleLanguageCode];

#ifdef DEBUG
    NSString *releaseMode = @"DEBUG";
#else
    NSString *releaseMode = @"RELEASE";
#endif

    // PayPalSDK/OneTouchCore-iOS 3.2.2-11-g8b1c0e3 (iPhone; CPU iPhone OS 8_4_1; en-US; iPhone (iPhone5,1); iPhone5,1; DEBUG)
    return [NSString stringWithFormat:@"PayPalSDK/OneTouchCore-iOS %@ (%@; CPU %@ %@; %@-%@; %@; %@; %@)",
            PayPalOTVersion(),
            [UIDevice currentDevice].model,
            [UIDevice currentDevice].systemName,
            [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"],
            language,
            countryCode,
            [PPOTDevice deviceName],
            [PPOTDevice hardwarePlatform],
            releaseMode
            ];
}


#pragma mark - NSURLSessionDelegate methods

- (NSArray *)pinnedCertificateData {
    NSMutableArray *pinnedCertificates = [NSMutableArray array];
    for (NSData *certificateData in self.pinnedCertificates) {
        [pinnedCertificates addObject:(__bridge_transfer id)SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData)];
    }
    return pinnedCertificates;
}

- (void)URLSession:(__unused NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSString *domain = challenge.protectionSpace.host;
        SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];

        NSArray *policies = @[(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
        SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
        SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)self.pinnedCertificateData);
        SecTrustResultType result;

        OSStatus errorCode = SecTrustEvaluate(serverTrust, &result);

        BOOL evaluatesAsTrusted = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
        if (errorCode == errSecSuccess && evaluatesAsTrusted) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, NULL);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, NULL);
    }
}

@end
