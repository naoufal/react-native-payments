//
//  PPOTCore.h
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

// Required Frameworks for the library. Additionally, make sure to set OTHER_LDFLAGS = -ObjC
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <Foundation/Foundation.h>
#import "PPOTResult.h"

/*!
 @brief Completion block for receiving the result of performing a request
*/
typedef void (^PPOTCompletionBlock)(PPOTResult * _Nonnull result);

@interface PPOTCore : NSObject

/*!
 @brief Check if the application is configured correctly to handle responses for One Touch flow.

 @param callbackURLScheme The URL scheme which the app has registered for One Touch responses.
 @return `YES` iff the application is correctly configured.
*/
+ (BOOL)doesApplicationSupportOneTouchCallbackURLScheme:(nonnull NSString *)callbackURLScheme;

/*!
 @brief  Check whether the PayPal Wallet app is installed on this device (iOS <= 8).

 @discussion Universal links are used in iOS >=9 so the check is not performed

 @return `YES` if the wallet app is installed
*/
+ (BOOL)isWalletAppInstalled;

/*!
 @brief Check whether the URL and source application are recognized and valid for One Touch.

 @discussion Usually called as a result of the `UIApplicationDelegate`'s
             `- (BOOL)application:openURL:sourceApplication:annotation:` method
             to determine if the URL is intended for the One Touch library.

 (To then actually process the URL, call `+ (void)parseOneTouchURL:completionBlock`.)

 @param url The URL of the app switch request
 @param sourceApplication The bundle ID of the source application

 @return `YES` iff the URL and sending app are both valid.
*/
+ (BOOL)canParseURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication;

/*!
 @brief Process a URL response.

 @param url The URL to process
 @param completionBlock completion block for receiving the result of performing a request
*/
+ (void)parseResponseURL:(nonnull NSURL *)url completionBlock:(nonnull PPOTCompletionBlock)completionBlock;

/*!
 @brief URLs to return control from the browser/wallet to the app containing the One Touch library.

 @discussion For payment processing, the client's server will first create a payment on the PayPal server.
             Creating that payment requires, among many other things, a `redirect_urls` object containing two strings:
             `return_url` and `cancel_url`.

 @note Both return values will be `nil` if [PPOTCore doesApplicationSupportOneTouchCallbackURLScheme:callbackURLScheme] is not true.

 @param callbackURLScheme The URL scheme which the app has registered for One Touch responses.
 @param returnURL A string containing the `return_url`.
 @param cancelURL A string containing the `cancel_url`.
*/
+ (void)redirectURLsForCallbackURLScheme:(nonnull NSString *)callbackURLScheme withReturnURL:(NSString * _Nonnull * _Nonnull)returnURL withCancelURL:(NSString * _Nonnull * _Nonnull)cancelURL;

/*!
 @brief The version of the SDK library in use. Version numbering follows http://semver.org/.

 @note Please be sure to include this library version in tech support requests.
*/
+ (nonnull NSString *)libraryVersion;

@end
