import XCTest

class BTThreeDSecureDriver_Tests: XCTestCase {

    let originalNonce_lookupEnrolledAuthenticationNotRequired = "some-credit-card-nonce-where-3ds-succeeds-without-user-authentication"
    let originalNonce_lookupEnrolledAuthenticationRequired = "some-credit-card-nonce-where-3ds-succeeds-after-user-authentication"
    let originalNonce_lookupCardNotEnrolled = "some-credit-card-nonce-where-card-is-not-enrolled-for-3ds"
    let viewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
    var mockAPIClient : MockAPIClient = MockAPIClient(authorization: "development_client_key")!
    var observers : [NSObjectProtocol] = []

    override func setUp() {
        super.setUp()
        
        mockAPIClient = MockAPIClient(authorization: "development_client_key")!
    }
    
    override func tearDown() {
        for observer in observers { NotificationCenter.default.removeObserver(observer) }
        super.tearDown()
    }
    
    func testInitialization_initializesWithClientAndDelegate() {
        let threeDSecureDriver = BTThreeDSecureDriver.init(apiClient: mockAPIClient, delegate:viewControllerPresentingDelegate )
        XCTAssertNotNil(threeDSecureDriver)
    }
    
    func testVerification_whenAPIClientIsNil_callsBackWithError() {
        let threeDSecureDriver = BTThreeDSecureDriver.init(apiClient: mockAPIClient, delegate:viewControllerPresentingDelegate )
        threeDSecureDriver.apiClient = nil
        
        let expectation = self.expectation(description: "verification fails with errors")

        threeDSecureDriver.verifyCard(withNonce: originalNonce_lookupEnrolledAuthenticationNotRequired, amount: NSDecimalNumber.one, completion: { (tokenizedCard, error) -> Void in
            XCTAssertNil(tokenizedCard)
            XCTAssertNotNil(error)
            guard let error = error as? NSError else {return}
            XCTAssertEqual(error.domain, BTThreeDSecureErrorDomain)
            XCTAssertEqual(error.code, BTThreeDSecureErrorType.integration.rawValue)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testVerification_whenRemoteConfigurationFetchFails_callsBackWithConfigurationError() {
        mockAPIClient.cannedConfigurationResponseError = NSError(domain: "", code: 0, userInfo: nil)
        let threeDSecureDriver = BTThreeDSecureDriver.init(apiClient: mockAPIClient, delegate:viewControllerPresentingDelegate )
        mockAPIClient = threeDSecureDriver.apiClient as! MockAPIClient
        
        let expectation = self.expectation(description: "verification fails with errors")
        
        threeDSecureDriver.verifyCard(withNonce: originalNonce_lookupEnrolledAuthenticationNotRequired, amount: NSDecimalNumber.one, completion: { (tokenizedCard, error) -> Void in
            XCTAssertEqual(error! as NSError, self.mockAPIClient.cannedConfigurationResponseError!)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testVerification_withCardThatDoesntRequireAuthentication_callsCompletionWithACard() {
        let responseBody = [
            "paymentMethod": [
                "consumed": false,
                "description": "ending in 02",
                "details": [
                    "cardType": "Visa",
                    "lastTwo": "02",
                ],
                "nonce": "f689056d-aee1-421e-9d10-f2c9b34d4d6f",
                "threeDSecureInfo": [
                    "enrolled": "Y",
                    "liabilityShiftPossible": true,
                    "liabilityShifted": true,
                    "status": "authenticate_successful",
                ],
                "type": "CreditCard",
            ],
            "success": true,
            "threeDSecureInfo":     [
                "liabilityShiftPossible": true,
                "liabilityShifted": true,
            ]
        ] as [String : Any]
        mockAPIClient.cannedResponseBody = BTJSON(value: responseBody)

        let threeDSecureDriver = BTThreeDSecureDriver.init(apiClient: mockAPIClient, delegate:viewControllerPresentingDelegate )
        
        let expectation = self.expectation(description: "willCallCompletion")
        
        threeDSecureDriver.verifyCard(withNonce: originalNonce_lookupEnrolledAuthenticationNotRequired, amount: NSDecimalNumber.one, completion: { (tokenizedCard, error) -> Void in
            XCTAssert(isANonce(tokenizedCard!.nonce))
            XCTAssertNil(error)
            XCTAssert(tokenizedCard!.liabilityShifted)
            XCTAssert(tokenizedCard!.liabilityShiftPossible)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testVerification_withCardThatRequiresAuthentication_requestsPresentationOfViewController() {
        let responseBody = [
            "paymentMethod": [
                "consumed": false,
                "description": "ending in 02",
                "details": [
                    "cardType": "Visa",
                    "lastTwo": "02",
                ],
                "nonce": "f689056d-aee1-421e-9d10-f2c9b34d4d6f",
                "threeDSecureInfo": [
                    "enrolled": "Y",
                    "liabilityShiftPossible": true,
                    "liabilityShifted": true,
                    "status": "authenticate_successful",
                ],
                "type": "CreditCard",
            ],
            "success": true,
            "threeDSecureInfo":     [
                "liabilityShiftPossible": true,
                "liabilityShifted": true,
            ],
            "lookup": [
                "acsUrl": "http://example.com",
                "pareq": "",
                "md": "",
                "termUrl": "http://example.com"
            ]
        ] as [String : Any]
        mockAPIClient.cannedResponseBody = BTJSON(value: responseBody)

        let threeDSecureDriver = BTThreeDSecureDriver.init(apiClient: mockAPIClient, delegate:viewControllerPresentingDelegate )
        let mockDelegate = MockViewControllerPresentationDelegate()
        threeDSecureDriver.delegate = mockDelegate

        threeDSecureDriver.verifyCard(withNonce: originalNonce_lookupEnrolledAuthenticationRequired, amount: NSDecimalNumber.one) { (tokenizedCard, error) -> Void in }

        XCTAssertNotNil(mockDelegate.lastViewController)
    }

    func testVerification_whenCardIsNotEnrolled_returnsCardWithNewNonceAndCorrectLiabilityShiftInformation() {
        let responseBody = [
            "paymentMethod": [
                "consumed": false,
                "description": "ending in 02",
                "details": [
                    "cardType": "Visa",
                    "lastTwo": "02",
                ],
                "nonce": "f689056d-aee1-421e-9d10-f2c9b34d4d6f",
                "threeDSecureInfo": [
                    "enrolled": "N",
                    "liabilityShiftPossible": false,
                    "liabilityShifted": false,
                    "status": "authenticate_successful_issuer_not_participating",
                ],
                "type": "CreditCard",
            ],
            "success": true,
            "threeDSecureInfo":     [
                "liabilityShiftPossible": false,
                "liabilityShifted": false,
            ]
        ] as [String : Any]
        mockAPIClient.cannedResponseBody = BTJSON(value: responseBody)
        let threeDSecureDriver = BTThreeDSecureDriver.init(apiClient: mockAPIClient, delegate:viewControllerPresentingDelegate)

        let expectation = self.expectation(description: "Card is tokenized")
        threeDSecureDriver.verifyCard(withNonce: originalNonce_lookupCardNotEnrolled, amount: NSDecimalNumber.one) { (tokenizedCard, error) -> Void in
            guard let tokenizedCard = tokenizedCard else {
                XCTFail()
                return
            }
            XCTAssertTrue(isANonce(tokenizedCard.nonce))
            XCTAssertNotEqual(tokenizedCard.nonce, self.originalNonce_lookupCardNotEnrolled);
            XCTAssertNil(error)
            XCTAssertFalse(tokenizedCard.liabilityShifted)
            XCTAssertFalse(tokenizedCard.liabilityShiftPossible)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testError_whenFinishIsCalledMoreThanOnce_sendsErrorAnalyticsEvent() {
        let responseBody = [
            "paymentMethod": [
                "consumed": false,
                "description": "ending in 02",
                "details": [
                    "cardType": "Visa",
                    "lastTwo": "02",
                ],
                "nonce": "f689056d-aee1-421e-9d10-f2c9b34d4d6f",
                "threeDSecureInfo": [
                    "enrolled": "N",
                    "liabilityShiftPossible": false,
                    "liabilityShifted": false,
                    "status": "authenticate_successful_issuer_not_participating",
                ],
                "type": "CreditCard",
            ],
            "success": true,
            "threeDSecureInfo":     [
                "liabilityShiftPossible": false,
                "liabilityShifted": false,
            ]
            ] as [String : Any]
        mockAPIClient.cannedResponseBody = BTJSON(value: responseBody)
        let threeDSecureDriver = BTThreeDSecureDriver.init(apiClient: mockAPIClient, delegate:viewControllerPresentingDelegate)

        let expectation = self.expectation(description: "Card is tokenized")
        threeDSecureDriver.verifyCard(withNonce: originalNonce_lookupCardNotEnrolled, amount: NSDecimalNumber.one) { (tokenizedCard, error) -> Void in
            guard let tokenizedCard = tokenizedCard else {
                XCTFail()
                return
            }
            XCTAssertTrue(isANonce(tokenizedCard.nonce))
            XCTAssertNotEqual(tokenizedCard.nonce, self.originalNonce_lookupCardNotEnrolled);
            XCTAssertNil(error)
            XCTAssertFalse(tokenizedCard.liabilityShifted)
            XCTAssertFalse(tokenizedCard.liabilityShiftPossible)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)

        let threeDSecureAuthenticationViewController = BTThreeDSecureAuthenticationViewController.init(lookupResult: BTThreeDSecureLookupResult.init())
        threeDSecureDriver.perform(#selector(threeDSecureDriver.threeDSecureViewControllerDidFinish(_:)), with: threeDSecureAuthenticationViewController)

        XCTAssertEqual(mockAPIClient.postedAnalyticsEvents.last!, "ios.threedsecure.error.finished-without-handler")
    }
}

