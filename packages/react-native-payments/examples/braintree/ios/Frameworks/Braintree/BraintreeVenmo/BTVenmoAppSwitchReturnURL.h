#import <Foundation/Foundation.h>

extern NSString *const BTVenmoAppSwitchReturnURLErrorDomain;

typedef NS_ENUM(NSUInteger, BTVenmoAppSwitchReturnURLState) {
    BTVenmoAppSwitchReturnURLStateSucceeded,
    BTVenmoAppSwitchReturnURLStateFailed,
    BTVenmoAppSwitchReturnURLStateCanceled,
    BTVenmoAppSwitchReturnURLStateUnknown
};

/*!
 @brief This class interprets URLs received from the Venmo app via app switch returns.

 @discussion Venmo Touch app switch authorization requests should result in success, failure or user-initiated cancelation. These states are communicated in the url.
*/
@interface BTVenmoAppSwitchReturnURL : NSObject

/*!
 @brief Evaluates whether the url-sourceApplication pair represents a valid Venmo Touch return.

 @param url               an app switch return URL
 @param sourceApplication an app switch source application

 @return YES if the url-sourceApplication pair likely represent a Venmo Touch app switch return
*/
+ (BOOL)isValidURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

/*!
 @brief Initializes a new BTVenmoAppSwitchReturnURL

 @param url an incoming app switch url

 @return An initialized app switch return url
*/
- (instancetype)initWithURL:(NSURL *)url;

/*!
 @brief The overall status of the app switch - success, failure or cancelation
*/
@property (nonatomic, assign, readonly) BTVenmoAppSwitchReturnURLState state;

/*!
 @brief The nonce from the return URL.
*/
@property (nonatomic, copy, readonly) NSString *nonce;

/*!
 @brief The username from the return URL.
*/
@property (nonatomic, copy, readonly) NSString *username;

/*!
 @brief If the return URL's state is BTVenmoAppSwitchReturnURLStateFailed, the error returned from Venmo via the app switch.
*/
@property (nonatomic, strong, readonly) NSError *error;

@end
