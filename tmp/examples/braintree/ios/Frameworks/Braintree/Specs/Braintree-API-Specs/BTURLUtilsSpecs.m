#import "BTURLUtils.h"

SpecBegin(BTURLUtils)

describe(@"URLfromURL:withAppendedQueryDictionary:", ^{
    it(@"appends a dictionary to a url as a query string", ^{
        expect([BTURLUtils URLfromURL:[NSURL URLWithString:@"http://example.com:80/path/to/file"] withAppendedQueryDictionary:@{ @"key": @"value" }]).to.equal([NSURL URLWithString:@"http://example.com:80/path/to/file?key=value"]);
    });

    it(@"accepts a nil dictionary", ^{
        expect([BTURLUtils URLfromURL:[NSURL URLWithString:@"http://example.com"] withAppendedQueryDictionary:nil]).to.equal([NSURL URLWithString:@"http://example.com?"]);
    });

    it(@"precent escapes the query parameters", ^{
        expect([BTURLUtils URLfromURL:[NSURL URLWithString:@"http://example.com"] withAppendedQueryDictionary:@{ @"space ": @"sym&bol=" }]).to.equal([NSURL URLWithString:@"http://example.com?space%20=sym%26bol%3D"]);
    });

    it(@"passes a nil URL", ^{
        expect([BTURLUtils URLfromURL:nil withAppendedQueryDictionary:@{ @"space ": @"sym&bol=" }]).to.beNil();
    });

    it(@"accepts relative URLs", ^{
        expect([BTURLUtils URLfromURL:[NSURL URLWithString:@"/relative/path"] withAppendedQueryDictionary:@{ @"key": @"value" }]).to.equal([NSURL URLWithString:@"/relative/path?key=value"]);
    });
});

describe(@"dictionaryForQueryString:", ^{
    it(@"returns an empty dictionary for a nil query string", ^{
        expect([BTURLUtils dictionaryForQueryString:nil]).to.equal(@{});
    });

    it(@"returns an empty dictionary for an empty query string", ^{
        expect([BTURLUtils dictionaryForQueryString:@""]).to.equal(@{});
    });

    it(@"returns a dictionary containing items from the query string", ^{
        expect([BTURLUtils dictionaryForQueryString:@"foo=bar&baz=quux"]).to.equal(@{ @"foo": @"bar", @"baz": @"quux" });
    });

    it(@"URL decodes entities from query string keys and values", ^{
        expect([BTURLUtils dictionaryForQueryString:@"IHaveEquals%3D=IHaveComma%2C"]).to.equal(@{ @"IHaveEquals=": @"IHaveComma," });
    });

    it(@"URL decodes entities from query string keys and values", ^{
        expect([BTURLUtils dictionaryForQueryString:@"key+with%20spaces=value"]).to.equal(@{ @"key with spaces": @"value" });
    });

    it(@"returns a dictionary with [NSNull null] values for keys that don't have values", ^{
        expect([BTURLUtils dictionaryForQueryString:@"key"]).to.equal(@{ @"key": [NSNull null] });
    });

    it(@"returns a dictionary with empty string values for key=", ^{
        expect([BTURLUtils dictionaryForQueryString:@"key="]).to.equal(@{ @"key": @"" });
    });

    it(@"represents empty keys with the empty string", ^{
        expect([BTURLUtils dictionaryForQueryString:@"&=asdf&"]).to.equal(@{ @"": @"asdf" });
    });

    it(@"keeps the right-most value for duplicate keys", ^{
        expect([BTURLUtils dictionaryForQueryString:@"key=value1&key=value2"]).to.equal(@{ @"key": @"value2" });
    });
});

SpecEnd
