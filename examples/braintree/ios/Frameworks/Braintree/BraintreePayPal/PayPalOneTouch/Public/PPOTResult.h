//
//  PPOTResult.h
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, PPOTRequestTarget) {
    // No app switch will occur
    PPOTRequestTargetNone,
    // App switch to/from browser
    PPOTRequestTargetBrowser,
    // App switch to/from PayPal Consumer App
    PPOTRequestTargetOnDeviceApplication,
    // Response url was invalid; can't confirm source app's identity
    PPOTRequestTargetUnknown,
};

#define kPayPalOneTouchErrorDomain @"com.paypal.onetouch.error"

typedef NS_ENUM(NSInteger, PPOTErrorCode) {
    PPOTErrorCodeUnknown = -1000,
    PPOTErrorCodeParsingFailed = -1001,
    PPOTErrorCodeNoTargetAppFound = -1002,
    PPOTErrorCodeOpenURLFailed = -1003,
    PPOTErrorCodePersistedDataFetchFailed = -1004,
};

typedef NS_ENUM(NSInteger, PPOTResultType) {
    PPOTResultTypeError,
    PPOTResultTypeCancel,
    PPOTResultTypeSuccess,
};

/*!
 @brief The result of parsing the One Touch return URL
*/
@interface PPOTResult : NSObject

/*!
 @brief The status of the app switch
*/
@property (nonatomic, readonly, assign) PPOTResultType type;

/*!
 @brief When One Touch is successful, the response dictionary containing information that your server will need to process.
*/
@property (nullable, nonatomic, readonly, copy) NSDictionary *response;

/*!
 @brief When One Touch encounters an error, it is reported here. Otherwise this property will be `nil`.
*/
@property (nullable, nonatomic, readonly, copy) NSError *error;

/*!
 @brief The target app that is now switching back.
*/
@property (nonatomic, readonly, assign) PPOTRequestTarget target;

@end

