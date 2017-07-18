import XCTest

class BTAPIClient_SwiftTests: XCTestCase {
    
    // MARK: - Initialization
    
    func testAPIClientInitialization_withValidTokenizationKey_returnsClientWithTokenizationKey() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        XCTAssertEqual(apiClient.tokenizationKey, "development_testing_integration_merchant_id")
    }
    
    func testAPIClientInitialization_withInvalidTokenizationKey_returnsNil() {
        XCTAssertNil(BTAPIClient(authorization: "invalid"))
    }
    
    func testAPIClientInitialization_withEmptyTokenizationKey_returnsNil() {
        XCTAssertNil(BTAPIClient(authorization: ""))
    }
    
    func testAPIClientInitialization_withValidClientToken_returnsClientWithClientToken() {
        let clientToken = BTTestClientTokenFactory.token(withVersion: 2)
        let apiClient = BTAPIClient(authorization: clientToken!)
        XCTAssertEqual(apiClient?.clientToken?.originalValue, clientToken)
    }

    func testAPIClientInitialization_withVersionThreeClientToken_returnsClientWithClientToken() {
        let clientToken = BTTestClientTokenFactory.token(withVersion: 3)
        let apiClient = BTAPIClient(authorization: clientToken!)
        XCTAssertEqual(apiClient?.clientToken?.originalValue, clientToken)
    }

    func testAPIClientInitialization_withValidClientToken_performanceMeetsExpectations() {
        let clientToken = BTTestClientTokenFactory.token(withVersion: 2)
        self.measure() {
            _ = BTAPIClient(authorization: clientToken!)
        }
    }

    // MARK: - Copy

    func testCopyWithSource_whenUsingClientToken_usesSameClientToken() {
        let clientToken = BTTestClientTokenFactory.token(withVersion: 2)
        let apiClient = BTAPIClient(authorization: clientToken!)

        let copiedApiClient = apiClient?.copy(with: .unknown, integration: .unknown)

        XCTAssertEqual(copiedApiClient?.clientToken?.originalValue, clientToken)
    }

    func testCopyWithSource_whenUsingTokenizationKey_usesSameTokenizationKey() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")
        let copiedApiClient = apiClient?.copy(with: .unknown, integration: .unknown)
        XCTAssertEqual(copiedApiClient?.tokenizationKey, "development_testing_integration_merchant_id")
    }

    func testCopyWithSource_setsMetadataSourceAndIntegration() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")
        let copiedApiClient = apiClient?.copy(with: .payPalBrowser, integration: .dropIn)
        XCTAssertEqual(copiedApiClient?.metadata.source, .payPalBrowser)
        XCTAssertEqual(copiedApiClient?.metadata.integration, .dropIn)
    }

    func testCopyWithSource_copiesHTTP() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")
        let copiedApiClient = apiClient?.copy(with: .payPalBrowser, integration: .dropIn)
        XCTAssertTrue(copiedApiClient !== apiClient)
    }
    
    // MARK: - fetchOrReturnRemoteConfiguration
    
    func testFetchOrReturnRemoteConfiguration_performsGETWithCorrectPayload() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id", sendAnalyticsEvent: false)!
        let mockHTTP = BTFakeHTTP()!
        mockHTTP.stubRequest("GET", toEndpoint: "/v1/configuration", respondWith: [], statusCode: 200)
        apiClient.configurationHTTP = mockHTTP
       
        let expectation = self.expectation(description: "Callback invoked")
        apiClient.fetchOrReturnRemoteConfiguration() { _ in
            XCTAssertEqual(mockHTTP.lastRequestEndpoint, "v1/configuration")
            XCTAssertEqual(mockHTTP.lastRequestParameters?["configVersion"] as? String, "3")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    // MARK: - fetchPaymentMethods

    func testFetchPaymentMethods_performsGETWithCorrectParameter() {
        let apiClient = BTAPIClient(authorization: BTValidTestClientToken, sendAnalyticsEvent: false)!
        let mockHTTP = BTFakeHTTP()!
        mockHTTP.stubRequest("GET", toEndpoint: "/client_api/v1/payment_methods", respondWith: [], statusCode: 200)
        apiClient.http = mockHTTP
       
        var expectation = self.expectation(description: "Callback invoked")
        apiClient.fetchPaymentMethodNonces() { _ in
            XCTAssertEqual(mockHTTP.lastRequestEndpoint, "v1/payment_methods")
            XCTAssertFalse(mockHTTP.lastRequestParameters!["default_first"] as! Bool)
            XCTAssertEqual(mockHTTP.lastRequestParameters!["session_id"] as? String, apiClient.metadata.sessionId)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
       
        expectation = self.expectation(description: "Callback invoked")
        apiClient.fetchPaymentMethodNonces(true) { _ in
            XCTAssertEqual(mockHTTP.lastRequestEndpoint, "v1/payment_methods")
            XCTAssertTrue(mockHTTP.lastRequestParameters!["default_first"] as! Bool)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        expectation = self.expectation(description: "Callback invoked")
        apiClient.fetchPaymentMethodNonces(false) { _ in
            XCTAssertEqual(mockHTTP.lastRequestEndpoint, "v1/payment_methods")
            XCTAssertFalse(mockHTTP.lastRequestParameters!["default_first"] as! Bool)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchPaymentMethods_returnsPaymentMethodNonces() {
        let apiClient = BTAPIClient(authorization: BTValidTestClientToken, sendAnalyticsEvent: false)!
        let stubHTTP = BTFakeHTTP()!
        let stubbedResponse = [
            "paymentMethods": [
                [
                    "default" : true,
                    "description": "ending in 05",
                    "details": [
                        "cardType": "American Express",
                        "lastTwo": "05"
                    ],
                    "nonce": "fake-nonce",
                    "type": "CreditCard"
                ],
                [
                    "default" : false,
                    "description": "jane.doe@example.com",
                    "details": [],
                    "nonce": "fake-nonce",
                    "type": "PayPalAccount"
                ]
            ] ]
        stubHTTP.stubRequest("GET", toEndpoint: "/client_api/v1/payment_methods", respondWith: stubbedResponse, statusCode: 200)
        apiClient.http = stubHTTP
       
        let expectation = self.expectation(description: "Callback invoked")
        apiClient.fetchPaymentMethodNonces() { (paymentMethodNonces, error) in
            guard let paymentMethodNonces = paymentMethodNonces else {
                XCTFail()
                return
            }
            
            XCTAssertNil(error)
            XCTAssertEqual(paymentMethodNonces.count, 2)
            
            guard let cardNonce = paymentMethodNonces[0] as? BTCardNonce else {
                XCTFail()
                return
            }
            guard let paypalNonce = paymentMethodNonces[1] as? BTPayPalAccountNonce else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(cardNonce.nonce, "fake-nonce")
            XCTAssertEqual(cardNonce.localizedDescription, "ending in 05")
            XCTAssertEqual(cardNonce.lastTwo, "05")
            XCTAssertTrue(cardNonce.cardNetwork == BTCardNetwork.AMEX)
            XCTAssertTrue(cardNonce.isDefault)
            
            XCTAssertEqual(paypalNonce.nonce, "fake-nonce")
            XCTAssertEqual(paypalNonce.localizedDescription, "jane.doe@example.com")
            XCTAssertFalse(paypalNonce.isDefault)
            
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchPaymentMethods_withTokenizationKey_returnsError() {
        let apiClient = BTAPIClient(authorization: "development_tokenization_key", sendAnalyticsEvent: false)!

        let expectation = self.expectation(description: "Error returned")
        apiClient.fetchPaymentMethodNonces() { (paymentMethodNonces, error) -> Void in
            XCTAssertNil(paymentMethodNonces);
            guard let error = error as? NSError else {return}
            XCTAssertEqual(error._domain, BTAPIClientErrorDomain);
            XCTAssertEqual(error._code, BTAPIClientErrorType.notAuthorized.rawValue);
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    // MARK: - V3 Client Token

    func testFetchPaymentMethods_performsGETWithCorrectParameter_withVersionThreeClientToken() {
        let clientToken = BTTestClientTokenFactory.token(withVersion: 3)
        let apiClient = BTAPIClient(authorization: clientToken!, sendAnalyticsEvent: false)!
        let mockHTTP = BTFakeHTTP()!
        mockHTTP.stubRequest("GET", toEndpoint: "/client_api/v1/payment_methods", respondWith: [], statusCode: 200)
        apiClient.http = mockHTTP

        XCTAssertEqual((apiClient.clientToken!.json["version"] as! BTJSON).asIntegerOrZero(), 3)

        var expectation = self.expectation(description: "Callback invoked")
        apiClient.fetchPaymentMethodNonces() { _ in
            XCTAssertEqual(mockHTTP.lastRequestEndpoint, "v1/payment_methods")
            XCTAssertFalse(mockHTTP.lastRequestParameters!["default_first"] as! Bool)
            XCTAssertEqual(mockHTTP.lastRequestParameters!["session_id"] as? String, apiClient.metadata.sessionId)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        expectation = self.expectation(description: "Callback invoked")
        apiClient.fetchPaymentMethodNonces(true) { _ in
            XCTAssertEqual(mockHTTP.lastRequestEndpoint, "v1/payment_methods")
            XCTAssertTrue(mockHTTP.lastRequestParameters!["default_first"] as! Bool)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        expectation = self.expectation(description: "Callback invoked")
        apiClient.fetchPaymentMethodNonces(false) { _ in
            XCTAssertEqual(mockHTTP.lastRequestEndpoint, "v1/payment_methods")
            XCTAssertFalse(mockHTTP.lastRequestParameters!["default_first"] as! Bool)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    // MARK: - Analytics
    
    func testAnalyticsService_byDefault_isASingleton() {
        let firstAPIClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        let secondAPIClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        XCTAssertTrue(firstAPIClient.analyticsService === secondAPIClient.analyticsService)
    }

}
