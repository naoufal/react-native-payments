#import "BraintreeDemoUIWidgetsViewController.h"


@interface BraintreeDemoUIWidgetsViewController ()
@end

@implementation BraintreeDemoUIWidgetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UI Components";

    UIStoryboard *uiStoryboard = [UIStoryboard storyboardWithName:@"UI" bundle:nil];

    UIViewController *v = [uiStoryboard instantiateInitialViewController];

    [self addChildViewController:v];
    [self.view addSubview:v.view];
    [v didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}

@end
