#import "BTClientMetadata.h"

@interface BTClientMetadata () {
    @protected
    BTClientMetadataIntegrationType _integration;
    BTClientMetadataSourceType _source;
    NSString *_sessionId;
}
@end

@implementation BTClientMetadata

- (instancetype)init {
    self = [super init];
    if (self) {
        _integration = BTClientMetadataIntegrationCustom;
        _source = BTClientMetadataSourceUnknown;
        _sessionId = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    BTClientMetadata *copiedMetadata = [[BTClientMetadata allocWithZone:zone] init];
    copiedMetadata->_integration = _integration;
    copiedMetadata->_source = _source;
    copiedMetadata->_sessionId = [_sessionId copyWithZone:zone];
    return copiedMetadata;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    BTMutableClientMetadata *mutableMetadata = [[BTMutableClientMetadata allocWithZone:zone] init];
    mutableMetadata.integration = _integration;
    mutableMetadata.source = _source;
    mutableMetadata.sessionId = [_sessionId copyWithZone:zone];
    return mutableMetadata;
}

- (NSString *)integrationString {
    return [[self class] integrationToString:self.integration];
}

- (NSString *)sourceString {
    return [[self class] sourceToString:self.source];
}

- (NSDictionary *)parameters {
    return @{
             @"integration": self.integrationString,
             @"source": self.sourceString,
             @"sessionId": self.sessionId
             };
}

#pragma mark Internal helpers

+ (NSString *)integrationToString:(BTClientMetadataIntegrationType)integration {
    switch (integration) {
        case BTClientMetadataIntegrationCustom:
            return @"custom";
        case BTClientMetadataIntegrationDropIn:
            return @"dropin";
        case BTClientMetadataIntegrationDropIn2:
            return @"dropin2";
        case BTClientMetadataIntegrationUnknown:
            return @"unknown";
    }
}

+ (NSString *)sourceToString:(BTClientMetadataSourceType)source {
    switch (source) {
        case BTClientMetadataSourcePayPalApp:
            return @"paypal-app";
        case BTClientMetadataSourcePayPalBrowser:
            return @"paypal-browser";
        case BTClientMetadataSourceVenmoApp:
            return @"venmo-app";
        case BTClientMetadataSourceForm:
            return @"form";
        case BTClientMetadataSourceUnknown:
            return @"unknown";
    }
}

@end


@implementation BTMutableClientMetadata

- (void)setIntegration:(BTClientMetadataIntegrationType)integration {
    _integration = integration;
}

- (void)setSource:(BTClientMetadataSourceType)source {
    _source = source;
}

- (void)setSessionId:(NSString *)sessionId {
    _sessionId = sessionId;
}

@end
