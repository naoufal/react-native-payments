import XCTest

class BTPaymentMethodNonceParser_Tests: XCTestCase {
    
    var parser : BTPaymentMethodNonceParser = BTPaymentMethodNonceParser()

    func testRegisterType_addsTypeToTypes() {
        parser.registerType("MyType") { _ -> BTPaymentMethodNonce? in return nil}

        XCTAssertTrue(parser.allTypes.contains("MyType"))
    }
    
    func testAllTypes_whenTypeIsNotRegistered_doesntContainType() {
        XCTAssertEqual(parser.allTypes.count, 0)
    }
    
    func testIsTypeAvailable_whenTypeIsRegistered_isTrue() {
        parser.registerType("MyType") { _ -> BTPaymentMethodNonce? in return nil}
        XCTAssertTrue(parser.isTypeAvailable("MyType"))
    }
    
    func testIsTypeAvailable_whenTypeIsNotRegistered_isFalse() {
        XCTAssertFalse(parser.isTypeAvailable("MyType"))
    }

    func testParseJSON_whenTypeIsRegistered_callsParsingBlock() {
        let expectation = self.expectation(description: "Parsing block called")
        parser.registerType("MyType") { _ -> BTPaymentMethodNonce? in
            expectation.fulfill()
            return nil
        }
        parser.parseJSON(BTJSON(), withParsingBlockForType: "MyType")

        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testParseJSON_whenTypeIsNotRegisteredAndJSONContainsNonce_returnsBasicTokenizationObject() {
        let json = BTJSON(value: ["nonce": "valid-nonce",
                                  "description": "My Description"])
        
        let paymentMethodNonce = parser.parseJSON(json, withParsingBlockForType: "MyType")
        
        XCTAssertEqual(paymentMethodNonce?.nonce, "valid-nonce")
        XCTAssertEqual(paymentMethodNonce?.localizedDescription, "My Description")
    }
    
    func testParseJSON_whenTypeIsNotRegisteredAndJSONDoesNotContainNonce_returnsNil() {
        let paymentMethodNonce = parser.parseJSON(BTJSON(value: ["description": "blah"]), withParsingBlockForType: "MyType")
        
       XCTAssertNil(paymentMethodNonce)
    }

    // MARK: - Payment-specific tests

    func testSharedParser_whenTypeIsCreditCard_returnsCorrectCardNonce() {
        let sharedParser = BTPaymentMethodNonceParser.shared()

        let creditCardJSON = BTJSON(value: [
            "consumed": false,
            "description": "ending in 31",
            "details": [
                "cardType": "American Express",
                "lastTwo": "31",
            ],
            "isLocked": false,
            "nonce": "0099b1d0-7a1c-44c3-b1e4-297082290bb9",
            "securityQuestions": ["cvv"],
            "threeDSecureInfo": NSNull(),
            "type": "CreditCard",
            "default": true
            ])

        let cardNonce = sharedParser.parseJSON(creditCardJSON, withParsingBlockForType:"CreditCard")!

        XCTAssertEqual(cardNonce.nonce, "0099b1d0-7a1c-44c3-b1e4-297082290bb9")
        XCTAssertEqual(cardNonce.type, "AMEX")
        XCTAssertTrue(cardNonce.isDefault)
    }

    func testSharedParser_whenTypeIsPayPal_returnsPayPalAccountNonce() {
        let sharedParser = BTPaymentMethodNonceParser.shared()
        let payPalAccountJSON = BTJSON(value: [
            "consumed": false,
            "description": "jane.doe@example.com",
            "details": [
                "email": "jane.doe@example.com",
            ],
            "isLocked": false,
            "nonce": "a-nonce",
            "securityQuestions": [],
            "type": "PayPalAccount",
            "default": true
        ])

        let payPalAccountNonce = sharedParser.parseJSON(payPalAccountJSON, withParsingBlockForType: "PayPalAccount") as! BTPayPalAccountNonce

        XCTAssertEqual(payPalAccountNonce.nonce, "a-nonce")
        XCTAssertEqual(payPalAccountNonce.type, "PayPal")
        XCTAssertEqual(payPalAccountNonce.email, "jane.doe@example.com")
        XCTAssertTrue(payPalAccountNonce.isDefault)
        XCTAssertNil(payPalAccountNonce.creditFinancing)
    }

    func testParsePayPalCreditFinancingAmount() {
        let payPalCreditFinancingAmount = BTJSON(value: [
            "currency": "USD",
            "value": "123.45",
        ])

        guard let amount = BTPayPalDriver.creditFinancingAmount(from: payPalCreditFinancingAmount) else {
            XCTFail("Expected amount")
            return
        }
        XCTAssertEqual(amount.currency, "USD")
        XCTAssertEqual(amount.value, "123.45")
    }

    func testParsePayPalCreditFinancing() {
        let payPalCreditFinancing = BTJSON(value: [
            "cardAmountImmutable": false,
            "monthlyPayment": [
                "currency": "USD",
                "value": "123.45",
            ],
            "payerAcceptance": false,
            "term": 3,
            "totalCost": [
                "currency": "ABC",
                "value": "789.01",
            ],
            "totalInterest": [
                "currency": "XYZ",
                "value": "456.78",
            ],
        ])

        guard let creditFinancing = BTPayPalDriver.creditFinancing(from: payPalCreditFinancing) else {
            XCTFail("Expected credit financing")
            return
        }

        XCTAssertFalse(creditFinancing.cardAmountImmutable)
        guard let monthlyPayment = creditFinancing.monthlyPayment else {
            XCTFail("Expected monthly payment details")
            return
        }
        XCTAssertEqual(monthlyPayment.currency, "USD")
        XCTAssertEqual(monthlyPayment.value, "123.45")

        XCTAssertFalse(creditFinancing.payerAcceptance)
        XCTAssertEqual(creditFinancing.term, 3)

        XCTAssertNotNil(creditFinancing.totalCost)

        guard let totalCost = creditFinancing.totalCost else {
            XCTFail("Expected total cost details")
            return
        }
        XCTAssertEqual(totalCost.currency, "ABC")
        XCTAssertEqual(totalCost.value, "789.01")

        guard let totalInterest = creditFinancing.totalInterest else {
            XCTFail("Expected total interest details")
            return
        }
        XCTAssertEqual(totalInterest.currency, "XYZ")
        XCTAssertEqual(totalInterest.value, "456.78")
    }

    func testSharedParser_whenTypeIsPayPal_returnsPayPalAccountNonceWithCreditFinancingOffered() {
        let sharedParser = BTPaymentMethodNonceParser.shared()
        let payPalAccountJSON = BTJSON(value: [
            "consumed": false,
            "description": "jane.doe@example.com",
            "details": [
                "email": "jane.doe@example.com",
                "creditFinancingOffered": [
                    "cardAmountImmutable": true,
                    "monthlyPayment": [
                        "currency": "USD",
                        "value": "13.88",
                    ],
                    "payerAcceptance": true,
                    "term": 18,
                    "totalCost": [
                        "currency": "USD",
                        "value": "250.00",
                    ],
                    "totalInterest": [
                        "currency": "USD",
                        "value": "0.00",
                    ],
                ],
            ],
            "isLocked": false,
            "nonce": "a-nonce",
            "securityQuestions": [],
            "type": "PayPalAccount",
            "default": true,
          ])

        let payPalAccountNonce = sharedParser.parseJSON(payPalAccountJSON, withParsingBlockForType: "PayPalAccount") as! BTPayPalAccountNonce

        XCTAssertEqual(payPalAccountNonce.nonce, "a-nonce")
        XCTAssertEqual(payPalAccountNonce.type, "PayPal")
        XCTAssertEqual(payPalAccountNonce.email, "jane.doe@example.com")
        XCTAssertTrue(payPalAccountNonce.isDefault)

        guard let creditFinancing = payPalAccountNonce.creditFinancing else {
            XCTFail("Expected credit financing terms")
            return
        }

        XCTAssertTrue(creditFinancing.cardAmountImmutable)
        guard let monthlyPayment = creditFinancing.monthlyPayment else {
            XCTFail("Expected monthly payment details")
            return
        }
        XCTAssertEqual(monthlyPayment.currency, "USD")
        XCTAssertEqual(monthlyPayment.value, "13.88")

        XCTAssertTrue(creditFinancing.payerAcceptance)
        XCTAssertEqual(creditFinancing.term, 18)

        XCTAssertNotNil(creditFinancing.totalCost)

        guard let totalCost = creditFinancing.totalCost else {
            XCTFail("Expected total cost details")
            return
        }
        XCTAssertEqual(totalCost.currency, "USD")
        XCTAssertEqual(totalCost.value, "250.00")

        guard let totalInterest = creditFinancing.totalInterest else {
            XCTFail("Expected total interest details")
            return
        }
        XCTAssertEqual(totalInterest.currency, "USD")
        XCTAssertEqual(totalInterest.value, "0.00")
    }

    func testSharedParser_whenTypeIsVenmo_returnsVenmoAccountNonce() {
        let sharedParser = BTPaymentMethodNonceParser.shared()
        let venmoAccountJSON = BTJSON(value: [
            "consumed": false,
            "description": "VenmoAccount",
            "details": ["username": "jane.doe.username@example.com", "cardType": "Discover"],
            "isLocked": false,
            "nonce": "a-nonce",
            "securityQuestions": [],
            "type": "VenmoAccount",
            "default": true
        ])

        let venmoAccountNonce = sharedParser.parseJSON(venmoAccountJSON, withParsingBlockForType: "VenmoAccount") as! BTVenmoAccountNonce

        XCTAssertEqual(venmoAccountNonce.nonce, "a-nonce")
        XCTAssertEqual(venmoAccountNonce.type, "Venmo")
        XCTAssertEqual(venmoAccountNonce.username, "jane.doe.username@example.com")
        XCTAssertTrue(venmoAccountNonce.isDefault)
    }

    func testSharedParser_whenTypeIsApplePayCard_returnsApplePayCardNonce() {
        let sharedParser = BTPaymentMethodNonceParser.shared()
        let applePayCard = BTJSON(value: [
            "consumed": false,
            "description": "Apple Pay Card ending in 11",
            "details": [
                "cardType": "American Express"
            ],
            "isLocked": false,
            "nonce": "a-nonce",
            "securityQuestions": [],
            "type": "ApplePayCard",
            ])

        let applePayCardNonce = sharedParser.parseJSON(applePayCard, withParsingBlockForType: "ApplePayCard") as? BTApplePayCardNonce

        XCTAssertEqual(applePayCardNonce?.nonce, "a-nonce")
        XCTAssertEqual(applePayCardNonce?.type, "American Express")
        XCTAssertEqual(applePayCardNonce?.localizedDescription, "Apple Pay Card ending in 11")
    }

    func testSharedParser_whenTypeIsUnknown_returnsBasePaymentMethodNonce() {
        let sharedParser = BTPaymentMethodNonceParser.shared()
        let JSON = BTJSON(value: [
            "consumed": false,
            "description": "Some thing",
            "details": [],
            "isLocked": false,
            "nonce": "a-nonce",
            "type": "asdfasdfasdf",
            "default": true
            ])

        let unknownNonce = sharedParser.parseJSON(JSON, withParsingBlockForType: "asdfasdfasdf")!

        XCTAssertEqual(unknownNonce.nonce, "a-nonce")
        XCTAssertEqual(unknownNonce.type, "Unknown")
        XCTAssertTrue(unknownNonce.isDefault)
    }
}
