#import "BTAnalyticsMetadata.h"
#import "BTAnalyticsService.h"
#import "BTAPIClient_Internal.h"
#import "BTClientMetadata.h"
#import "BTHTTP.h"
#import "BTLogger_Internal.h"
#import <UIKit/UIKit.h>

#pragma mark - BTAnalyticsEvent

/// Encapsulates a single analytics event
@interface BTAnalyticsEvent : NSObject

@property (nonatomic, copy) NSString *kind;

@property (nonatomic, assign) long timestamp;

+ (nonnull instancetype)event:(nonnull NSString *)eventKind withTimestamp:(long)timestamp;

/// Event serialized to JSON
- (nonnull NSDictionary *)json;

@end

@implementation BTAnalyticsEvent

+ (instancetype)event:(NSString *)eventKind withTimestamp:(long)timestamp {
    BTAnalyticsEvent *event = [[BTAnalyticsEvent alloc] init];
    event.kind = eventKind;
    event.timestamp = timestamp;
    return event;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ at %ld", self.kind, (long)self.timestamp];
}

- (NSDictionary *)json {
    return @{
             @"kind": self.kind,
             @"timestamp": @(self.timestamp)
             };
}

@end

#pragma mark - BTAnalyticsSession

/// Encapsulates analytics events for a given session
@interface BTAnalyticsSession : NSObject

@property (nonatomic, copy, nonnull) NSString *sessionID;

@property (nonatomic, copy, nonnull) NSString *source;

@property (nonatomic, copy, nonnull) NSString *integration;

@property (nonatomic, strong, nonnull) NSMutableArray <BTAnalyticsEvent *> *events;

/// Dictionary of analytics metadata from `BTAnalyticsMetadata`
@property (nonatomic, strong, nonnull) NSDictionary *metadataParameters;

+ (nonnull instancetype)sessionWithID:(nonnull NSString *)sessionID
                               source:(nonnull NSString *)source
                          integration:(nonnull NSString *)integration;

@end

@implementation BTAnalyticsSession

- (instancetype)init {
    if (self = [super init]) {
        _events = [NSMutableArray array];
        _metadataParameters = [BTAnalyticsMetadata metadata];
    }
    return self;
}

+ (instancetype)sessionWithID:(NSString *)sessionID
                       source:(NSString *)source
                  integration:(NSString *)integration
{
    if (!sessionID || !source || !integration) {
        return nil;
    }
    
    BTAnalyticsSession *session = [[BTAnalyticsSession alloc] init];
    session.sessionID = sessionID;
    session.source = source;
    session.integration = integration;
    return session;
}

@end

#pragma mark - BTAnalyticsService

@interface BTAnalyticsService ()

/// Dictionary of analytics sessions, keyed by session ID. The analytics service requires that batched events
/// are sent from only one session. In practice, BTAPIClient.metadata.sessionId should never change, so this
/// is defensive.
@property (nonatomic, strong) NSMutableDictionary <NSString *, BTAnalyticsSession *> *analyticsSessions;

/// A serial dispatch queue that synchronizes access to `analyticsSessions`
@property (nonatomic, strong) dispatch_queue_t sessionsQueue;

@end

@implementation BTAnalyticsService

NSString * const BTAnalyticsServiceErrorDomain = @"com.braintreepayments.BTAnalyticsServiceErrorDomain";

- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient {
    if (self = [super init]) {
        _analyticsSessions = [NSMutableDictionary dictionary];
        _sessionsQueue = dispatch_queue_create("com.braintreepayments.BTAnalyticsService", DISPATCH_QUEUE_SERIAL);
        _apiClient = apiClient;
        _flushThreshold = 1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResign:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public methods

- (void)sendAnalyticsEvent:(NSString *)eventKind {
    [self enqueueEvent:eventKind];
    [self checkFlushThreshold];
}

- (void)sendAnalyticsEvent:(NSString *)eventKind completion:(__unused void(^)(NSError *error))completionBlock {
    [self enqueueEvent:eventKind];
    [self flush:completionBlock];
}

- (void)flush:(void (^)(NSError *))completionBlock {
    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        if (error) {
            [[BTLogger sharedLogger] warning:[NSString stringWithFormat:@"Failed to send analytics event. Remote configuration fetch failed. %@", error.localizedDescription]];
            if (completionBlock) completionBlock(error);
            return;
        }
        
        NSURL *analyticsURL = [configuration.json[@"analytics"][@"url"] asURL];
        if (!analyticsURL) {
            [[BTLogger sharedLogger] debug:@"Skipping sending analytics event - analytics is disabled in remote configuration"];
            NSError *error = [NSError errorWithDomain:BTAnalyticsServiceErrorDomain code:BTAnalyticsServiceErrorTypeMissingAnalyticsURL userInfo:@{ NSLocalizedDescriptionKey : @"Analytics is disabled in remote configuration" }];
            if (completionBlock) completionBlock(error);
            return;
        }
        
        if (!self.http) {
            if (self.apiClient.clientToken) {
                self.http = [[BTHTTP alloc] initWithBaseURL:analyticsURL authorizationFingerprint:self.apiClient.clientToken.authorizationFingerprint];
            } else if (self.apiClient.tokenizationKey) {
                self.http = [[BTHTTP alloc] initWithBaseURL:analyticsURL tokenizationKey:self.apiClient.tokenizationKey];
            }
            if (!self.http) {
                NSError *error = [NSError errorWithDomain:BTAnalyticsServiceErrorDomain code:BTAnalyticsServiceErrorTypeInvalidAPIClient userInfo:@{ NSLocalizedDescriptionKey : @"API client must have client token or tokenization key" }];
                [[BTLogger sharedLogger] warning:error.localizedDescription];
                if (completionBlock) completionBlock(error);
                return;
            }
        }
        // A special value passed in by unit tests to prevent BTHTTP from actually posting
        if ([self.http.baseURL isEqual:[NSURL URLWithString:@"test://do-not-send.url"]]) {
            if (completionBlock) completionBlock(nil);
            return;
        }
        
        dispatch_async(self.sessionsQueue, ^{
            if (self.analyticsSessions.count == 0) {
                if (completionBlock) completionBlock(nil);
                return;
            }
            
            for (NSString *sessionID in self.analyticsSessions.allKeys) {
                BTAnalyticsSession *session = self.analyticsSessions[sessionID];
                
                NSMutableDictionary *metadataParameters = [NSMutableDictionary dictionary];
                [metadataParameters addEntriesFromDictionary:session.metadataParameters];
                metadataParameters[@"sessionId"] = session.sessionID;
                metadataParameters[@"integration"] = session.integration;
                metadataParameters[@"source"] = session.source;
                
                NSMutableDictionary *postParameters = [NSMutableDictionary dictionary];
                if (session.events) {
                    // Map array of BTAnalyticsEvent to JSON
                    postParameters[@"analytics"] = [session.events valueForKey:@"json"];
                }
                postParameters[@"_meta"] = metadataParameters;
                if (self.apiClient.clientToken.authorizationFingerprint) {
                    postParameters[@"authorization_fingerprint"] = self.apiClient.clientToken.authorizationFingerprint;
                }
                if (self.apiClient.tokenizationKey) {
                    postParameters[@"tokenization_key"] = self.apiClient.tokenizationKey;
                }
                [self.http POST:@"/" parameters:postParameters completion:^(__unused BTJSON *body, __unused NSHTTPURLResponse *response, NSError *error) {
                    if (!error) {
                        [self.analyticsSessions removeObjectForKey:sessionID];
                    } else {
                        [[BTLogger sharedLogger] warning:@"Failed to flush analytics events: %@", error.localizedDescription];
                    }
                    if (completionBlock) completionBlock(error);
                }];
            }
        });
    }];
}

#pragma mark - Private methods

- (void)appWillResign:(NSNotification *)notification {
    UIApplication *application = notification.object;
    
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithName:@"BTAnalyticsService" expirationHandler:^{
        [[BTLogger sharedLogger] warning:@"Analytics service background task expired"];
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(self.sessionsQueue, ^{
        [self flush:^(__unused NSError * _Nullable error) {
            [application endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }];
    });
}

#pragma mark - Helpers

- (void)enqueueEvent:(NSString *)eventKind {
    long timestampInSeconds = round([[NSDate date] timeIntervalSince1970]);
    BTAnalyticsEvent *event = [BTAnalyticsEvent event:eventKind withTimestamp:timestampInSeconds];

    BTAnalyticsSession *session = [BTAnalyticsSession sessionWithID:self.apiClient.metadata.sessionId
                                                             source:self.apiClient.metadata.sourceString
                                                        integration:self.apiClient.metadata.integrationString];
    if (!session) {
        [[BTLogger sharedLogger] warning:@"Missing analytics session metadata - will not send event %@", event.kind];
        return;
    }
    
    dispatch_async(self.sessionsQueue, ^{
        if (!self.analyticsSessions[session.sessionID]) {
            self.analyticsSessions[session.sessionID] = session;
        }
        
        [self.analyticsSessions[session.sessionID].events addObject:event];
    });
}

- (void)checkFlushThreshold {
    __block NSUInteger eventCount = 0;

    dispatch_sync(self.sessionsQueue, ^{
        for (BTAnalyticsSession *analyticsSession in self.analyticsSessions.allValues) {
            eventCount += analyticsSession.events.count;
        }
    });
    
    if (eventCount >= self.flushThreshold) {
        [self flush:nil];
    }
}

@end
