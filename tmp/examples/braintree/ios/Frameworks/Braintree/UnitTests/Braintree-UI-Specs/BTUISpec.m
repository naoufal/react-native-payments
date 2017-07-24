#import <UIKit/UIKit.h>
#import "BTSpecDependencies.h"
#import "BTUI.h"

SpecBegin(BTUI)

describe(@"BTUI", ^{
    it(@"has a braintree theme", ^{
        BTUI *theme = [BTUI braintreeTheme];
        expect(theme.callToActionColor).notTo.beNil();
    });
});

describe(@"activity indicator style", ^{
    it(@"returns white for a dark background", ^{
        expect([BTUI activityIndicatorViewStyleForBarTintColor:[UIColor blackColor]]).to.equal(UIActivityIndicatorViewStyleWhite);
    });

    it(@"returns gray for a light background", ^{
        expect([BTUI activityIndicatorViewStyleForBarTintColor:[UIColor whiteColor]]).to.equal(UIActivityIndicatorViewStyleGray);
    });
});

SpecEnd
