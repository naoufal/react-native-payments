#import <UIKit/UIKit.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "BTVenmoAppSwitchRequestURL.h"
#import "BTVenmoDriver.h"
#import "Braintree-Version.h"
#import "BTSpecHelper.h"

SpecBegin(BTVenmoAppSwitchRequestURL)

describe(@"appSwitchURLForMerchantID:accessToken:sdkVersion:returnURLScheme:bundleDisplayName:environment:", ^{
    context(@"with valid params", ^{
        it(@"returns a URL containing params in query string", ^{
            
            BTMutableClientMetadata *meta = [BTMutableClientMetadata new];
            [meta setSessionId:@"session-id"];
            [meta setIntegration:BTClientMetadataIntegrationCustom];
            
            NSURL *url = [BTVenmoAppSwitchRequestURL appSwitchURLForMerchantID:@"merchant-id"
                                                                   accessToken:@"access-token"
                                                               returnURLScheme:@"a.scheme"
                                                             bundleDisplayName:@"An App"
                                                                   environment:@"sandbox"
                                                                      metadata:meta];

            NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
            for (NSURLQueryItem *queryItem in urlComponents.queryItems) {
                if ([queryItem.name isEqualToString:@"braintree_environment"]) {
                    expect(queryItem.value).to.equal(@"sandbox");
                }else if ([queryItem.name isEqualToString:@"braintree_access_token"]) {
                    expect(queryItem.value).to.equal(@"access-token");
                }else if ([queryItem.name isEqualToString:@"braintree_merchant_id"]) {
                    expect(queryItem.value).to.equal(@"merchant-id");
                }else if ([queryItem.name isEqualToString:@"x-source"]) {
                    expect(queryItem.value).to.equal(@"An App");
                }else if ([queryItem.name isEqualToString:@"braintree_auth_fingerprint"]) {
                    expect(queryItem.value).to.equal(@"a.fingerprint");
                }else if ([queryItem.name isEqualToString:@"braintree_validate"]) {
                    expect(queryItem.value).to.beTruthy();
                }else if ([queryItem.name isEqualToString:@"braintree_sdk_data"]) {
                    expect(queryItem.value).toNot.beNil();

                    NSData *data = [[NSData alloc] initWithBase64EncodedString:queryItem.value options:0];
                    BTJSON *json = [[BTJSON alloc] initWithData:data];
                    
                    BTJSON *meta = json[@"_meta"];
                    expect([meta[@"sessionId"] asString]).to.equal(@"session-id");
                    expect([meta[@"platform"] asString]).to.equal(@"ios");
                    expect([meta[@"integration"] asString]).to.equal(@"custom");
                    expect([meta[@"version"] asString]).to.equal(BRAINTREE_VERSION);
                }
            }
        });
    });
    
});

describe(@"baseAppSwitchURL", ^{
    it(@"returns expected base URL for Pay with Venmo", ^{
        expect([BTVenmoAppSwitchRequestURL baseAppSwitchURL].scheme).to.equal(@"com.venmo.touch.v2");
        expect([BTVenmoAppSwitchRequestURL baseAppSwitchURL].host).to.equal(@"x-callback-url");
        expect([BTVenmoAppSwitchRequestURL baseAppSwitchURL].path).to.equal(@"/vzero/auth");
        expect([BTVenmoAppSwitchRequestURL baseAppSwitchURL].query).to.beNil();
    });
});

SpecEnd
