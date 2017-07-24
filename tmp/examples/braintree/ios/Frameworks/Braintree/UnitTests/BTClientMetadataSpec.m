#import "BTClientMetadata.h"
#import "BTSpecDependencies.h"

SpecBegin(BTClientMetadata)

describe(@"string values", ^{

    BTMutableClientMetadata *m = [[BTMutableClientMetadata alloc] init];

    it(@"source returns expected strings", ^{
        NSDictionary *sources = @{
                                  @(BTClientMetadataSourceUnknown) : @"unknown",
                                  @(BTClientMetadataSourceForm) : @"form",
                                  @(BTClientMetadataSourcePayPalApp) : @"paypal-app",
                                  @(BTClientMetadataSourcePayPalBrowser) : @"paypal-browser",
                                  @(BTClientMetadataSourceVenmoApp) : @"venmo-app",
                                  };

        for (NSNumber *sourceNumber in sources) {
            m.source = (BTClientMetadataSourceType)sourceNumber.integerValue;
            XCTAssertEqualObjects(m.sourceString, sources[sourceNumber]);
        }
    });

    it(@"integration returns expected strings", ^{
        m.integration = BTClientMetadataIntegrationDropIn;
        expect(m.integrationString).to.equal(@"dropin");
        
        m.integration = BTClientMetadataIntegrationDropIn2;
        expect(m.integrationString).to.equal(@"dropin2");

        m.integration = BTClientMetadataIntegrationCustom;
        expect(m.integrationString).to.equal(@"custom");

        m.integration = BTClientMetadataIntegrationUnknown;
        expect(m.integrationString).to.equal(@"unknown");
    });

    it(@"sessionId returns a 32 character UUID string", ^{
        expect(m.sessionId.length).to.equal(32);
    });

    it(@"sessionId should be different than a different instance's sessionId", ^{
        BTMutableClientMetadata *m2 = [BTMutableClientMetadata new];
        expect(m.sessionId).notTo.equal(m2.sessionId);
    });

});

sharedExamplesFor(@"a copied metadata instance", ^(NSDictionary *data) {
    __block BTClientMetadata *original, *copied;
    
    beforeEach(^{
        original = data[@"original"];
        copied = data[@"copy"];
    });
    
    it(@"has the same values", ^{
        expect(copied.integration).to.equal(original.integration);
        expect(copied.source).to.equal(original.source);
        expect(copied.sessionId).to.equal(original.sessionId);
    });
});


describe(@"mutableMetadata", ^{

    __block BTMutableClientMetadata *mutableMetadata;

    beforeEach(^{
        mutableMetadata = [[BTMutableClientMetadata alloc] init];
    });

    describe(@"init", ^{
        it(@"has expected default values", ^{
            expect(mutableMetadata.integration).to.equal(BTClientMetadataIntegrationCustom);
            expect(mutableMetadata.source).to.equal(BTClientMetadataSourceUnknown);
        });
    });

    context(@"with non-default values", ^{
        beforeEach(^{
            mutableMetadata.integration = BTClientMetadataIntegrationDropIn;
            mutableMetadata.source = BTClientMetadataSourcePayPalApp;
        });

        describe(@"copy", ^{
            __block BTClientMetadata *copied;
            beforeEach(^{
                copied = [mutableMetadata copy];
            });
            
            itBehavesLike(@"a copied metadata instance", ^{
                return @{@"original" : mutableMetadata,
                         @"copy" : copied};
            });

            it(@"returns a different, immutable instance", ^{
                expect(mutableMetadata).toNot.beIdenticalTo(copied);
                expect([copied isKindOfClass:[BTClientMetadata class]]).to.beTruthy();
                expect([copied isKindOfClass:[BTMutableClientMetadata class]]).to.beFalsy();
            });
        });

        describe(@"mutableCopy", ^{
            __block BTMutableClientMetadata *copied;
            beforeEach(^{
                copied = [mutableMetadata mutableCopy];
            });
            
            itBehavesLike(@"a copied metadata instance", ^{
                return @{@"original" : mutableMetadata,
                         @"copy" : copied};
            });

            it(@"returns a different, immutable instance", ^{
                expect(mutableMetadata).toNot.beIdenticalTo(copied);
                expect([copied isKindOfClass:[BTClientMetadata class]]).to.beTruthy();
                expect([copied isKindOfClass:[BTMutableClientMetadata class]]).to.beTruthy();
            });
        });
    });
});

describe(@"metadata", ^{

    __block BTClientMetadata *metadata;

    beforeEach(^{
        metadata = [[BTClientMetadata alloc] init];
    });

    describe(@"init", ^{
        it(@"has expected default values", ^{
            expect(metadata.integration).to.equal(BTClientMetadataIntegrationCustom);
            expect(metadata.source).to.equal(BTClientMetadataSourceUnknown);
        });
    });

    context(@"with non-default values", ^{
        beforeEach(^{
            metadata = ({
                BTMutableClientMetadata *mutableMetadata = [[BTMutableClientMetadata alloc] init];
                mutableMetadata.integration = BTClientMetadataIntegrationDropIn;
                mutableMetadata.source = BTClientMetadataSourcePayPalApp;
                [mutableMetadata copy];
            });
        });

        describe(@"copy", ^{
            __block BTClientMetadata *copied;
            beforeEach(^{
                copied = [metadata copy];
            });
            
            itBehavesLike(@"a copied metadata instance", ^{
                return @{@"original" : metadata,
                         @"copy" : copied};
            });

            it(@"returns a different, immutable instance", ^{
                expect(metadata).toNot.beIdenticalTo(copied);
                expect([copied isKindOfClass:[BTClientMetadata class]]).to.beTruthy();
                expect([copied isKindOfClass:[BTMutableClientMetadata class]]).to.beFalsy();
            });
        });

        describe(@"mutableCopy", ^{
            __block BTMutableClientMetadata *copied;
            beforeEach(^{
                copied = [metadata mutableCopy];
            });
            
            itBehavesLike(@"a copied metadata instance", ^{
                return @{@"original" : metadata,
                         @"copy" : copied};
            });

            it(@"returns a different, immutable instance", ^{
                expect(copied).toNot.beIdenticalTo(metadata);
                expect([copied isKindOfClass:[BTClientMetadata class]]).to.beTruthy();
                expect([copied isKindOfClass:[BTMutableClientMetadata class]]).to.beTruthy();
            });
        });
    });
});

SpecEnd

@interface BTClientMetadata_Tests : XCTestCase
@end

@implementation BTClientMetadata_Tests

- (void)testParameters_ReturnsTheMetadataMetaParametersForPosting {
    BTClientMetadata *metadata = [[BTClientMetadata alloc] init];
    NSDictionary *parameters = metadata.parameters;
    expect(parameters).to.equal(
                                @{@"integration": metadata.integrationString,
                                  @"source": metadata.sourceString,
                                  @"sessionId": metadata.sessionId,
                                  });
}

@end
