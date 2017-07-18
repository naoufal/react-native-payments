//
//  PPOTPersistentRequestData.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPOTMacros.h"

#define kPPOTRequestDataDataDictionaryMsgIdKey        CARDIO_STR(@"msg_id")
#define kPPOTRequestDataDataDictionaryEncryptionKey   CARDIO_STR(@"encryption_key")
#define kPPOTRequestDataDataDictionaryHermesTokenKey  CARDIO_STR(@"hermes_token")
#define kPPOTRequestDataDataDictionaryEnvironmentKey  CARDIO_STR(@"environment")

@class PPOTSwitchRequest;
@class PPOTConfigurationRecipe;

@interface PPOTPersistentRequestData : NSObject <NSCoding>

@property (nonatomic, strong, readwrite) PPOTConfigurationRecipe *configurationRecipe;
@property (nonatomic, strong, readwrite) NSString *environment;
@property (nonatomic, strong, readwrite) NSString *clientID;
@property (nonatomic, strong, readwrite) NSMutableDictionary *requestData;

+ (PPOTPersistentRequestData *)fetch;
+ (void)storeWithConfigurationRecipe:(PPOTConfigurationRecipe *)configurationRecipe
                         withRequest:(PPOTSwitchRequest *)request;
+ (void)remove;

@end
