#import <Foundation/Foundation.h>
#import "BTThreeDSecureCardNonce.h"

@interface BTThreeDSecureResponse : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSDictionary *threeDSecureInfo;
@property (nonatomic, strong) BTThreeDSecureCardNonce *tokenizedCard;
@property (nonatomic, copy) NSString *errorMessage;

@end
