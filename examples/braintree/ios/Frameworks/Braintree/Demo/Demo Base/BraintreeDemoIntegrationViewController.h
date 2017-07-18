#import <UIKit/UIKit.h>

@class BraintreeDemoIntegrationViewController;

@protocol IntegrationViewControllerDelegate <NSObject>

- (void)integrationViewController:(BraintreeDemoIntegrationViewController *)integrationViewController didChangeAppSetting:(NSDictionary *)appSetting;

@end

@interface BraintreeDemoIntegrationViewController : UIViewController

@property (nonatomic, weak) id<IntegrationViewControllerDelegate> delegate;

@end
