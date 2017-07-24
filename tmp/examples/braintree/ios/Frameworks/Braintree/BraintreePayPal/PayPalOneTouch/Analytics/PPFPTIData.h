//
//  PPFPTIData.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief Represents the analytics data and metadata for the analytics request.
*/
@interface PPFPTIData: NSObject

/*!
 @brief Designated initializer

 @param params the analytics data to send
 @param deviceID the device ID
 @param sessionID the session's ID
 @param userAgent the user agent string to use
 @param trackerURL the tracker URL to send the data to
*/
- (nonnull instancetype)initWithParams:(nonnull NSDictionary *)params
                              deviceID:(nonnull NSString *)deviceID
                             sessionID:(nonnull NSString *)sessionID
                             userAgent:(nonnull NSString *)userAgent
                            trackerURL:(nonnull NSURL *)trackerURL;

/*!
 @brief The intended NSURL to send the data to
*/
@property (nonatomic, copy, readonly, nonnull) NSURL *trackerURL;

/*!
 @brief The user agent string to use for the request
*/
@property (nonatomic, copy, readonly, nonnull) NSString *userAgent;

/*!
 @brief The analytics data and metadata to send.

 @discussion This data is not the same as the initial params data passed in the
 initializer. The format of the dictionary is different and keys/values may be changed.
 Usually transformed into a JSON object in the request body.
*/
- (nonnull NSDictionary *)dataAsDictionary;

@end
