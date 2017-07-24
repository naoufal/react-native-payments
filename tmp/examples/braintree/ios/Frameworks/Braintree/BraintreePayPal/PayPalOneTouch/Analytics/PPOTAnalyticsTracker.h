//
//  PPOTAnalyticsTracker.h
//  PayPalOneTouch
//
//  Copyright © 2014 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPOTAnalyticsTracker : NSObject

/*!
 @brief Retrieves singleton instance.
*/
+ (nonnull PPOTAnalyticsTracker *)sharedManager;

/*!
 @brief Tracks a "page"/action taken.

 @param pagename the page or "action" taken
 @param environment the environment (production, sandbox, etc.)
 @param clientID the client ID of the request
 @param error an optional error that occurred
 @param hermesToken web token
*/
- (void)trackPage:(nonnull NSString *)pagename
      environment:(nonnull NSString *)environment
         clientID:(nullable NSString *)clientID
            error:(nullable NSError *)error
      hermesToken:(nullable NSString *)hermesToken;
@end
