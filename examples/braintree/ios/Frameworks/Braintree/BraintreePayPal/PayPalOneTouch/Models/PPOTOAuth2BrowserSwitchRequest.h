//
//  PPOTOAuth2BrowserSwitchRequest.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTOAuth2SwitchRequest.h"

@interface PPOTOAuth2BrowserSwitchRequest : PPOTOAuth2SwitchRequest

/*!
 @brief endpoint to which the browser should be directed
*/
@property (nonatomic) NSString *endpoint;

/*!
 @brief the serial number extracted from the X.509 cert, which was used to encrypt the payloadEnc field.
*/
@property (nonatomic) NSString *keyID;

/*!
 @brief a one time unique ID generated for this payment request
*/
@property (nonatomic, readonly) NSString *msgID;

/*!
 @brief hexadecimal representation of 256-bit symmetric AES key
*/
@property (nonatomic) NSString *encryptionKey;

/*!
 @brief additional key/value pairs that OTC will add to the payload

 @discussion (For example, the Braintree client_token, which is required by the temporary Braintree Future Payments consent webpage.)
*/
@property (nonatomic) NSDictionary *additionalPayloadAttributes;

@property (nonatomic) NSData *certificate;

@end
