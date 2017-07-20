#import "KIFSystemTestActor+BTNetworkActivity.h"

@implementation KIFSystemTestActor (BTNetworkActivity)

- (void)waitForApplicationToSetNetworkActivityIndicatorVisible:(BOOL)visible {
    [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFTestWaitCondition([[UIApplication sharedApplication] isNetworkActivityIndicatorVisible] == visible, error, @"Network activity indicator visiblity was not %@", (visible ? @"YES" : @"NO"));
        return KIFTestStepResultSuccess;
    }];
}

@end
