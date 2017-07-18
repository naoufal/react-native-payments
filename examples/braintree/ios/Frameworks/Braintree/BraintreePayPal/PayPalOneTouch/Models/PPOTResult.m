//
//  PPOTResult.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPOTResult_Internal.h"
#import "PPOTCore_Internal.h"
#import "PPOTAppSwitchResponse.h"
#import "PPOTConfiguration.h"
#import "PPOTDevice.h"
#import "PPOTError.h"
#import "PPOTMacros.h"
#import "PPOTAnalyticsTracker.h"
#import "PPOTVersion.h"
#import "PPOTPersistentRequestData.h"
#import "PPOTAnalyticsDefines.h"

#define PP_TIMESTAMP_TIMEOUT 10*60 // 10 minutes

@implementation PPOTResult

+ (void)parseURL:(NSURL *)url completionBlock:(PPOTCompletionBlock)completionBlock {
    PPAssert(completionBlock, @"parseURL:completionBlock: completionBlock is required");
    PPOTResult *result = nil;
    PPOTPersistentRequestData *persistentRequestData = [PPOTPersistentRequestData fetch];

    NSString *analyticsPage = kAnalyticsAppSwitchCancel;
    NSError *analyticsError = nil;

    BOOL valid = [PPOTCore isValidURLAction:url];
    if (valid) {
        PPOTConfigurationRecipe *configurationRecipe = persistentRequestData.configurationRecipe;
        PPOTAppSwitchResponse *response = nil;

        if ([configurationRecipe.protocolVersion integerValue] == 0) {
            // Note: Token (Hermes) validation performed inside of isValidURLAction:
            // TODO: consider moving here
            response = [[PPOTAppSwitchResponse alloc] initWithHermesURL:url
                                                            environment:persistentRequestData.requestData[kPPOTRequestDataDataDictionaryEnvironmentKey]];
        } else {
            NSString *encryptionKey = persistentRequestData.requestData[kPPOTRequestDataDataDictionaryEncryptionKey];
            response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:url encryptionKey:encryptionKey];

            // TODO: make better
            if (response.validResponse && response.version > 2) {
                NSString *requestMsgID = persistentRequestData.requestData[kPPOTRequestDataDataDictionaryMsgIdKey];
                NSNumber *protocol = configurationRecipe.protocolVersion;

                if (response.version != [protocol integerValue]) {
                    valid = NO;
                }

                if (![requestMsgID isEqualToString:response.msgID]) {
                    if (requestMsgID != nil || response.msgID != nil) {
                        valid = NO;
                    }
                }

                if (valid &&
                    [[response.timeStamp dateByAddingTimeInterval:PP_TIMESTAMP_TIMEOUT]
                     compare:[NSDate date]] == NSOrderedAscending) {
                        valid = NO;
                    }
            }
        }

        if (valid && response.validResponse && response.action == PPAppSwitchResponseActionSuccess) {
            result = [self resultWithSuccess:response];
            analyticsPage = kAnalyticsAppSwitchReturn;
        } else if (response.action == PPAppSwitchResponseActionCancel) {
            result = [self resultWithCancel:response];
        } else {
            result = [self resultWithError];
            analyticsError = result.error;
        }

        result.target = configurationRecipe.target;
    } else {
        if (!persistentRequestData) {
            result = [self resultWithPersistedRequestDataFetchError];
        } else {
            result = [self resultWithError];
        }
        result.target = PPOTRequestTargetUnknown;
        analyticsError = result.error;
    }

    // Protect parameters against missing persistentRequestData:
    [[PPOTAnalyticsTracker sharedManager] trackPage:analyticsPage
                                        environment:persistentRequestData.environment ? persistentRequestData.environment : @""
                                           clientID:persistentRequestData.clientID ? persistentRequestData.clientID : @""
                                              error:analyticsError
                                        hermesToken:persistentRequestData.requestData[kPPOTRequestDataDataDictionaryHermesTokenKey]];

    completionBlock(result);
}

+ (PPOTResult *)resultWithSuccess:(PPOTAppSwitchResponse *)response {
    PPOTResult *result = [PPOTResult new];
    result.type = PPOTResultTypeSuccess;
    NSMutableDictionary *resultDictionary = [@{@"client": @{@"platform": @"iOS",
                                                            @"paypal_sdk_version": PayPalOTVersion(),
                                                            @"environment" : FORCE_VALUE_OR_NULL(response.environment),
                                                            @"product_name": PP_PRODUCT_STRING,
                                                            },
                                               } mutableCopy];

    if (response.responseType == PPAppSwitchResponseTypeAuthorizationCode) {

        [resultDictionary addEntriesFromDictionary:@{@"response_type" : @"authorization_code",
                                                     @"response" :  @{@"code": FORCE_VALUE_OR_NULL(response.authorizationCode)},
                                                     @"user": @{@"display_string" : FORCE_VALUE_OR_NULL(response.email)},
                                                     }];


    } else if (response.responseType == PPAppSwitchResponseTypeWeb) {

        [resultDictionary addEntriesFromDictionary:@{@"response_type" : @"web",
                                                     @"response" :  @{@"webURL": FORCE_VALUE_OR_NULL(response.webURL)},
                                                     }];


    } else {
        NSString *error = [NSString stringWithFormat:CARDIO_STR(@"App Switch: Unexpected response type: %@"), @(response.responseType)];
        PPLog(@"%@", error);
        result.type = PPOTResultTypeError;
        result.error = [self errorUserInfo:@{kPPOTAppSwitchMessageKey: error}];
    }
    result.response = resultDictionary;
    return result;
}

+ (PPOTResult *)resultWithCancel:(PPOTAppSwitchResponse *)response {
    PPOTResult *result = [PPOTResult new];
    if (response.error.count) {
        PPLog(@"App Switch Error: %@", response.error);
        result.type = PPOTResultTypeError;
        result.error = [self errorUserInfo:response.error];
    } else {
        PPLog(@"App Switch Cancelled");
        result.type = PPOTResultTypeCancel;
    }
    return result;
}

+ (PPOTResult *)resultWithError {
    NSError *error = [self errorUserInfo:@{kPPOTAppSwitchMessageKey:CARDIO_STR(@"App Switch Invalid URL")}];
    return [self resultWithSpecificError:error];
}

+ (PPOTResult *)resultWithPersistedRequestDataFetchError {
    NSDictionary *userInfo = @{kPPOTAppSwitchMessageKey:CARDIO_STR(@"Could not retrieve persisted request data")};
    NSError *error = [PPOTError errorWithErrorCode:PPOTErrorCodePersistedDataFetchFailed userInfo:userInfo];
    return [self resultWithSpecificError:error];
}

+ (PPOTResult *)resultWithSpecificError:(NSError *)error {
    PPOTResult *result = [PPOTResult new];
    result.type = PPOTResultTypeError;
    result.error = error;
    return result;
}

+ (NSError *)errorUserInfo:(NSDictionary *)dictionary {
    return [PPOTError errorWithErrorCode:PPOTErrorCodeParsingFailed userInfo:dictionary];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];

    NSString *typeName;
    switch (self.type) {
        case PPOTResultTypeSuccess: typeName = @"Success"; break;
        case PPOTResultTypeCancel: typeName = @"Cancel"; break;
        case PPOTResultTypeError: typeName = @"Error"; break;
    }
    
    [description appendFormat:@"PPOTResult (type: %@)\n", typeName];
    if (self.response) {
        [description appendFormat:@" Result Dictionary: %@\n", [self.response description]];
    }
    if (self.error) {
        [description appendFormat:@" Error: %@\n", [self.error description]];
    }
    return description;
}

@end

