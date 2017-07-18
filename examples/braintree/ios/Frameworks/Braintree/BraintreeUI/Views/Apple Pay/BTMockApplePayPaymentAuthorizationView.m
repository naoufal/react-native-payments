#import "BTMockApplePayPaymentAuthorizationView.h"

@interface BTMockApplePayPaymentAuthorizationView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) UITableView *tableView;
@end

NSString *const BTMockApplePayPaymentAuthorizationControlCell =  @"BTMockApplePayPaymentAuthorizationControlCell";

@implementation BTMockApplePayPaymentAuthorizationView

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;

        self.tableView = [[UITableView alloc] initWithFrame:self.frame
                                                      style:UITableViewStyleGrouped];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BTMockApplePayPaymentAuthorizationControlCell];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;

        [self addSubview:self.tableView];

        NSDictionary *views = @{ @"tableView": self.tableView };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
    }
    return self;
}

#pragma mark Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    NSParameterAssert(indexPath.row < 2);

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BTMockApplePayPaymentAuthorizationControlCell forIndexPath:indexPath];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BTMockApplePayPaymentAuthorizationControlCell];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"💳 Succeed (4111111111111111)";
            break;
        case 1:
            cell.textLabel.text = @"⛔️ Cancel";
            break;

        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
            [self.delegate mockApplePayPaymentAuthorizationViewDidSucceed:self];
            break;
        case 1:
            [self.delegate mockApplePayPaymentAuthorizationViewDidCancel:self];
        default:
            break;
    }
}

- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(__unused NSInteger)section {
    NSParameterAssert(section == 0);

    return @"Apple Pay - Mock Mode";
}

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    NSParameterAssert(section == 0);
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
    return 1;
}

@end
