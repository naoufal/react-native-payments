#import "BTAnalyticsMetadata.h"

#import <UIKit/UIKit.h>
#import "BTSpecDependencies.h"

SpecBegin(BTAnalyticsMetadata)

describe(@"metadata", ^{
    it(@"returns a dictionary of analytics metadata", ^{
        expect([BTAnalyticsMetadata metadata]).to.beKindOf([NSDictionary class]);
        expect([[BTAnalyticsMetadata metadata] allKeys]).to.contain(@"platform");
    });

    describe(@"platform", ^{
        it(@"returns \"iOS\"", ^{
            expect([BTAnalyticsMetadata metadata][@"platform"]).to.equal(@"iOS");
        });
    });

    describe(@"platformVersion", ^{
        it(@"returns the iOS version, e.g. 7.0", ^{
            expect([BTAnalyticsMetadata metadata][@"platformVersion"]).to.match(@"^\\d+\\.\\d+(\\.\\d+)?$");
        });
    });

    describe(@"sdkVersion", ^{
        it(@"returns Braintree sdk version", ^{
            expect([BTAnalyticsMetadata metadata][@"sdkVersion"]).to.match(@"^\\d+\\.\\d+\\.\\d+(-[0-9a-zA-Z-]+)?$");
        });
    });
    describe(@"merchantAppId", ^{
        it(@"returns app bundle identifier", ^{
            OCMockObject *mock = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
            [[[mock stub] andReturn:@{ (__bridge NSString *)kCFBundleIdentifierKey: @"com.braintree.Braintree-Demo" }] infoDictionary];

            expect([BTAnalyticsMetadata metadata][@"merchantAppId"]).to.equal(@"com.braintree.Braintree-Demo");

            [mock stopMocking];
        });
    });
    describe(@"merchantAppName", ^{
        it(@"returns the merchant's app version", ^{
            OCMockObject *mock = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
            [[[mock stub] andReturn:@{ (__bridge NSString *)kCFBundleNameKey:@"Braintree Demo" }] infoDictionary];

            expect([BTAnalyticsMetadata metadata][@"merchantAppName"]).to.equal(@"Braintree Demo");

            [mock stopMocking];
        });
    });
    describe(@"merchantAppVersion", ^{
        it(@"returns the merchant's app version", ^{
            OCMockObject *mock = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
            [[[mock stub] andReturn:@{ (__bridge NSString *)kCFBundleVersionKey:@"2.3.4" }] infoDictionary];

            expect([BTAnalyticsMetadata metadata][@"merchantAppVersion"]).to.match(@"2.3.4");

            [mock stopMocking];
        });
    });
    describe(@"deviceRooted", ^{
        it(@"returns true iff the device has been jailbroken", ^{
            expect([[BTAnalyticsMetadata metadata][@"deviceRooted"] boolValue]).to.beFalsy();
        });
    });
    describe(@"deviceManufacturer", ^{
        it(@"returns \"Apple\"", ^{
            expect([BTAnalyticsMetadata metadata][@"deviceManufacturer"]).to.equal(@"Apple");
        });
    });
    describe(@"deviceModel", ^{
        it(@"returns the device model", ^{
            expect([BTAnalyticsMetadata metadata][@"deviceModel"]).to.match(@"iPhone\\d,\\d|i386|x86_64");
        });
    });

    describe(@"deviceAppGeneratedPersistentUuid", ^{
        it(@"returns a UUID", ^{
            NSString *deviceAppGeneratedPersistentUuid = [BTAnalyticsMetadata metadata][@"deviceAppGeneratedPersistentUuid"];
            if (deviceAppGeneratedPersistentUuid) {
                expect(deviceAppGeneratedPersistentUuid).to.match(@"^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$");
            }
        });

        it(@"returns a consistent value", ^{
            expect([BTAnalyticsMetadata metadata][@"deviceAppGeneratedPersistentUuid"]).to.equal([BTAnalyticsMetadata metadata][@"deviceAppGeneratedPersistentUuid"]);
        });
    });

    it(@"deviceNetworkType", ^{
        it(@"returns whether we're on cellular or wifi", ^{
            expect([BTAnalyticsMetadata metadata][@"deviceNetworkType"]).to.equal(@"wifi");
        });
    });
    describe(@"deviceLocationLatitude", ^{
        it(@"returns the devices location if already available", ^{
            expect([BTAnalyticsMetadata metadata][@"deviceLocationLatitude"]).to.beNil();
        });
    });
    describe(@"deviceLocationLongitude", ^{
        it(@"returns the device location if already available", ^{
            expect([BTAnalyticsMetadata metadata][@"deviceLocationLongitude"]).to.beNil();
        });
    });
    describe(@"iosIdentifierForVendor", ^{
        it(@"returns the identifierForVendor", ^{
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"00000000-0000-0000-0000-000000000000"];
            OCMockObject *mock = [OCMockObject partialMockForObject:[UIDevice currentDevice]];
            [[[mock stub] andReturn:uuid] identifierForVendor];

            expect([BTAnalyticsMetadata metadata][@"iosIdentifierForVendor"]).to.equal(uuid.UUIDString);

            [mock stopMocking];
        });
    });
    describe(@"iosIsCocoaPods", ^{
        it(@"is present", ^{
            expect([BTAnalyticsMetadata metadata][@"iosIsCocoapods"]).to.beKindOf([NSNumber class]);
        });
    });
    describe(@"isSimulator", ^{
        it(@"returns true for ios simulators", ^{
            expect([BTAnalyticsMetadata metadata][@"isSimulator"]).to.beTruthy();
        });
    });
    describe(@"deviceScreenOrientation", ^{
        it(@"returns the screen orientation, e.g. Portrait or FaceUp", ^{
            id mockDevice = OCMPartialMock([UIDevice currentDevice]);
            OCMStub([mockDevice orientation]).andReturn(UIDeviceOrientationFaceUp);
            expect([BTAnalyticsMetadata metadata][@"deviceScreenOrientation"]).to.equal(@"FaceUp");
            [mockDevice stopMocking];
        });
        it(@"returns AppExtension when running in an App Extension", ^{
            id stubMainBundle = OCMPartialMock([NSBundle mainBundle]);
            OCMStub([stubMainBundle infoDictionary]).andReturn(@{@"NSExtension": @{}});
            expect([BTAnalyticsMetadata metadata][@"deviceScreenOrientation"]).to.equal(@"AppExtension");
            [stubMainBundle stopMocking];
        });
    });
    describe(@"userInterfaceOrientation", ^{
        it(@"returns the user interface orientation, e.g. Portrait or Landscape", ^{
#ifdef __IPHONE_8_0
            expect([BTAnalyticsMetadata metadata][@"userInterfaceOrientation"]).to.beNil();
#else
            expect([BTAnalyticsMetadata metadata][@"userInterfaceOrientation"]).to.equal(@"Unknown");
#endif

        });
    });
});

SpecEnd
