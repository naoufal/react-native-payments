#import <Foundation/Foundation.h>

#import "BTThreeDSecureCardNonce.h"

@interface BTThreeDSecureLookupResult : NSObject

@property (nonatomic, copy) NSString *PAReq;
@property (nonatomic, copy) NSString *MD;
@property (nonatomic, copy) NSURL *acsURL;
@property (nonatomic, copy) NSURL *termURL;

@property (nonatomic, strong) BTThreeDSecureCardNonce *tokenizedCard;

- (BOOL)requiresUserAuthentication;

@end
