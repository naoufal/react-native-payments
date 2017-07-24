#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BTClientMetadataSourceType) {
    BTClientMetadataSourceUnknown = 0,
    BTClientMetadataSourcePayPalApp,
    BTClientMetadataSourcePayPalBrowser,
    BTClientMetadataSourceVenmoApp,
    BTClientMetadataSourceForm,
};

typedef NS_ENUM(NSInteger, BTClientMetadataIntegrationType) {
    BTClientMetadataIntegrationCustom,
    BTClientMetadataIntegrationDropIn,
    BTClientMetadataIntegrationDropIn2,
    BTClientMetadataIntegrationUnknown
};

NS_ASSUME_NONNULL_BEGIN

/*!
 @class BTClientMetadata
 @brief Represents the metadata associated with a session for posting along with payment data during tokenization

 @discussion When a payment method is tokenized, the client api accepts parameters under
 _meta which are used to determine where payment data originated.

 In general, this data may evolve and be used in different ways by different
 integrations in a single app. For example, if both Apple Pay and drop in are
 used. In this case, the source and integration may change over time, while
 the sessionId should remain constant. To achieve this, users of this class
 should use `mutableCopy` to create a new copy based on the existing session
 and then update the object as needed.
*/
@interface BTClientMetadata : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, assign, readonly) BTClientMetadataIntegrationType integration;
@property (nonatomic, assign, readonly) BTClientMetadataSourceType source;

/*!
 @brief Auto-generated UUID
*/
@property (nonatomic, copy, readonly) NSString *sessionId;

#pragma mark Derived Properties

@property (nonatomic, copy, readonly) NSString *integrationString;
@property (nonatomic, copy, readonly) NSString *sourceString;
@property (nonatomic, strong, readonly) NSDictionary *parameters;

@end

@interface BTMutableClientMetadata : BTClientMetadata

- (void)setIntegration:(BTClientMetadataIntegrationType)integration;
- (void)setSource:(BTClientMetadataSourceType)source;
- (void)setSessionId:(NSString *)sessionId;

@end

NS_ASSUME_NONNULL_END
