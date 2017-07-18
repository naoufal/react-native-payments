//
//  PPOTOAuth2SwitchRequest.h
//  PayPalOneTouch
//
//  Copyright © 2014 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPOTSwitchRequest.h"

@interface PPOTOAuth2SwitchRequest : PPOTSwitchRequest

@property (nonatomic, strong, readwrite) NSArray *scope;
@property (nonatomic, strong, readwrite) NSString *merchantName;
@property (nonatomic, strong, readwrite) NSString *privacyURL;
@property (nonatomic, strong, readwrite) NSString *agreementURL;

@end
