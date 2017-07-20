#import "BTCardCapabilities.h"

@implementation BTCardCapabilities

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ isUnionPay = %@, isDebit = %@, isSupported = %@, supportsTwoStepAuthAndCapture = %@", [super description], @(self.isUnionPay), @(self.isDebit), @(self.isSupported), @(self.supportsTwoStepAuthAndCapture)];
}

@end
