#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double BraintreeUnionPayVersionNumber;

FOUNDATION_EXPORT const unsigned char BraintreeUnionPayVersionString[];

#if __has_include("BraintreeCard.h")
#import "BraintreeCard.h"
#else
#import <BraintreeCard/BraintreeCard.h>
#endif
#import "BTCardCapabilities.h"
#import "BTCardClient+UnionPay.h"
#import "BTConfiguration+UnionPay.h"
