#import "BTDropInSelectPaymentMethodViewController.h"
#import "BTDropInUtil.h"
#import "BTUIViewUtil.h"
#import "BTUI.h"
#import "BTDropInViewController.h"
#import "BTDropInLocalizedString.h"
#import "BTUILocalizedString.h"

@interface BTDropInSelectPaymentMethodViewController ()

@end

@implementation BTDropInSelectPaymentMethodViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAdd)];
        self.tableView.accessibilityIdentifier = @"Payment Methods Table";
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark -

- (void)didTapAdd {
    [self.delegate selectPaymentMethodViewControllerDidRequestNew:self];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    return self.paymentMethodNonces.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *paymentMethodCellIdentifier = @"paymentMethodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:paymentMethodCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:paymentMethodCellIdentifier];
    }

    BTPaymentMethodNonce *paymentInfo = self.paymentMethodNonces[indexPath.row];

    BTUIPaymentOptionType paymentOptionType = [BTUI paymentOptionTypeForPaymentInfoType:paymentInfo.type];
    NSString *typeString = [BTUIViewUtil nameForPaymentMethodType:paymentOptionType];
    NSAttributedString *paymentOptionTypeString = [[NSAttributedString alloc] initWithString:typeString attributes:@{ NSFontAttributeName : self.theme.controlTitleFont }];
    cell.textLabel.attributedText = paymentOptionTypeString;
    cell.detailTextLabel.text = paymentInfo.localizedDescription;

    BTUIVectorArtView *iconArt = [[BTUI braintreeTheme] vectorArtViewForPaymentInfoType:paymentInfo.type];
    UIImage *icon = [iconArt imageOfSize:CGSizeMake(42, 23)];
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.imageView.image = icon;
    cell.accessoryType = (indexPath.row == self.selectedPaymentMethodIndex) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(__unused UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedPaymentMethodIndex = indexPath.row;
    [self.tableView reloadData];
    [self.delegate selectPaymentMethodViewController:self didSelectPaymentMethodAtIndex:indexPath.row];
}

@end
