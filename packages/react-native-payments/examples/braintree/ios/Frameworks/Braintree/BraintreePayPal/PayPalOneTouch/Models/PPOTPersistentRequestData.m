//
//  PPOTPersistentRequestData.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTPersistentRequestData.h"
#import "PPOTOAuth2SwitchRequest.h"
#import "PPOTConfiguration.h"
#import "PPOTMacros.h"
#import "PPOTSimpleKeychain.h"

#define kPPOTCoderKeyRequestDataConfigurationRecipe   CARDIO_STR(@"configuration_recipe")
#define kPPOTCoderKeyRequestDataEnvironment           CARDIO_STR(@"environment")
#define kPPOTCoderKeyRequestDataClientID              CARDIO_STR(@"client_id")
#define kPPOTCoderKeyRequestDataDataDictionary        CARDIO_STR(@"data_dictionary")

#define kPPOTKeychainRequestSpecificData  CARDIO_STR(@"PayPal_OTC_RequestData")

@implementation PPOTPersistentRequestData

#pragma mark - initializer

- (instancetype)initWithConfigurationRecipe:(PPOTConfigurationRecipe *)configurationRecipe
                                withRequest:(PPOTSwitchRequest *)request {
    if ((self = [super init])) {
        _configurationRecipe = configurationRecipe;
        _environment = request.environment;
        _clientID = request.clientID;
        _requestData = [NSMutableDictionary dictionary];
        [request addDataToPersistentRequestDataDictionary:_requestData];
    }
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        _configurationRecipe = [aDecoder decodeObjectForKey:kPPOTCoderKeyRequestDataConfigurationRecipe];
        _environment = [aDecoder decodeObjectForKey:kPPOTCoderKeyRequestDataEnvironment];
        _clientID = [aDecoder decodeObjectForKey:kPPOTCoderKeyRequestDataClientID];
        _requestData = [aDecoder decodeObjectForKey:kPPOTCoderKeyRequestDataDataDictionary];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.configurationRecipe forKey:kPPOTCoderKeyRequestDataConfigurationRecipe];
    [aCoder encodeObject:self.environment forKey:kPPOTCoderKeyRequestDataEnvironment];
    [aCoder encodeObject:self.clientID forKey:kPPOTCoderKeyRequestDataClientID];
    [aCoder encodeObject:self.requestData forKey:kPPOTCoderKeyRequestDataDataDictionary];
}

#pragma mark - keychain

+ (PPOTPersistentRequestData *)fetch {
    return [PPOTSimpleKeychain unarchiveObjectWithDataForKey:kPPOTKeychainRequestSpecificData];
}

+ (void)storeWithConfigurationRecipe:(PPOTConfigurationRecipe *)configurationRecipe
                         withRequest:(PPOTSwitchRequest *)request {

    PPOTPersistentRequestData *persistentRequestData = [[PPOTPersistentRequestData alloc]
                                                        initWithConfigurationRecipe:configurationRecipe withRequest:request];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:persistentRequestData];
    [PPOTSimpleKeychain setData:data forKey:kPPOTKeychainRequestSpecificData];
}

+ (void)remove {
    [PPOTSimpleKeychain setData:nil forKey:kPPOTKeychainRequestSpecificData];
}

@end
