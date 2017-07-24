#import <Foundation/Foundation.h>

/*!
 @discussion Interprets NSError objects of domain BTHTTPErrorDomain, code
 BTHTTPErrorCodeClientError (status code 422) for Drop-In UI Components.
*/
@interface BTDropInErrorState : NSObject

/*!
 @discussion Initializes a new error state object returned by
 saveCardWithNumber:expirationMonth:expirationYear:cvv:postalCode:validate:success:failure:.

 @param error The error to interpret

 @return a new error state instance
*/
- (instancetype)initWithError:(NSError *)error;

/*!
 @brief Top-level description of error
*/
@property (nonatomic, copy, readonly) NSString *errorTitle;

/*!
 @brief Set of invalid fields to highlight, each represented as a boxed BTUICardFormField
*/
@property (nonatomic, strong, readonly) NSSet *highlightedFields;

@end
