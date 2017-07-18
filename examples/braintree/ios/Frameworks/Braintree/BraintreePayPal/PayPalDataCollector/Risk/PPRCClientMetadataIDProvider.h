//
//  PPRiskComponentClientMetadataIDProvider.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief Block that processes a given HTTP response
*/
typedef void (^PPRCClientMetadataIDProviderNetworkResponseBlock)(NSHTTPURLResponse * _Nonnull response, NSData * _Nonnull data);

/*!
 @brief Networking adapter block which is passed a URL request, the block must send the request, and then passes on the response to the given network response block
*/
typedef void (^PPRCClientMetadataIDProviderNetworkAdapterBlock)(NSURLRequest * _Nonnull request, _Nonnull PPRCClientMetadataIDProviderNetworkResponseBlock);

/*!
 @brief Interface exposed from the Risk Component to bootstrap the Risk Component
*/
@interface PPRCClientMetadataIDProvider : NSObject

/*!
 @brief Initializes the risk component

 @param appGuid the application's GUID
 @param sourceAppVersion version of the source app/library
 @param networkAdapterBlock the adapter block to send requests
*/
- (nonnull instancetype)initWithAppGuid:(nonnull NSString *)appGuid
                       sourceAppVersion:(nonnull NSString *)sourceAppVersion
                    networkAdapterBlock:(nonnull PPRCClientMetadataIDProviderNetworkAdapterBlock)networkAdapterBlock;

/*!
 @brief Initializes the risk component

 @param appGuid the application's GUID
 @param sourceAppVersion version of the source app/library
 @param networkAdapterBlock the adapter block to send requests
 @param pairingID the pairing ID to associate with
*/
- (nonnull instancetype)initWithAppGuid:(nonnull NSString *)appGuid
                       sourceAppVersion:(nonnull NSString *)sourceAppVersion
                    networkAdapterBlock:(nonnull PPRCClientMetadataIDProviderNetworkAdapterBlock)networkAdapterBlock
                              pairingID:(nullable NSString *)pairingID;

/*!
 @brief Generates a client metadata ID

 @param pairingID a pairing ID to associate with this clientMetadataID must be 10-32 chars long or null
 @return a client metadata ID
*/
- (nonnull NSString *)clientMetadataID:(nullable NSString *)pairingID;

@end
