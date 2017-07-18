//
//  PPOTConfigurationTest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PPOTConfiguration.h"

@interface PPOTConfigurationTest : XCTestCase

@end

@implementation PPOTConfigurationTest

- (void)testPPOTConfiguration_whenBadOS_returnsNilConfig {
    PPOTConfiguration *configuration = [PPOTConfiguration configurationWithDictionary:
                                        @{@"os": @"Android",
                                          @"file_timestamp": @"2014-12-19T16:39:57-08:00",
                                          @"1.0": @{
                                                  }
                                          }];
    XCTAssertNil(configuration);
}

- (void)testPPOTConfiguration_whenMissingExpectedVersion_returnsNilConfig {
    PPOTConfiguration *configuration = [PPOTConfiguration configurationWithDictionary:
                                        @{@"os": @"iOS",
                                          @"file_timestamp": @"2014-12-19T16:39:57-08:00",
                                          @"2.0": @{
                                                  @"oauth2_recipes_in_decreasing_priority_order": @[
                                                          ],
                                                  }
                                          }];
    XCTAssertNil(configuration);
}

- (void)testPPOTConfiguration_whenMultipleVersions_processesExpectedVersionCorrectly {
    PPOTConfiguration *configuration = [PPOTConfiguration configurationWithDictionary:
                                        @{@"os": @"iOS",
                                          @"file_timestamp": @"2014-12-19T16:39:57-08:00",
                                          @"1.0": @{
                                                  @"oauth2_recipes_in_decreasing_priority_order": @[
                                                          ],
                                                  },
                                          @"2.0": @{
                                                  @"foo": @[
                                                          ],
                                                  }
                                          }];
    XCTAssertNotNil(configuration);
    XCTAssertNotNil(configuration.prioritizedOAuthRecipes);
    XCTAssertEqual([configuration.prioritizedOAuthRecipes count], (NSUInteger)0);
}


- (void)testPPOTConfiguration_whenNoOAuthConfigRecipe_loadsConfigWithZeroRecipes {
    PPOTConfiguration *configuration = [PPOTConfiguration configurationWithDictionary:
                                        @{@"os": @"iOS",
                                          @"file_timestamp": @"2014-12-19T16:39:57-08:00",
                                          @"1.0": @{
                                                  @"oauth2_recipes_in_decreasing_priority_order": @[
                                                          ],
                                                  }
                                          }];
    XCTAssertNotNil(configuration);
    XCTAssertNotNil(configuration.prioritizedOAuthRecipes);
    XCTAssertEqual([configuration.prioritizedOAuthRecipes count], (NSUInteger)0);
}

- (void)testPPOTConfiguration_whenGoodOAuthConfigRecipes_loadsMultipleRecipes {
    PPOTConfiguration *configuration = [PPOTConfiguration configurationWithDictionary:
                                        @{@"os": @"iOS",
                                          @"file_timestamp": @"2014-12-19T16:39:57-08:00",
                                          @"1.0": @{
                                                  @"oauth2_recipes_in_decreasing_priority_order": @[
                                                          @{
                                                              @"protocol": @"2",
                                                              @"target": @"wallet",
                                                              @"scope": @[@"*"],
                                                              @"scheme": @"com.paypal.ppclient.touch.v2",
                                                              @"applications": @[@"com.paypal.ppclient", @"com.yourcompany.ppclient"],
                                                              },
                                                          @{
                                                              @"protocol": @"0",
                                                              @"target": @"browser",
                                                              @"scope": @[@"*"],
                                                              },
                                                          ],
                                                  }
                                          }];
    XCTAssertNotNil(configuration);
    XCTAssertNotNil(configuration.prioritizedOAuthRecipes);
    XCTAssertEqual([configuration.prioritizedOAuthRecipes count], (NSUInteger)2);
    XCTAssert([configuration.prioritizedOAuthRecipes[0] isKindOfClass:[PPOTConfigurationOAuthRecipe class]]);
    XCTAssert([configuration.prioritizedOAuthRecipes[1] isKindOfClass:[PPOTConfigurationOAuthRecipe class]]);
}

- (void)testPPOTConfiguration_whenConfigRecipeWithUnknownTargetInList_onlyLoadsRecognizedRecipes {
    PPOTConfiguration *configuration = [PPOTConfiguration configurationWithDictionary:
                                         @{@"os": @"iOS",
                                           @"file_timestamp": @"2014-12-19T16:39:57-08:00",
                                           @"1.0": @{
                                                   @"oauth2_recipes_in_decreasing_priority_order": @[
                                                           @{
                                                               @"target": @"UNKNOWN TARGET",
                                                               @"protocol": @"0",
                                                               @"scope": @[@"*"],
                                                               @"scheme": @"com.paypal.ppclient.touch.v2",
                                                               @"applications": @[@"com.paypal.ppclient", @"com.yourcompany.ppclient"],
                                                               },
                                                           @{
                                                               @"protocol": @"0",
                                                               @"target": @"browser",
                                                               @"scope": @[@"*"],
                                                               },
                                                           ],
                                                   }
                                           }];
    XCTAssertNotNil(configuration);
    XCTAssertNotNil(configuration.prioritizedOAuthRecipes);
    XCTAssertEqual([configuration.prioritizedOAuthRecipes count], (NSUInteger)1);
    XCTAssert([configuration.prioritizedOAuthRecipes[0] isKindOfClass:[PPOTConfigurationOAuthRecipe class]]);

    PPOTConfigurationOAuthRecipe *oauthRecipe = (PPOTConfigurationOAuthRecipe *)configuration.prioritizedOAuthRecipes[0];
    XCTAssertEqual(oauthRecipe.target, PPOTRequestTargetBrowser);
    XCTAssertEqualObjects(oauthRecipe.scope, [NSSet setWithObject:@"*"]);
    XCTAssertEqualObjects(oauthRecipe.protocolVersion, @0);
}

- (void)testPPOTConfiguration_whenConfigRecipeWithUnknownProtocolInList_onlyLoadsRecognizedRecipes {
    PPOTConfiguration *configuration = [PPOTConfiguration configurationWithDictionary:
                                        @{@"os": @"iOS",
                                          @"file_timestamp": @"2014-12-19T16:39:57-08:00",
                                          @"1.0": @{
                                                  @"oauth2_recipes_in_decreasing_priority_order": @[
                                                          @{
                                                              @"target": @"UNKNOWN TARGET",
                                                              @"protocol": @"9999",
                                                              @"scope": @[@"*"],
                                                              @"scheme": @"com.paypal.ppclient.touch.v2",
                                                              @"applications": @[@"com.paypal.ppclient", @"com.yourcompany.ppclient"],
                                                              },
                                                          @{
                                                              @"protocol": @"0",
                                                              @"target": @"browser",
                                                              @"scope": @[@"*"],
                                                              },
                                                          ],
                                                  }
                                          }];
    XCTAssertNotNil(configuration);
    XCTAssertNotNil(configuration.prioritizedOAuthRecipes);
    XCTAssertEqual([configuration.prioritizedOAuthRecipes count], (NSUInteger)1);
    XCTAssert([configuration.prioritizedOAuthRecipes[0] isKindOfClass:[PPOTConfigurationOAuthRecipe class]]);

    PPOTConfigurationOAuthRecipe *oauthRecipe = (PPOTConfigurationOAuthRecipe *)configuration.prioritizedOAuthRecipes[0];
    XCTAssertEqual(oauthRecipe.target, PPOTRequestTargetBrowser);
    XCTAssertEqualObjects(oauthRecipe.scope, [NSSet setWithObject:@"*"]);
    XCTAssertEqualObjects(oauthRecipe.protocolVersion, @0);
}

- (void)testPPOTConfiguration_whenOAuthConfigRecipeWithMissingScopeInList_onlyLoadsRecognizedRecipes {
    PPOTConfiguration *configuration = [PPOTConfiguration configurationWithDictionary:
                                         @{@"os": @"iOS",
                                           @"file_timestamp": @"2014-12-19T16:39:57-08:00",
                                           @"1.0": @{
                                                   @"oauth2_recipes_in_decreasing_priority_order": @[
                                                           @{
                                                               @"target": @"wallet",
                                                               @"scheme": @"com.paypal.ppclient.touch.v2",
                                                               @"applications": @[@"com.paypal.ppclient", @"com.yourcompany.ppclient"],
                                                               },
                                                           @{
                                                               @"target": @"browser",
                                                               @"protocol": @"0",
                                                               @"scope": @[@"*"],
                                                               }
                                                           ],
                                                   }
                                           }];

    XCTAssertNotNil(configuration);
    XCTAssertNotNil(configuration.prioritizedOAuthRecipes);
    XCTAssertEqual([configuration.prioritizedOAuthRecipes count], (NSUInteger)1);
    XCTAssert([configuration.prioritizedOAuthRecipes[0] isKindOfClass:[PPOTConfigurationOAuthRecipe class]]);

    PPOTConfigurationOAuthRecipe *oauthRecipe = (PPOTConfigurationOAuthRecipe *)configuration.prioritizedOAuthRecipes[0];
    XCTAssertEqual(oauthRecipe.target, PPOTRequestTargetBrowser);
    XCTAssertEqualObjects(oauthRecipe.scope, [NSSet setWithObject:@"*"]);
    XCTAssertEqualObjects(oauthRecipe.protocolVersion, @0);
}

- (void)testPPOTConfiguration_whenBrowserRecipeWithMissingURLInProtocol3List_onlyLoadsRecognizedRecipes {
    PPOTConfiguration *configuration = [PPOTConfiguration configurationWithDictionary:
                                         @{@"os": @"iOS",
                                           @"file_timestamp": @"2014-12-19T16:39:57-08:00",
                                           @"1.0": @{
                                                   @"oauth2_recipes_in_decreasing_priority_order": @[
                                                           @{
                                                               @"target": @"wallet",
                                                               @"scope": @[@"*"],
                                                               @"protocol": @"1",
                                                               @"scheme": @"com.paypal.ppclient.touch.v9999",
                                                               @"applications": @[@"com.paypal.ppclient", @"com.yourcompany.ppclient"],
                                                               },
                                                           @{
                                                               @"target": @"browser",
                                                               @"protocol": @"3",
                                                               @"scope": @[@"*"],
                                                               },
                                                           ],
                                                   }
                                           }];

    XCTAssertNotNil(configuration);
    XCTAssertNotNil(configuration.prioritizedOAuthRecipes);
    XCTAssertEqual([configuration.prioritizedOAuthRecipes count], (NSUInteger)1);
    XCTAssert([configuration.prioritizedOAuthRecipes[0] isKindOfClass:[PPOTConfigurationOAuthRecipe class]]);

    PPOTConfigurationOAuthRecipe *oauthRecipe = (PPOTConfigurationOAuthRecipe *)configuration.prioritizedOAuthRecipes[0];
    XCTAssertEqual(oauthRecipe.target, PPOTRequestTargetOnDeviceApplication);
    XCTAssertEqualObjects(oauthRecipe.scope, [NSSet setWithObject:@"*"]);
    XCTAssertEqualObjects(oauthRecipe.protocolVersion, @1);
    XCTAssertEqualObjects(oauthRecipe.targetAppURLScheme, @"com.paypal.ppclient.touch.v9999");
    NSArray *expectedTargetAppBundleIDs = @[@"com.paypal.ppclient", @"com.yourcompany.ppclient"];
    XCTAssertEqualObjects(oauthRecipe.targetAppBundleIDs, expectedTargetAppBundleIDs);
}

- (void)testPPOTConfiguration_whenDifferentBadConfigRecipes_stillLoadsAllGoodRecipes {
    // Expected 1 OAuth, 1 Checkout Recipe
    PPOTConfiguration *configuration = [PPOTConfiguration configurationWithDictionary:
                                        @{@"os": @"iOS",
                                          @"file_timestamp": @"2014-12-19T16:39:57-08:00",
                                          @"1.0": @{
                                                  @"checkout_recipes_in_decreasing_priority_order": @[
                                                          @{
                                                              @"target": @"browser",
                                                              @"protocol": @"9999",
                                                              // Unrecognized Protocol Version
                                                              },
                                                          @{
                                                              @"target": @"wallet",
                                                              @"protocol": @"3",
                                                              @"scheme": @"com.paypal.ppclient.touch.v3",
                                                              @"applications": @[@"com.paypal.ppclient", @"com.yourcompany.ppclient"],
                                                              },
                                                          ],
                                                  @"oauth2_recipes_in_decreasing_priority_order": @[
                                                          @{
                                                              @"protocol": @"1",
                                                              @"target": @"wallet",
                                                              @"scope": @[@"*"],
                                                              @"scheme": @"com.paypal.ppclient.touch.v2",
                                                              @"applications": @[@"com.paypal.ppclient", @"com.yourcompany.ppclient"],
                                                              },
                                                          @{
                                                              @"protocol": @"3",
                                                              @"target": @"browser",
                                                              @"scope": @[@"*"],
                                                              // Missing URL in scope for protocol version 3
                                                              },
                                                          ],
                                                  },
                                          }];

    XCTAssertNotNil(configuration);

    XCTAssertNotNil(configuration.prioritizedOAuthRecipes);
    XCTAssertEqual([configuration.prioritizedOAuthRecipes count], (NSUInteger)1);
    XCTAssert([configuration.prioritizedOAuthRecipes[0] isKindOfClass:[PPOTConfigurationOAuthRecipe class]]);

    PPOTConfigurationOAuthRecipe *oauthRecipe = (PPOTConfigurationOAuthRecipe *)configuration.prioritizedOAuthRecipes[0];
    XCTAssertEqual(oauthRecipe.target, PPOTRequestTargetOnDeviceApplication);
    XCTAssertEqualObjects(oauthRecipe.scope, [NSSet setWithObject:@"*"]);
    XCTAssertEqualObjects(oauthRecipe.protocolVersion, @1);
    XCTAssertEqualObjects(oauthRecipe.targetAppURLScheme, @"com.paypal.ppclient.touch.v2");
    NSArray *expectedTargetAppBundleIDs = @[@"com.paypal.ppclient", @"com.yourcompany.ppclient"];
    XCTAssertEqualObjects(oauthRecipe.targetAppBundleIDs, expectedTargetAppBundleIDs);

    XCTAssertNotNil(configuration.prioritizedCheckoutRecipes);
    XCTAssertEqual([configuration.prioritizedCheckoutRecipes count], (NSUInteger)1);
    XCTAssert([configuration.prioritizedCheckoutRecipes[0] isKindOfClass:[PPOTConfigurationCheckoutRecipe class]]);

    PPOTConfigurationCheckoutRecipe *checkoutRecipe = (PPOTConfigurationCheckoutRecipe *)configuration.prioritizedCheckoutRecipes[0];
    XCTAssertEqual(checkoutRecipe.target, PPOTRequestTargetOnDeviceApplication);
    XCTAssertEqualObjects(checkoutRecipe.protocolVersion, @3);
    XCTAssertEqualObjects(checkoutRecipe.targetAppURLScheme, @"com.paypal.ppclient.touch.v3");
    expectedTargetAppBundleIDs = @[@"com.paypal.ppclient", @"com.yourcompany.ppclient"];
    XCTAssertEqualObjects(checkoutRecipe.targetAppBundleIDs, expectedTargetAppBundleIDs);
}


@end
