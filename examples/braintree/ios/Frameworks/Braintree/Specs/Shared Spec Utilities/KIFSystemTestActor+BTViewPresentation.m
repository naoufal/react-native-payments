#import "KIFSystemTestActor+BTViewPresentation.h"
#import <PureLayout/PureLayout.h>

@implementation KIFSystemTestActor (BTViewPresentation)

- (void)presentViewController:(UIViewController *)viewController {
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIViewController *viewControllerToPresent = viewController;
        KIFTestCondition(viewControllerToPresent != nil, error, @"Expected a view controller, but got nil");

        UINavigationController *navigationController;
        if ([viewControllerToPresent isKindOfClass:[UINavigationController class]]) {
            navigationController = (UINavigationController *)viewControllerToPresent;
        } else {
            navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;

        return KIFTestStepResultSuccess;
    }];
}

- (void)presentView:(UIView *)view {
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFTestCondition(view != nil, error, @"Expected a view, but got nil");

        UIViewController *viewController = [[UIViewController alloc] init];
        [viewController.view addSubview:view];
        [view autoCenterInSuperview];
        [view autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:viewController.view withOffset:0 relation:NSLayoutRelationLessThanOrEqual];
        [view autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:viewController.view withOffset:0 relation:NSLayoutRelationLessThanOrEqual];
        [self presentViewController:viewController];

        return KIFTestStepResultSuccess;
    }];
}

@end
