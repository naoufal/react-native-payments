//
//  PPOTSwitchRequest.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPOTAppSwitchUtil.h"

@interface PPOTSwitchRequest : NSObject

@property (nonatomic, readonly) NSNumber *protocolVersion;
@property (nonatomic, readonly) NSString *appGuid;
@property (nonatomic, readonly) NSString *clientID;
@property (nonatomic, readonly) NSString *environment;
@property (nonatomic, readonly) NSString *callbackURLScheme;
@property (nonatomic, readonly) NSString *clientMetadataID;

@property (nonatomic, strong, readwrite) NSString *targetAppURLScheme;
@property (nonatomic, assign, readwrite) PPAppSwitchResponseType responseType;
@property (nonatomic, strong, readwrite) NSString *customURL;

- (instancetype)initWithProtocolVersion:(NSNumber *)protocolVersion
                                appGuid:(NSString *)appGuid
                               clientID:(NSString *)clientID
                            environment:(NSString *)environment
                      callbackURLScheme:(NSString *)callbackURLScheme;

- (instancetype)initWithProtocolVersion:(NSNumber *)protocolVersion
                                appGuid:(NSString *)appGuid
                               clientID:(NSString *)clientID
                            environment:(NSString *)environment
                      callbackURLScheme:(NSString *)callbackURLScheme
                              pairingId:(NSString *)pairingId;

- (NSDictionary *)payloadDictionary; // used by v1, v2, v3 protocols (but not v0)

- (NSURL *)encodedURL;

- (void)addDataToPersistentRequestDataDictionary:(NSMutableDictionary *)requestDataDictionary;

@end
