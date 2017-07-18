#import "BTUISummaryView.h"
#import "BTUI.h"

@interface BTUISummaryView ()
@property (nonatomic, strong) UILabel *slugLabel;
@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@end

@implementation BTUISummaryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];

    // Create subviews
    self.slugLabel = [[UILabel alloc] init];
    self.slugLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.slugLabel.numberOfLines = 0;
    
    self.summaryLabel = [[UILabel alloc] init];
    self.summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.summaryLabel.numberOfLines = 0;
    
    self.amountLabel = [[UILabel alloc] init];
    [self.amountLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [self.amountLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    
    [self setTheme:self.theme];

    // Configure subviews
    [self.slugLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.summaryLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.amountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    // Add subviews
    [self addSubview:self.slugLabel];
    [self addSubview:self.summaryLabel];
    [self addSubview:self.amountLabel];

    // Set content
    [self updateText];
}

- (void)setTheme:(BTUI *)theme {
    [super setTheme:theme];
    self.slugLabel.font = self.theme.controlTitleFont;
    self.summaryLabel.font = self.theme.controlFont;
    self.amountLabel.font = self.theme.controlTitleFont;
}

- (void)updateConstraints {
    NSDictionary *views = @{@"view": self,
                            @"slugLabel": self.slugLabel,
                            @"summaryLabel": self.summaryLabel,
                            @"amountLabel": self.amountLabel };
    NSDictionary *metrics = @{@"height": @65.0f,
                              @"topPadding": @10.0f,
                              @"middlePadding": @2,
                              @"horizontalMargin": @(self.theme.horizontalMargin)};

    // View Constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(>=height)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];

    // Slug and Amount Label Constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(horizontalMargin)-[slugLabel]-[amountLabel]-(horizontalMargin)-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];

    // Summary Label Constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(horizontalMargin)-[summaryLabel]-(horizontalMargin)-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];

    // Vertical Constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topPadding)-[slugLabel]-(middlePadding)-[summaryLabel]-(topPadding)-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topPadding)-[amountLabel]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];

    [super updateConstraints];
}

- (void)setSlug:(NSString *)slug {
    _slug = slug;
    [self updateText];
}

- (void)setSummary:(NSString *)summary {
    _summary = summary;
    [self updateText];
}

- (void)setAmount:(NSString *)amount {
    _amount = amount;
    [self updateText];
}

- (void)updateText {
    self.slugLabel.text = self.slug;
    self.summaryLabel.text = self.summary;
    self.amountLabel.text = self.amount;
}

@end
