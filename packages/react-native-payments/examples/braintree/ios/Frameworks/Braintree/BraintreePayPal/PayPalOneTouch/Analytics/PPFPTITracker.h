//
//  PPFPTITracker.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPFPTIData;

/*!
 @brief Delegate for sending the passed in data
*/
@protocol PPFPTINetworkAdapterDelegate

/*!
 @brief Sends the data using whatever transport the delegate implements.

 @param fptiData contains the data to send, which URL to send it to, and other request metadata
*/
- (void)sendRequestWithData:(nonnull PPFPTIData*)fptiData;

@end

/*!
 @brief Tracker to send analytics data to.
*/
@interface PPFPTITracker : NSObject

/*!
 @brief Designated initializer.

 @param deviceUDID the device's UDID
 @param sessionID the session ID to associate all events to
 @param networkAdapterDelegate network delegate responsible for sending requests
*/
- (nonnull instancetype)initWithDeviceUDID:(nonnull NSString *)deviceUDID
                                 sessionID:(nonnull NSString *)sessionID
                    networkAdapterDelegate:(nullable id<PPFPTINetworkAdapterDelegate>)networkAdapterDelegate;


/*!
 @brief The delegate which actually sends the data
*/
@property (nonatomic, weak, readwrite, nullable) id<PPFPTINetworkAdapterDelegate> networkAdapterDelegate;

/*!
 @brief Sends an event with various metrics and data

 @param params the analytics data to send
*/
- (void)submitEventWithParams:(nonnull NSDictionary *)params;

@end
