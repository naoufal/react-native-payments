#import <Foundation/Foundation.h>

@interface BTCardCapabilities : NSObject

@property (nonatomic, assign) BOOL isUnionPay;
@property (nonatomic, assign) BOOL isDebit;
@property (nonatomic, assign) BOOL supportsTwoStepAuthAndCapture;
@property (nonatomic, assign) BOOL isSupported;

@end
