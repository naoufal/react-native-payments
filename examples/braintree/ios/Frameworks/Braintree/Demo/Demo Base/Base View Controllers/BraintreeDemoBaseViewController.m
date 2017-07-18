#import "BraintreeDemoBaseViewController.h"

@implementation BraintreeDemoBaseViewController

- (instancetype)initWithCoder:(__unused NSCoder *)aDecoder {
    return [self initWithAuthorization:nil];
}

- (instancetype)initWithNibName:(__unused NSString *)nibNameOrNil bundle:(__unused NSBundle *)nibBundleOrNil {
    return [self initWithAuthorization:nil];
}

- (instancetype)initWithAuthorization:(__unused NSString *)authorization {
    if ([self class] == [BraintreeDemoBaseViewController class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Subclasses must override initWithAuthorization:" userInfo:nil];
    }

    return [super initWithNibName:nil bundle:nil];
}

@end
