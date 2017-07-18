//
//  PPOTConfiguration.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPOTCore.h"
#import "PPOTRequest.h"

@interface PPOTConfigurationRecipe : NSObject <NSCoding>
@property (nonatomic, assign, readwrite) PPOTRequestTarget target;
@property (nonatomic, strong, readwrite) NSNumber *protocolVersion;
@property (nonatomic, strong, readwrite) NSArray  *supportedLocales;  // these have been uppercased, to prevent capitalization mistakes
@property (nonatomic, strong, readwrite) NSString *targetAppURLScheme;
@property (nonatomic, strong, readwrite) NSArray  *targetAppBundleIDs;
@end

@interface PPOTConfigurationRecipeEndpoint : NSObject <NSCoding>
@property (nonatomic, strong, readwrite) NSString *url;
@property (nonatomic, strong, readwrite) NSString *certificateSerialNumber;
@property (nonatomic, strong, readwrite) NSString *base64EncodedCertificate;
@end

@interface PPOTConfigurationOAuthRecipe : PPOTConfigurationRecipe <NSCoding>
@property (nonatomic, strong, readwrite) NSSet *scope;
@property (nonatomic, strong, readwrite) NSDictionary *endpoints; // dictionary of PPOTConfigurationRecipeEndpoint
@end

@interface PPOTConfigurationCheckoutRecipe : PPOTConfigurationRecipe <NSCoding>
// no subclass-specific properties, so far
@end

@interface PPOTConfigurationBillingAgreementRecipe : PPOTConfigurationRecipe <NSCoding>
// no subclass-specific properties, so far
@end

@class PPOTConfiguration;

typedef void (^PPOTConfigurationCompletionBlock)(PPOTConfiguration *currentConfiguration);

@interface PPOTConfiguration : NSObject <NSCoding>

/*!
 @brief In the background: if the cached configuration is stale, then downloads the latest version.
*/
+ (void)updateCacheAsNecessary;

/*!
 @brief Returns the current configuration, either from cache or else the hardcoded default configuration.
*/
+ (PPOTConfiguration *)getCurrentConfiguration;

/*!
 @brief This method is here only for PPOTConfigurationTest.

 @discussion Everyone else, please stick to using [PPOTConfiguration getCurrentConfiguration]!!!
*/
+ (PPOTConfiguration *)configurationWithDictionary:(NSDictionary *)dictionary;

#if DEBUG
+ (void)useHardcodedConfiguration:(BOOL)useHardcodedConfiguration;
#endif

@property (nonatomic, strong, readwrite) NSString *fileTimestamp;
@property (nonatomic, strong, readwrite) NSArray  *prioritizedOAuthRecipes;
@property (nonatomic, strong, readwrite) NSArray  *prioritizedCheckoutRecipes;
@property (nonatomic, strong, readwrite) NSArray  *prioritizedBillingAgreementRecipes;

@end

// The following definitions are for backwards compatibility
@interface PPConfiguration: PPOTConfiguration
@end

@interface PPConfigurationCheckoutRecipe : PPOTConfigurationCheckoutRecipe
@end

@interface PPConfigurationBillingAgreementRecipe : PPOTConfigurationBillingAgreementRecipe
@end

@interface PPConfigurationOAuthRecipe : PPOTConfigurationOAuthRecipe
@end

@interface PPConfigurationRecipeEndpoint : PPOTConfigurationRecipeEndpoint
@end




