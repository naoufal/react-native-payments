#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const BTAnalyticsServiceErrorDomain;

typedef NS_ENUM(NSUInteger, BTAnalyticsServiceErrorType) {
    BTAnalyticsServiceErrorTypeUnknown = 1,
    BTAnalyticsServiceErrorTypeMissingAnalyticsURL,
    BTAnalyticsServiceErrorTypeInvalidAPIClient,
};

@class BTAPIClient, BTHTTP;

@interface BTAnalyticsService : NSObject

- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient;

/*!
 @brief Defaults to 1, can be overridden
*/
@property (nonatomic, assign) NSUInteger flushThreshold;

@property (nonatomic, strong) BTAPIClient *apiClient;

/*!
 @brief Tracks an event.

 @discussion Events are queued and sent in batches to the analytics service, based on the status of the app
 and the number of queued events. After exiting this method, there is no guarantee that the event has been
 sent.
*/
- (void)sendAnalyticsEvent:(NSString *)eventKind;

/*!
 @brief Tracks an event and sends it to the analytics service. It will also flush any queued events.

 @param completionBlock A callback that is invoked when the analytics service has completed.
*/
- (void)sendAnalyticsEvent:(NSString *)eventKind completion:(nullable void(^)(NSError * _Nullable))completionBlock;

/*!
 @brief Sends all queued events to the analytics service.

 @param completionBlock A callback that is invoked when the analytics service has completed.
*/
- (void)flush:(nullable void (^)(NSError * _Nullable error))completionBlock;

/*!
 @brief The HTTP client for communication with the analytics service endpoint. Exposed for testing.
*/
@property (nonatomic, strong) BTHTTP *http;

@end

NS_ASSUME_NONNULL_END
