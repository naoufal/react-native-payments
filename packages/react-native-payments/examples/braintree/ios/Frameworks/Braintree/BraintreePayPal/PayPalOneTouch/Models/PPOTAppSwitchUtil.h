//
//  PPOTAppSwitchUtil.h
//  PayPalOneTouch
//
//  Copyright © 2014 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPOTConfigurationRecipe;

#define kPPOTAppSwitchCurrentVersionNumber   3

// Dictionary keys for PPTouch v1 protocol
#define kPPOTAppSwitchEnvironmentKey         @"environment"
#define kPPOTAppSwitchEnvironmentURLKey      @"environment_url"
#define kPPOTAppSwitchCustomEnvironmentKey   @"custom"
#define kPPOTAppSwitchAppNameKey             @"app_name"
#define kPPOTAppSwitchAppGuidKey             @"app_guid"
#define kPPOTAppSwitchResponseTypeKey        @"response_type"
#define kPPOTAppSwitchClientIdKey            @"client_id"
#define kPPOTAppSwitchPayloadKey             @"payload"
#define kPPOTAppSwitchHermesTokenKey         @"token"
#define kPPOTAppSwitchHermesBATokenKey       @"ba_token"
#define kPPOTAppSwitchXCancelKey             @"x-cancel"
#define kPPOTAppSwitchXSuccessKey            @"x-success"
#define kPPOTAppSwitchXSourceKey             @"x-source"
#define kPPOTAppSwitchAuthenticateAction     @"authenticate"
#define kPPOTAppSwitchSuccessAction          @"success"
#define kPPOTAppSwitchCancelAction           @"cancel"
#define kPPOTAppSwitchResponseTypeCode       @"code"
#define kPPOTAppSwitchResponseTypeToken      @"token"
#define kPPOTAppSwitchDisplayNameKey         @"display_name"
#define kPPOTAppSwitchAccessTokenKey         @"access_token"
#define kPPOTAppSwitchAuthorizationCodeKey   @"authorization_code"
#define kPPOTAppSwitchExpiresInKey           @"expires_in"
#define kPPOTAppSwitchScopesKey              @"scope"
#define kPPOTAppSwitchEmailKey               @"email"
#define kPPOTAppSwitchPhotoURLKey            @"photo_url"
#define kPPOTAppSwitchAccountCountryKey      @"account_country"
#define kPPOTAppSwitchLanguageKey            @"language"
#define kPPOTAppSwitchProtocolVersionKey     @"version"
#define kPPOTAppSwitchPrivacyURLKey          @"privacy_url"
#define kPPOTAppSwitchAgreementURLKey        @"agreement_url"
#define kPPOTAppSwitchErrorKey               @"error"
#define kPPOTAppSwitchMessageKey             @"message"

// v2 extension
#define kPPOTAppSwitchResponseTypeWeb        @"web"
#define kPPOTAppSwitchWebURLKey              @"webURL"

// v3
#define kPPOTAppSwitchMetadataClientIDKey    @"client_metadata_id"
#define kPPOTAppSwitchKeyIDKey               @"key_id"
#define kPPOTAppSwitchMsgGUIDKey             @"msg_GUID"
#define kPPOTAppSwitchSymKey                 @"sym_key"
#define kPPOTAppSwitchTimestampKey           @"timestamp"
#define kPPOTAppSwitchLoginAction            @"login"
#define kPPOTAppSwitchEncryptedPayloadKey    @"payloadEnc"
#define kPPOTAppSwitchPaymentCodeTypeKey     @"payment_code_type"
#define kPPOTAppSwitchPaymentCodeKey         @"payment_code"
#define kPPOTAppSwitchResposneAuthCodeKey    @"authcode"
#define kPPOTAppSwitchKeyDeviceName          @"device_name"

#define PPRequestEnvironmentProduction @"live"
#define PPRequestEnvironmentNoNetwork  @"mock"
#define PPRequestEnvironmentSandbox    @"sandbox"


typedef NS_ENUM(NSUInteger, PPAppSwitchResponseAction) {
    PPAppSwitchResponseActionUnknown,
    PPAppSwitchResponseActionCancel,
    PPAppSwitchResponseActionSuccess
};

typedef NS_ENUM(NSUInteger, PPAppSwitchResponseType) {
    PPAppSwitchResponseTypeUnknown,
    PPAppSwitchResponseTypeToken,
    PPAppSwitchResponseTypeAuthorizationCode,
    PPAppSwitchResponseTypeWeb,
};

@interface PPOTAppSwitchUtil : NSObject

+ (NSString *)bundleId;
+ (NSString *)bundleName;
+ (BOOL)isCallbackURLSchemeValid:(NSString *)callbackURLScheme;

/*!
 @brief handles urlencoding
*/
+ (NSDictionary *)parseQueryString:(NSString *)query;

+ (NSURL *)URLAction:(NSString *)action
  targetAppURLScheme:(NSString *)targetAppURLScheme
   callbackURLScheme:(NSString *)callbackURLScheme
             payload:(NSDictionary *)payload;

+ (NSURL *)URLAction:(NSString *)action
   callbackURLScheme:(NSString *)callbackURLScheme
             payload:(NSDictionary *)payload;

+ (void)redirectURLsForCallbackURLScheme:(NSString *)callbackURLScheme withReturnURL:(NSString **)returnURL withCancelURL:(NSString **)cancelURL;
+ (BOOL)isValidURLAction:(NSURL *)urlAction;
+ (NSString *)actionFromURLAction:(NSURL *)urlAction;

@end
