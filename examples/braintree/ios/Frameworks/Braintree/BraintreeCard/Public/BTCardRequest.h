#import "BTCard.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTCardRequest : NSObject

- (instancetype)initWithCard:(BTCard *)card;

@property (nonatomic, strong) BTCard *card;

#pragma mark - UnionPay properties

/*!
 @brief The mobile phone number to use to verify the enrollment via SMS.
*/
@property (nonatomic, copy, nullable) NSString *mobilePhoneNumber;

/*!
 @brief The country code for the mobile phone number. This string should only contain digits.
 @note By default, this is set to 62.
*/
@property (nonatomic, copy, nullable) NSString *mobileCountryCode;

/*!
 @brief The enrollment verification code sent via SMS to the mobile phone number. The code is needed to tokenize a UnionPay card that requires enrollment.
*/
@property (nonatomic, copy, nullable) NSString *smsCode;

/*!
 @brief The UnionPay enrollment ID
*/
@property (nonatomic, copy, nullable) NSString *enrollmentID;

@end

NS_ASSUME_NONNULL_END
