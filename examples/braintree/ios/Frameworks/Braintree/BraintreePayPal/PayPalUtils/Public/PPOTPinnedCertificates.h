//
//  PPOTPinnedCertificates.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPOTPinnedCertificates : NSObject

/*!
 @brief Returns the set of trusted root certificates

 @return An array of trusted certificates encoded in the DER format, encapsulated in NSData objects.
*/
+ (NSArray *)trustedCertificates;

@end
