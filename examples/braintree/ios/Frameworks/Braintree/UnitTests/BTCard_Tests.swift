import XCTest

// See also BTCard_Internal_Tests
class BTCard_Tests: XCTestCase {
    func testInitialization_savesStandardProperties() {
        let card = BTCard(number: "4111111111111111", expirationMonth:"12", expirationYear:"2038", cvv: "123")

        XCTAssertEqual(card.number!, "4111111111111111")
        XCTAssertEqual(card.expirationMonth!, "12")
        XCTAssertEqual(card.expirationYear!, "2038")
        XCTAssertNil(card.postalCode)
        XCTAssertEqual(card.cvv!, "123")
    }

    func testInitialization_acceptsNilCvv() {
        let card = BTCard(number: "4111111111111111", expirationMonth: "12", expirationYear: "2038", cvv: nil)
        XCTAssertNil(card.cvv)
    }

    func testInitialization_withoutParameters() {
        let card = BTCard()

        card.number = "4111111111111111"
        card.expirationMonth = "12"
        card.expirationYear = "2038"
        card.cvv = "123"

        XCTAssertEqual(card.number!, "4111111111111111")
        XCTAssertEqual(card.expirationMonth!, "12")
        XCTAssertEqual(card.expirationYear!, "2038")
        XCTAssertNil(card.postalCode)
        XCTAssertEqual(card.cvv!, "123")
    }

    func testInitWithParameters_withAllValuesPresent_setsAllProperties() {
        let card = BTCard(parameters: [
            "number": "4111111111111111",
            "expiration_date": "12/20",
            "cvv": "123",
            "billing_address": [
                "street_address": "123 Townsend St",
                "locality": "San Francisco",
                "region": "CA",
                "country_name": "United States of America",
                "country_code_alpha2": "US",
                "postal_code": "94107"
            ],
            "options": ["validate": true],
            "cardholder_name": "Brian Tree"
            ])

        XCTAssertEqual(card.number, "4111111111111111")
        XCTAssertEqual(card.expirationMonth, "12")
        XCTAssertEqual(card.expirationYear, "20")
        XCTAssertEqual(card.postalCode, "94107")
        XCTAssertEqual(card.cvv, "123")
        XCTAssertTrue(card.shouldValidate)
        XCTAssertEqual(card.cardholderName, "Brian Tree")
        XCTAssertEqual(card.streetAddress, "123 Townsend St")
        XCTAssertEqual(card.locality, "San Francisco")
        XCTAssertEqual(card.region, "CA")
        XCTAssertEqual(card.countryName, "United States of America")
        XCTAssertEqual(card.countryCodeAlpha2, "US")
        XCTAssertEqual(card.postalCode, "94107")
    }

    func testInitWithParameters_withEmptyParameters_setsPropertiesToExpectedValues() {
        let card = BTCard(parameters: [:])

        XCTAssertNil(card.number)
        XCTAssertNil(card.expirationMonth)
        XCTAssertNil(card.expirationYear)
        XCTAssertNil(card.postalCode)
        XCTAssertNil(card.cvv)
        XCTAssertNil(card.cardholderName)
        XCTAssertFalse(card.shouldValidate)
        XCTAssertNil(card.streetAddress)
        XCTAssertNil(card.locality)
        XCTAssertNil(card.region)
        XCTAssertNil(card.countryName)
        XCTAssertNil(card.countryCodeAlpha2)
    }

    func testInitWithParameters_withCVVAndPostalCode_setsPropertiesToExpectedValues() {
        let card = BTCard(parameters: [
            "cvv": "123",
            "billing_address": ["postal_code": "94949"],
            ])

        XCTAssertNil(card.number)
        XCTAssertNil(card.expirationMonth)
        XCTAssertNil(card.expirationYear)
        XCTAssertEqual(card.postalCode, "94949")
        XCTAssertEqual(card.cvv, "123")
        XCTAssertFalse(card.shouldValidate)
    }

    func testParameters_whenInitializedWithInitWithParameters_returnsExpectedValues() {
        let card = BTCard(parameters: [
            "number": "4111111111111111",
            "expiration_date": "12/20",
            "cvv": "123",
            "billing_address": [
                "street_address": "123 Townsend St",
                "locality": "San Francisco",
                "region": "CA",
                "country_name": "United States of America",
                "country_code_alpha2": "US",
                "postal_code": "94107"
            ],
            "options": ["validate": false],
            "cardholder_name": "Brian Tree"
            ])

        XCTAssertEqual(card.parameters() as NSObject, [
            "number": "4111111111111111",
            "expiration_date": "12/20",
            "cvv": "123",
            "billing_address": [
                "street_address": "123 Townsend St",
                "locality": "San Francisco",
                "region": "CA",
                "country_name": "United States of America",
                "country_code_alpha2": "US",
                "postal_code": "94107"
            ],
            "options": ["validate": false],
            "cardholder_name": "Brian Tree"
            ] as NSObject)
    }

    func testParameters_whenInitializedWithCustomParameters_returnsExpectedValues() {
        let card = BTCard(parameters: [
            "cvv": "123",
            "billing_address": ["postal_code": "94949"],
            "options": ["foo": "bar"],
            ])

        XCTAssertEqual(card.parameters() as NSObject, [
            "cvv": "123",
            "billing_address": ["postal_code": "94949"],
            "options": [
                "foo": "bar",
                "validate": false,
            ],
            ] as NSObject)
    }

    func testParameters_whenShouldValidateIsSetToNewValue_returnsExpectedValues() {
        let card = BTCard(parameters: ["options": ["validate": false]])
        card.shouldValidate = true
        XCTAssertEqual(card.parameters() as NSObject, [
            "options": [ "validate": true ],
            ] as NSObject)
    }
}
