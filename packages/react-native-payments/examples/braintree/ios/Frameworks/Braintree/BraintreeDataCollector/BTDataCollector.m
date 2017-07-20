#import "BTConfiguration+DataCollector.h"
#import "BTDataCollector_Internal.h"
#import <CoreLocation/CoreLocation.h>

@interface BTDataCollector ()
@property (nonatomic, assign) BTDataCollectorEnvironment environment;
@property (nonatomic, copy) NSString *fraudMerchantId;
@property (nonatomic, copy) BTAPIClient *apiClient;
@end

@implementation BTDataCollector

static NSString *BTDataCollectorSharedMerchantId = @"600000";
static Class PayPalDataCollectorClass;

NSString * const BTDataCollectorKountErrorDomain = @"com.braintreepayments.BTDataCollectorKountErrorDomain";

#pragma mark - Initialization and setup

+ (void)load {
    if (self == [BTDataCollector class]) {
        PayPalDataCollectorClass = NSClassFromString(@"PPDataCollector");
    }
}

- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient {
    if (self = [super init]) {
        [self setUpKountWithDebugOn:NO];
        _apiClient = apiClient;
    }
    
    return self;
}

- (void)setUpKountWithDebugOn:(BOOL)debugLogging {
    self.kount = [KDataCollector sharedCollector];
    self.kount.debug = debugLogging;

    CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];
    if ((locationStatus != kCLAuthorizationStatusAuthorizedWhenInUse && locationStatus != kCLAuthorizationStatusAuthorizedAlways) || ![CLLocationManager locationServicesEnabled]) {
        self.kount.locationCollectorConfig = KLocationCollectorConfigSkip;
    }
}

#pragma mark - Accessors

+ (void)setPayPalDataCollectorClass:(Class)payPalDataCollectorClass {
    // +load will always set PayPalDataCollectorClass
    if ([payPalDataCollectorClass isSubclassOfClass:NSClassFromString(@"PPDataCollector")]) {
        PayPalDataCollectorClass = payPalDataCollectorClass;
    }
}

- (void)setCollectorUrl:(__unused NSString *)url {
    // do nothing
}

- (void)setCollectorEnvironment:(KEnvironment)environment {
    self.kount.environment = environment;
}

- (void)setFraudMerchantId:(NSString *)fraudMerchantId {
    _fraudMerchantId = fraudMerchantId;
    self.kount.merchantID = [fraudMerchantId integerValue];
}

#pragma mark - Public methods

- (void)collectCardFraudData:(void (^)(NSString * _Nonnull))completion {
    [self collectFraudDataForCard:YES forPayPal:NO completion:completion];
}

- (void)collectFraudData:(void (^)(NSString * _Nonnull))completion {
    [self collectFraudDataForCard:YES forPayPal:YES completion:completion];
}

#pragma mark - Helper methods

- (void)collectFraudDataForCard:(BOOL)includeCard forPayPal:(BOOL)includePayPal completion:(void (^)(NSString *deviceData))completion {
    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration * _Nullable configuration, NSError * _Nullable __unused _) {
        NSMutableDictionary *dataDictionary = [NSMutableDictionary new];

        dispatch_group_t collectorDispatchGroup = dispatch_group_create();
        [self onCollectorStart];

        if (configuration.isKountEnabled && includeCard) {
            BTDataCollectorEnvironment btEnvironment = [self environmentFromString:[configuration.json[@"environment"] asString]];
            [self setCollectorEnvironment:[self collectorEnvironment:btEnvironment]];

            NSString *merchantId = self.fraudMerchantId ?: [configuration kountMerchantId];
            self.kount.merchantID = [merchantId integerValue];

            NSString *deviceSessionId = [self sessionId];
            dataDictionary[@"device_session_id"] = deviceSessionId;
            dataDictionary[@"fraud_merchant_id"] = merchantId;
            dispatch_group_enter(collectorDispatchGroup);
            [self.kount collectForSession:deviceSessionId completion:^(__unused NSString * _Nonnull sessionID, __unused BOOL success, __unused NSError * _Nullable error) {
                if (success) {
                    [self onCollectorSuccess];
                } else {
                    [self onCollectorError:error];
                }
                dispatch_group_leave(collectorDispatchGroup);
            }];
        }
        
        if (includePayPal) {
            NSString *payPalClientMetadataId = [BTDataCollector generatePayPalClientMetadataId];
            if (payPalClientMetadataId) {
                dataDictionary[@"correlation_id"] = payPalClientMetadataId;
            }
        }

        dispatch_group_notify(collectorDispatchGroup, dispatch_get_main_queue(), ^{
            NSError *error;
            NSData *data = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:&error];
            // Defensive check: JSON serialization should never fail
            if (!data) {
                NSLog(@"ERROR: Failed to create deviceData string, error = %@", error);
                [self onCollectorError:error];
                if (completion) {
                    completion(@"");
                }
                return;
            }
            NSString *deviceData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            // If only PayPal fraud is being collected, immediately inform the delegate that collection has
            // finished, since PayPal fraud does not allow us to know when it has officially finished collection.
            if (!includeCard && includePayPal) {
                [self onCollectorSuccess];
            }
            
            if (completion) {
                completion(deviceData);
            }
        });
    }];
}

- (NSString *)collectFraudDataForCard:(BOOL)includeCard forPayPal:(BOOL)includePayPal
{
    [self onCollectorStart];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary new];
    if (includeCard) {
        NSString *deviceSessionId = [self sessionId];
        dataDictionary[@"device_session_id"] = deviceSessionId;
        dataDictionary[@"fraud_merchant_id"] = self.fraudMerchantId;

        [self.kount collectForSession:deviceSessionId completion:^(__unused NSString * _Nonnull sessionID, BOOL success, NSError * _Nullable error) {
            if (success) {
                [self onCollectorSuccess];
            } else {
                [self onCollectorError:error];
            }
        }];
    }

    if (includePayPal) {
        NSString *payPalClientMetadataId = [BTDataCollector generatePayPalClientMetadataId];
        if (payPalClientMetadataId) {
            dataDictionary[@"correlation_id"] = payPalClientMetadataId;
        }
    }
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:&error];
    if (!data) {
        NSLog(@"ERROR: Failed to create deviceData string, error = %@", error);
        [self onCollectorError:error];
        return @"";
    }
    
    // If only PayPal fraud is being collected, immediately inform the delegate that collection has
    // finished, since PayPal fraud does not allow us to know when it has officially finished collection.
    if (!includeCard && includePayPal) {
        [self onCollectorSuccess];
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)generatePayPalClientMetadataId {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (PayPalDataCollectorClass && [PayPalDataCollectorClass respondsToSelector:@selector(generateClientMetadataID)]) {
        return [PayPalDataCollectorClass performSelector:@selector(generateClientMetadataID)];
    }
#pragma clang diagnostic pop
    
    return nil;
}

/// Generates a new session ID
- (NSString *)sessionId {
    return [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (BTDataCollectorEnvironment)environmentFromString:(NSString *)environment {
    if ([environment isEqualToString:@"production"]) {
        return BTDataCollectorEnvironmentProduction;
    } else if ([environment isEqualToString:@"sandbox"]) {
        return BTDataCollectorEnvironmentSandbox;
    } else if ([environment isEqualToString:@"qa"]) {
        return BTDataCollectorEnvironmentQA;
    } else {
        return BTDataCollectorEnvironmentDevelopment;
    }
}

- (KEnvironment)collectorEnvironment:(BTDataCollectorEnvironment)environment {
    switch (environment) {
        case BTDataCollectorEnvironmentProduction:
            return KEnvironmentProduction;
        default:
            return KEnvironmentTest;
    }
}

#pragma mark DeviceCollectorSDKDelegate methods

/// The collector has started.
- (void)onCollectorStart {
    if ([self.delegate respondsToSelector:@selector(dataCollectorDidStart:)]) {
        [self.delegate dataCollectorDidStart:self];
    }
}

/// The collector finished successfully.
- (void)onCollectorSuccess {
    if ([self.delegate respondsToSelector:@selector(dataCollectorDidComplete:)]) {
        [self.delegate dataCollectorDidComplete:self];
    }
}

/// An error occurred.
///
/// @param error Triggering error if available
- (void)onCollectorError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(dataCollector:didFailWithError:)]) {
        [self.delegate dataCollector:self didFailWithError:error];
    }
}

#pragma mark - Deprecated methods

- (instancetype)initWithEnvironment:(BTDataCollectorEnvironment)environment {
    if (self = [super init]) {
        [self setUpKountWithDebugOn:NO];
        [self setCollectorEnvironment:[self collectorEnvironment:environment]];
        [self setFraudMerchantId:BTDataCollectorSharedMerchantId];
    }
    return self;
}

+ (NSString *)payPalClientMetadataId {
    return [BTDataCollector generatePayPalClientMetadataId];
}

/// At this time, this method only collects data with Kount. However, it is possible that in the future,
/// we will want to collect data (for card transactions) with PayPal as well. If this becomes the case,
/// we can modify this method to include a clientMetadataID without breaking the public interface.
- (NSString *)collectCardFraudData {
    return [self collectFraudDataForCard:YES forPayPal:NO];
}

- (NSString *)collectPayPalClientMetadataId {
    return [self collectFraudDataForCard:NO forPayPal:YES];
}

/// Similar to `collectCardFraudData` but with the addition of the payPalClientMetadataId, if available.
- (NSString *)collectFraudData {
    return [self collectFraudDataForCard:YES forPayPal:YES];
}

@end
