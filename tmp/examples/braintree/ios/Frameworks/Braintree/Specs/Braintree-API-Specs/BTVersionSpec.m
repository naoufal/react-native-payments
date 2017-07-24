#import "Braintree-Version.h"

SpecBegin(BTVersion)

it(@"returns the current version", ^{
    expect(BRAINTREE_VERSION).to.match(@"\\d+\\.\\d+\\.\\d+");
});

SpecEnd
