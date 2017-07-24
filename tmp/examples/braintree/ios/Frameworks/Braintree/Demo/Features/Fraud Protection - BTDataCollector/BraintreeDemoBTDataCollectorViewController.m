#import "BraintreeDemoBTDataCollectorViewController.h"
#import "BTDataCollector.h"
#import <CoreLocation/CLLocationManager.h>
#import "PPDataCollector.h"
#import <PureLayout/PureLayout.h>

@interface BraintreeDemoBTDataCollectorViewController () <BTDataCollectorDelegate>
/// Retain BTDataCollector for entire lifecycle of view controller
@property (nonatomic, strong) BTDataCollector *dataCollector;
@property (nonatomic, strong) UILabel *dataLabel;
@property (nonatomic, strong) BTAPIClient *apiClient;
@end

@implementation BraintreeDemoBTDataCollectorViewController

- (instancetype)initWithAuthorization:(NSString *)authorization {
    if (self = [super initWithAuthorization:authorization]) {
        _apiClient = [[BTAPIClient alloc] initWithAuthorization:authorization];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"BTDataCollector Protection";

    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [collectButton setTitle:@"Collect All Data" forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(tappedCollect) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *collectKountButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [collectKountButton setTitle:@"Collect Kount Data" forState:UIControlStateNormal];
    [collectKountButton addTarget:self action:@selector(tappedCollectKount) forControlEvents:UIControlEventTouchUpInside];

    UIButton *collectDysonButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [collectDysonButton setTitle:@"Collect PayPal Data" forState:UIControlStateNormal];
    [collectDysonButton addTarget:self action:@selector(tappedCollectDyson) forControlEvents:UIControlEventTouchUpInside];

    UIButton *obtainLocationPermissionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [obtainLocationPermissionButton setTitle:@"Obtain Location Permission" forState:UIControlStateNormal];
    [obtainLocationPermissionButton addTarget:self action:@selector(tappedRequestLocationAuthorization:) forControlEvents:UIControlEventTouchUpInside];

    self.dataLabel = [[UILabel alloc] init];
    self.dataLabel.numberOfLines = 0;

    [self.view addSubview:collectButton];
    [self.view addSubview:collectKountButton];
    [self.view addSubview:collectDysonButton];
    [self.view addSubview:obtainLocationPermissionButton];
    [self.view addSubview:self.dataLabel];

    [collectButton autoCenterInSuperviewMargins];
    [collectKountButton autoAlignAxis:ALAxisVertical toSameAxisOfView:collectButton];
    [collectDysonButton autoAlignAxis:ALAxisVertical toSameAxisOfView:collectButton];
    [collectKountButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:collectButton];
    [collectDysonButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:collectKountButton];

    [obtainLocationPermissionButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
    [obtainLocationPermissionButton autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    
    [self.dataLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:collectDysonButton];
    [self.dataLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.dataLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.dataLabel autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    
    self.dataCollector = [[BTDataCollector alloc] initWithAPIClient:self.apiClient];
    self.dataCollector.delegate = self;
}

- (IBAction)tappedCollect
{    self.progressBlock(@"Started collecting all data...");
    [self.dataCollector collectFraudData:^(NSString * _Nonnull deviceData) {
        self.dataLabel.text = deviceData;
    }];
}

- (IBAction)tappedCollectKount {
    self.progressBlock(@"Started collecting Kount data...");
    [self.dataCollector collectCardFraudData:^(NSString * _Nonnull deviceData) {
        self.dataLabel.text = deviceData;
    }];
}

- (IBAction)tappedCollectDyson {
    self.dataLabel.text = [PPDataCollector collectPayPalDeviceData];
    self.progressBlock(@"Collected PayPal clientMetadataID!");
}

- (IBAction)tappedRequestLocationAuthorization:(__unused id)sender {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
}

#pragma mark - BTDataCollectorDelegate

/// The collector has started.
- (void)dataCollectorDidStart:(__unused BTDataCollector *)dataCollector {
    self.progressBlock(@"Data collector did start...");
}

/// The collector finished successfully.
- (void)dataCollectorDidComplete:(__unused BTDataCollector *)dataCollector {
    self.progressBlock(@"Data collector did complete.");
}

/// An error occurred.
///
/// @param error Triggering error
- (void)dataCollector:(__unused BTDataCollector *)dataCollector didFailWithError:(NSError *)error {
    self.progressBlock(@"Error collecting data.");
    NSLog(@"Error collecting data. error = %@", error);
}

@end
