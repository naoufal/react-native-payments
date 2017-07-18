import XCTest

class BTJSON_Tests: XCTestCase {
    func testEmptyJSON() {
        let empty = BTJSON()

        XCTAssertNotNil(empty)

        XCTAssertTrue(empty.isObject)

        XCTAssertNil(empty.asString())
        XCTAssertNil(empty.asArray())
        XCTAssertNil(empty.asNumber())
        XCTAssertNil(empty.asURL())
        XCTAssertNil(empty.asStringArray())
        XCTAssertNil(empty.asError())

        XCTAssertFalse(empty.isString)
        XCTAssertFalse(empty.isNumber)
        XCTAssertFalse(empty.isArray)
        XCTAssertFalse(empty.isTrue)
        XCTAssertFalse(empty.isFalse)
        XCTAssertFalse(empty.isNull)
    }

    func testInitializationFromValue() {
        let string = BTJSON(value: "")
        XCTAssertTrue(string.isString)

        let truth = BTJSON(value: true)
        XCTAssertTrue(truth.isTrue)

        let falsehood = BTJSON(value: false)
        XCTAssertTrue(falsehood.isFalse)

        let number = BTJSON(value: 42)
        XCTAssertTrue(number.isNumber)

        let ary = BTJSON(value: [1,2,3])
        XCTAssertTrue(ary.isArray)

        let obj = BTJSON(value: ["one": 1, "two": 2])
        XCTAssertTrue(obj.isObject)

        let null = BTJSON(value: NSNull())
        XCTAssertTrue(null.isNull)
    }

    func testInitializationFromEmptyData() {
        let emptyDataJSON = BTJSON(data: Data())
        XCTAssertTrue(emptyDataJSON.isError)
    }

    func testStringJSON() {
        let JSON = "\"Hello, JSON!\"".data(using: String.Encoding.utf8)!
        let string = BTJSON(data: JSON)

        XCTAssertTrue(string.isString)
        XCTAssertEqual(string.asString()!, "Hello, JSON!")
    }

    func testArrayJSON() {
        let JSON = "[\"One\", \"Two\", \"Three\"]".data(using: String.Encoding.utf8)!
        let array = BTJSON(data: JSON)

        XCTAssertTrue(array.isArray)
        XCTAssertEqual((array as BTJSON).asArray()! as NSArray, ["One", "Two", "Three"])
    }

    func testArrayAccess() {
        let JSON = "[\"One\", \"Two\", \"Three\"]".data(using: String.Encoding.utf8)!
        let array = BTJSON(data: JSON)

        XCTAssertTrue(array[0].isString)
        XCTAssertEqual(array[0].asString()!, "One")
        XCTAssertEqual(array[1].asString()!, "Two")
        XCTAssertEqual(array[2].asString()!, "Three")

        XCTAssertNil(array[3].asString())
        XCTAssertFalse(array[3].isString)

        XCTAssertNil((array["hello"] as AnyObject).asString())
    }

    func testObjectAccess() {
        let JSON = "{ \"key\": \"value\" }".data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)
        
        XCTAssertEqual((obj["key"] as AnyObject).asString()!, "value")

        XCTAssertNil((obj["not present"] as AnyObject).asString())
        XCTAssertNil(obj[0].asString())

        XCTAssertFalse((obj["not present"] as AnyObject).isError as Bool)

        XCTAssertTrue(obj[0].isError)
    }

    func testParsingError() {
        let JSON = "INVALID JSON".data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)

        XCTAssertTrue(obj.isError)
        guard let error = obj as? NSError else {return}
        XCTAssertEqual(error.domain, NSCocoaErrorDomain)
    }

    func testMultipleErrorsTakesFirst() {
        let JSON = "INVALID JSON".data(using: String.Encoding.utf8)!
        let string = BTJSON(data: JSON)
        
        let error = (((string[0])["key"] as! BTJSON)[0])

        XCTAssertTrue(error.isError as Bool)
        guard let err = error as? NSError else {return}
        XCTAssertEqual(err.domain, NSCocoaErrorDomain)
    }

    func testNestedObjects() {
        let JSON = "{ \"numbers\": [\"one\", \"two\", { \"tens\": 0, \"ones\": 1 } ], \"truthy\": true }".data(using: String.Encoding.utf8)!
        let nested = BTJSON(data: JSON)

        XCTAssertEqual((nested["numbers"] as! BTJSON)[0].asString()!, "one")
        XCTAssertEqual((nested["numbers"] as! BTJSON)[1].asString()!, "two")
        XCTAssertEqual(((nested["numbers"] as! BTJSON)[2]["tens"] as! BTJSON).asNumber()!, NSDecimalNumber.zero)
        XCTAssertEqual(((nested["numbers"] as! BTJSON)[2]["ones"] as! BTJSON).asNumber()!, NSDecimalNumber.one)
        XCTAssertTrue((nested["truthy"] as! BTJSON).isTrue as Bool)
    }

    func testTrueBoolInterpretation() {
        let JSON = "true".data(using: String.Encoding.utf8)!
        let truthy = BTJSON(data: JSON)
        XCTAssertTrue(truthy.isTrue)
        XCTAssertFalse(truthy.isFalse)
    }

    func testFalseBoolInterpretation() {
        let JSON = "false".data(using: String.Encoding.utf8)!
        let truthy = BTJSON(data: JSON)
        XCTAssertFalse(truthy.isTrue)
        XCTAssertTrue(truthy.isFalse)
    }

    func testAsURL() {
        let JSON = "{ \"url\": \"http://example.com\" }".data(using: String.Encoding.utf8)!
        let url = BTJSON(data: JSON)
        XCTAssertEqual((url["url"] as AnyObject).asURL()!, URL(string: "http://example.com")!)
    }

    func testAsURLForInvalidValue() {
        let JSON = "{ \"url\": 42 }".data(using: String.Encoding.utf8)!
        let url = BTJSON(data: JSON)
        XCTAssertNil((url["url"] as AnyObject).asURL())
    }

    func testAsStringArray() {
        let JSON = "[\"one\", \"two\", \"three\"]".data(using: String.Encoding.utf8)!
        let stringArray = BTJSON(data: JSON)
        XCTAssertEqual(stringArray.asStringArray()!, ["one", "two", "three"])
    }

    func testAsStringArrayForInvalidValue() {
        let JSON = "[1, 2, false]".data(using: String.Encoding.utf8)!
        let stringArray = BTJSON(data: JSON)
        XCTAssertNil(stringArray.asStringArray())
    }

    func testAsStringArrayForHeterogeneousValue() {
        let JSON = "[\"string\", false]".data(using: String.Encoding.utf8)!
        let stringArray = BTJSON(data: JSON)
        XCTAssertNil(stringArray.asStringArray())
    }

    func testAsStringArrayForEmptyArray() {
        let JSON = "[]".data(using: String.Encoding.utf8)!
        let stringArray = BTJSON(data: JSON)
        XCTAssertEqual(stringArray.asStringArray()!, [])
    }

    func testAsDictionary() {
        let JSON = "{ \"key\": \"value\" }".data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)

        XCTAssertEqual((obj.asDictionary()! as AnyObject) as! NSDictionary, ["key":"value"] as NSDictionary)
    }

    func testAsDictionaryInvalidValue() {
        let JSON = "[]".data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)

        XCTAssertNil(obj.asDictionary())
    }

    func testAsIntegerOrZero() {
        let cases = [
            "1": 1,
            "1.2": 1,
            "1.5": 1,
            "1.9": 1,
            "-4": -4,
            "0": 0,
            "\"Hello\"": 0,
        ]
        for (k,v) in cases {
            let JSON = BTJSON(data: k.data(using: String.Encoding.utf8)!)
            XCTAssertEqual(JSON.asIntegerOrZero(), v)
        }
    }

    func testAsEnumOrDefault() {
        let JSON = "\"enum one\"".data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)

        XCTAssertEqual(obj.asEnum(["enum one" : 1], orDefault: 0), 1)
    }

    func testAsEnumOrDefaultWhenMappingNotPresentReturnsDefault() {
        let JSON = "\"enum one\"".data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)

        XCTAssertEqual(obj.asEnum(["enum two" : 2], orDefault: 1000), 1000)
    }

    func testAsEnumOrDefaultWhenMapValueIsNotNumberReturnsDefault() {
        let JSON = "\"enum one\"".data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)

        XCTAssertEqual(obj.asEnum(["enum one" : "one"], orDefault: 1000), 1000)
    }

    func testIsNull() {
        let JSON = "null".data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)

        XCTAssertTrue(obj.isNull);
    }

    func testIsObject() {
        let JSON = "{}".data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)

        XCTAssertTrue(obj.isObject);
    }

    func testIsObjectForNonObject() {
        let JSON = "[]".data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)

        XCTAssertFalse(obj.isObject);
    }

    func testLargerMixedJSONWithEmoji() {
        let JSON = ("{" +
            "\"aString\": \"Hello, JSON 😍!\"," +
            "\"anArray\": [1, 2, 3 ]," +
            "\"aSetOfValues\": [\"a\", \"b\", \"c\"]," +
            "\"aSetWithDuplicates\": [\"a\", \"a\", \"b\", \"b\" ]," +
            "\"aLookupDictionary\": {" +
            "\"foo\": { \"definition\": \"A meaningless word\"," +
            "\"letterCount\": 3," +
            "\"meaningful\": false }" +
            "}," +
            "\"aURL\": \"https://test.example.com:1234/path\"," +
            "\"anInvalidURL\": \":™£¢://://://???!!!\"," +
            "\"aTrue\": true," +
            "\"aFalse\": false" +
            "}").data(using: String.Encoding.utf8)!
        let obj = BTJSON(data: JSON)
        XCTAssertEqual((obj["aString"] as! BTJSON).asString(), "Hello, JSON 😍!")
        XCTAssertNil((obj["notAString"] as! BTJSON).asString()) // nil for absent keys
        XCTAssertNil((obj["anArray"] as! BTJSON).asString()) // nil for invalid values
        XCTAssertEqual((obj["anArray"] as! BTJSON).asArray()! as NSArray, [1, 2, 3])
        XCTAssertNil((obj["notAnArray"] as! BTJSON).asArray()) // nil for absent keys
        XCTAssertNil((obj["aString"] as! BTJSON).asArray()) // nil for invalid values
        // sets can be parsed as arrays:
        XCTAssertEqual((obj["aSetOfValues"] as! BTJSON).asArray()! as NSArray, ["a", "b", "c"])
        XCTAssertEqual((obj["aSetWithDuplicates"] as! BTJSON).asArray()! as NSArray, ["a", "a", "b", "b"])
        let dictionary = (obj["aLookupDictionary"] as! BTJSON).asDictionary()!
        let foo = dictionary["foo"]! as! Dictionary<String, AnyObject>
        XCTAssertEqual((foo["definition"] as! String), "A meaningless word")
        let letterCount = foo["letterCount"] as! NSNumber
        XCTAssertEqual(letterCount, 3)
        XCTAssertFalse(foo["meaningful"] as! Bool)
        XCTAssertNil((obj["notADictionary"] as AnyObject).asDictionary())
        XCTAssertNil((obj["aString"] as AnyObject).asDictionary())
        XCTAssertEqual((obj["aURL"] as AnyObject).asURL(), URL(string: "https://test.example.com:1234/path"))
        XCTAssertNil((obj["notAURL"] as AnyObject).asURL())
        XCTAssertNil((obj["aString"] as AnyObject).asURL())
        XCTAssertNil((obj["anInvalidURL"] as AnyObject).asURL()) // nil for invalid URLs
        // nested resources:
        let btJson = (obj["aLookupDictionary"] as! BTJSON).asDictionary() as! [String: AnyObject]
        XCTAssertEqual((btJson["foo"] as! NSDictionary)["definition"] as! String, "A meaningless word")
        XCTAssert((((obj["aLookupDictionary"] as! BTJSON)["aString"] as! BTJSON)["anyting"] as! BTJSON).isError as Bool)
    }
}
