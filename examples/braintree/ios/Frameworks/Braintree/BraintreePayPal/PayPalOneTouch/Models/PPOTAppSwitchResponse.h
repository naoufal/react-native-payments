//
//  PPOTAppSwitchResponse.h
//  PayPalOneTouch
//
//  Copyright © 2014 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPOTAppSwitchUtil.h"

@class PPOTConfigurationRecipe;

@interface PPOTAppSwitchResponse : NSObject

/*!
 @brief info from the most recent request
*/
@property (nonatomic, readonly) NSString *encryptionKey;

@property (nonatomic, readonly) PPAppSwitchResponseAction action;

/*!
 @brief represents payment_code_type for version 3 for now
*/
@property (nonatomic, readonly) PPAppSwitchResponseType responseType;

@property (nonatomic, readonly) NSInteger version;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *accessToken;
/*!
 @brief represents payment_code in version 3 for now
*/
@property (nonatomic, readonly) NSString *authorizationCode;
@property (nonatomic, readonly) NSInteger expiresIn;
@property (nonatomic, readonly) NSArray *scope;
/*!
 @brief not sent yet
*/
@property (nonatomic, readonly) NSString *photoURL;

@property (nonatomic, readonly) NSDictionary *decodedPayload;
/*!
 @brief can contain debug_id and message
*/
@property (nonatomic, readonly) NSDictionary *error;
@property (nonatomic, readonly) NSString *environment;

/*!
 @brief version 0 and 2
*/
@property (nonatomic, readonly) NSString *webURL;

/*!
 @brief version 3
*/
@property (nonatomic, readonly) NSDate *timeStamp;
@property (nonatomic, readonly) NSString *msgID;

/*!
 @brief version 0
*/
- (instancetype)initWithHermesURL:(NSURL *)url environment:(NSString *)environment;

/*!
 @brief version 1, 2, 3
*/
- (instancetype)initWithEncodedURL:(NSURL *)url encryptionKey:(NSString *)encryptionKey;

- (BOOL)validResponse;


@end
