//
//  PPOTURLSession.h
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief Request completion callback type
*/
typedef void(^PPOTURLSessionCompletionBlock)(NSData * _Nullable data, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error);

/*!
 @brief A URL session to manage network connections
*/
@interface PPOTURLSession: NSObject

/*!
 @return a session to send requests
*/
+ (nonnull PPOTURLSession *)session;

/*!
 @return a session to send requests with a specific timeout for requests
*/
+ (nonnull PPOTURLSession *)sessionWithTimeoutIntervalForRequest:(NSTimeInterval)timeoutIntervalForRequest;

/*!
 @brief Sends a URL request

 @param request the request to send
 @param completionBlock the completion block invoked for the response
*/
- (void)sendRequest:(nonnull NSURLRequest *)request
    completionBlock:(nullable PPOTURLSessionCompletionBlock)completionBlock;

/*!
 @brief Attempts to stop the session from accepting any future requests
*/
- (void)finishTasksAndInvalidate;

@end
