//
//  PPDataCollector.m
//  PPDataCollector
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPDataCollector_Internal.h"
#import "PPRCClientMetadataIDProvider.h"

#import "PPOTDevice.h"
#import "PPOTVersion.h"
#import "PPOTMacros.h"
#import "PPOTURLSession.h"

@implementation PPDataCollector

+ (NSString *)generateClientMetadataID:(NSString *)pairingID {
    static PPRCClientMetadataIDProvider *clientMetadataIDProvider;
    __block NSString *clientMetadataPairingID = [pairingID copy];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PPRCClientMetadataIDProviderNetworkAdapterBlock adapterBlock = ^(NSURLRequest *request, PPRCClientMetadataIDProviderNetworkResponseBlock completionBlock) {
            [[PPOTURLSession session] sendRequest:request completionBlock:^(NSData* responseData, NSHTTPURLResponse *response, __unused NSError *error) {
                completionBlock(response, responseData);
            }];
        };

        clientMetadataIDProvider = [[PPRCClientMetadataIDProvider alloc] initWithAppGuid:[PPOTDevice appropriateIdentifier]
                                                                        sourceAppVersion:PayPalOTVersion()
                                                                     networkAdapterBlock:adapterBlock
                                                                               pairingID:clientMetadataPairingID];
        // On first time, do not use a pairing ID to generate the client metadata ID because it's already been paired
        clientMetadataPairingID = nil;
    });

    NSString *clientMetadataID = [clientMetadataIDProvider clientMetadataID:clientMetadataPairingID];
    PPLog(@"ClientMetadataID: %@", clientMetadataID);
    return clientMetadataID;
}

+ (NSString *)generateClientMetadataID {
    return [PPDataCollector generateClientMetadataID:nil];
}

+ (nonnull NSString *)clientMetadataID:(nullable NSString *)pairingID {
    return [self generateClientMetadataID:pairingID];
}

+ (nonnull NSString *)clientMetadataID {
    return [self generateClientMetadataID];
}

+ (nonnull NSString *)collectPayPalDeviceData {
    NSMutableDictionary *dataDictionary = [NSMutableDictionary new];
    NSString *payPalClientMetadataId = [PPDataCollector generateClientMetadataID];
    if (payPalClientMetadataId) {
        dataDictionary[@"correlation_id"] = payPalClientMetadataId;
    }
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:&error];
    if (!data) {
        NSLog(@"ERROR: Failed to create deviceData string, error = %@", error);
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
