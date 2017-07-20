//
//  PPOTMacros.m
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTMacros.h"
#import <UIKit/UIKit.h>

@implementation PPOTMacros

+ (NSUInteger)deviceSystemMajorVersion {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@end
