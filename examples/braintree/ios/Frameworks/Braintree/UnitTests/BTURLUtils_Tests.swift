import XCTest

class BTURLUtils_Tests: XCTestCase {

    // MARK: - dictionaryForQueryString:

    func testDictionaryForQueryString_whenQueryStringIsNil_returnsEmptyDictionary() {
        XCTAssertEqual(BTURLUtils.dictionary(forQueryString: nil) as NSDictionary, [:])
    }

    func testDictionaryForQueryString_whenQueryStringIsEmpty_returnsEmptyDictionary() {
        XCTAssertEqual(BTURLUtils.dictionary(forQueryString: "") as NSDictionary, [:])
    }

    func testDictionaryForQueryString_whenQueryStringIsHasItems_returnsDictionaryContainingItems() {
        XCTAssertEqual(BTURLUtils.dictionary(forQueryString: "foo=bar&baz=quux") as NSDictionary, [
            "foo": "bar",
            "baz": "quux"])
    }

    func testDictionaryForQueryString_hasNSNullValueWhenKeyOnly() {
        XCTAssertEqual(BTURLUtils.dictionary(forQueryString: "foo") as NSDictionary, [
            "foo": NSNull(),
        ])
    }

    func testDictionaryForQueryString_whenKeyIsEmpty_hasEmptyStringForKey() {
        XCTAssertEqual(BTURLUtils.dictionary(forQueryString: "&=asdf&") as NSDictionary, [
            "": "asdf"
            ])
    }

    func testDictionaryForQueryString_withDuplicateKeys_usesRightMostValue() {
        XCTAssertEqual(BTURLUtils.dictionary(forQueryString: "key=value1&key=value2") as NSDictionary, [
            "key": "value2"
            ])
    }

    func testDictionaryForQueryString_replacesPlusWithSpace() {
        XCTAssertEqual(BTURLUtils.dictionary(forQueryString: "foo+bar=baz+yaz") as NSDictionary, [
            "foo bar": "baz yaz"
            ])
    }

    func testDictionaryForQueryString_decodesPercentEncodedCharacters() {
        XCTAssertEqual(BTURLUtils.dictionary(forQueryString: "%20%2C=%26") as NSDictionary, [
            " ,": "&"
            ])
    }

    func testDictionaryForQueryString_skipsKeysWithUndecodableCharacters() {
        XCTAssertEqual(BTURLUtils.dictionary(forQueryString: "%84") as NSDictionary, [:])
    }

    // MARK: - URLfromURL:withAppendedQueryDictionary:

    func testURLWithAppendedQueryDictionary_appendsDictionaryAsQueryStringToURL() {
        let url = URL(string: "http://example.com:80/path/to/file")!

        let appendedURL = BTURLUtils.urLfromURL(url, withAppendedQueryDictionary: ["key": "value"])

        XCTAssertEqual(appendedURL, URL(string: "http://example.com:80/path/to/file?key=value"))
    }

    func testURLWithAppendedQueryDictionary_acceptsNilDictionaries() {
        let url = URL(string: "http://example.com")!

        let appendedURL = BTURLUtils.urLfromURL(url, withAppendedQueryDictionary: nil)

        XCTAssertEqual(appendedURL, URL(string: "http://example.com?"))
    }

    func testURLWithAppendedQueryDictionary_whenDictionaryHasKeyValuePairsWithSpecialCharacters_percentEscapesThem() {
        let url = URL(string: "http://example.com")!

        let appendedURL = BTURLUtils.urLfromURL(url, withAppendedQueryDictionary: ["space ": "sym&bol="])

        XCTAssertEqual(appendedURL, URL(string: "http://example.com?space%20=sym%26bol%3D"))
    }

    func testURLWithAppendedQueryDictionary_whenURLIsNil_returnsNil() {
        XCTAssertNil(BTURLUtils.urLfromURL(nil, withAppendedQueryDictionary: [:]))
    }

    func testURLWithAppendedQueryDictionary_whenURLIsRelative_returnsExpectedURL() {
        let url = URL(string: "/relative/path")!

        let appendedURL = BTURLUtils.urLfromURL(url, withAppendedQueryDictionary: ["key": "value"])

        XCTAssertEqual(appendedURL, URL(string: "/relative/path?key=value"))
    }

}
