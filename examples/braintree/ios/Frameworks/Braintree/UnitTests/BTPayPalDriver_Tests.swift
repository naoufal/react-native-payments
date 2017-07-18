import XCTest

// MARK: Authorization

class BTPayPalDriver_Authorization_Tests: XCTestCase {

    var mockAPIClient : MockAPIClient = MockAPIClient(authorization: "development_tokenization_key")!
    var observers : [NSObjectProtocol] = []
    let ValidClientToken = "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI3ODJhZmFlNDJlZTNiNTA4NWUxNmMzYjhkZTY3OGQxNTJhODFlYzk5MTBmZDNhY2YyYWU4MzA2OGI4NzE4YWZhfGNyZWF0ZWRfYXQ9MjAxNS0wOC0yMFQwMjoxMTo1Ni4yMTY1NDEwNjErMDAwMFx1MDAyNmN1c3RvbWVyX2lkPTM3OTU5QTE5LThCMjktNDVBNC1CNTA3LTRFQUNBM0VBOEM4Nlx1MDAyNm1lcmNoYW50X2lkPWRjcHNweTJicndkanIzcW5cdTAwMjZwdWJsaWNfa2V5PTl3d3J6cWszdnIzdDRuYzgiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL2RjcHNweTJicndkanIzcW4vY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjpmYWxzZSwibWVyY2hhbnRBY2NvdW50SWQiOiJzdGNoMm5mZGZ3c3p5dHc1IiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sImNvaW5iYXNlRW5hYmxlZCI6dHJ1ZSwiY29pbmJhc2UiOnsiY2xpZW50SWQiOiIxMWQyNzIyOWJhNThiNTZkN2UzYzAxYTA1MjdmNGQ1YjQ0NmQ0ZjY4NDgxN2NiNjIzZDI1NWI1NzNhZGRjNTliIiwibWVyY2hhbnRBY2NvdW50IjoiY29pbmJhc2UtZGV2ZWxvcG1lbnQtbWVyY2hhbnRAZ2V0YnJhaW50cmVlLmNvbSIsInNjb3BlcyI6ImF1dGhvcml6YXRpb25zOmJyYWludHJlZSB1c2VyIiwicmVkaXJlY3RVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbS9jb2luYmFzZS9vYXV0aC9yZWRpcmVjdC1sYW5kaW5nLmh0bWwiLCJlbnZpcm9ubWVudCI6Im1vY2sifSwibWVyY2hhbnRJZCI6ImRjcHNweTJicndkanIzcW4iLCJ2ZW5tbyI6Im9mZmxpbmUiLCJhcHBsZVBheSI6eyJzdGF0dXMiOiJtb2NrIiwiY291bnRyeUNvZGUiOiJVUyIsImN1cnJlbmN5Q29kZSI6IlVTRCIsIm1lcmNoYW50SWRlbnRpZmllciI6Im1lcmNoYW50LmNvbS5icmFpbnRyZWVwYXltZW50cy5zYW5kYm94LkJyYWludHJlZS1EZW1vIiwic3VwcG9ydGVkTmV0d29ya3MiOlsidmlzYSIsIm1hc3RlcmNhcmQiLCJhbWV4Il19fQ=="


    override func setUp() {
        super.setUp()

        mockAPIClient = MockAPIClient(authorization: "development_tokenization_key")!
        FakePayPalOneTouchCore.setCannedIsWalletAppAvailable(true)
    }

    override func tearDown() {
        for observer in observers { NotificationCenter.default.removeObserver(observer) }
        super.tearDown()
    }
    
    func testAuthorization_whenAPIClientIsNil_callsBackWithError() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.apiClient = nil
        
        let expectation = self.expectation(description: "Authorization fails with error")
        payPalDriver.authorizeAccount { (tokenizedPayPalAccount, error) -> Void in
            XCTAssertNil(tokenizedPayPalAccount)
            guard let error = error as? NSError else {return}
            XCTAssertEqual(error.domain, BTPayPalDriverErrorDomain)
            XCTAssertEqual(error.code, BTPayPalDriverErrorType.integration.rawValue)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testAuthorization_whenRemoteConfigurationFetchFails_callsBackWithConfigurationError() {
        mockAPIClient.cannedConfigurationResponseError = NSError(domain: "", code: 0, userInfo: nil)
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient

        let expectation = self.expectation(description: "Authorization fails with error")
        payPalDriver.authorizeAccount { (tokenizedPayPalAccount, error) -> Void in
            XCTAssertEqual(error! as NSError, self.mockAPIClient.cannedConfigurationResponseError!)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testAuthorization_whenPayPalConfigurationDisabled_callsBackWithError() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [ "paypalEnabled": false ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient

        let expectation = self.expectation(description: "authorization callback")
        payPalDriver.authorizeAccount { (tokenizedPayPalAccount, error) -> Void in
            guard let error = error as? NSError else {return}
            XCTAssertEqual(error.domain, BTPayPalDriverErrorDomain)
            XCTAssertEqual(error.code, BTPayPalDriverErrorType.disabled.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testAuthorization_whenReturnURLSchemeIsNil_logsCriticalMessageAndCallsBackWithError() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [ "paypalEnabled": true ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTAppSwitch.setReturnURLScheme("")
        payPalDriver.returnURLScheme = ""
        
        var criticalMessageLogged = false
        BTLogger.shared().logBlock = {
            (level: BTLogLevel, message: String?) in
            if (level == BTLogLevel.critical && message == "PayPal requires a return URL scheme to be configured via [BTAppSwitch setReturnURLScheme:]. This custom URL scheme must also be registered with your app.") {
                criticalMessageLogged = true
            }
            BTLogger.shared().logBlock = nil
            return
        }
        
        let expectation = self.expectation(description: "authorization callback")
        payPalDriver.authorizeAccount { (tokenizedPayPalAccount, error) -> Void in
            guard let error = error as? NSError else {return}
            XCTAssertEqual(error.domain, BTPayPalDriverErrorDomain)
            XCTAssertEqual(error.code, BTPayPalDriverErrorType.integrationReturnURLScheme.rawValue)
            expectation.fulfill()
        }
        
        XCTAssertTrue(criticalMessageLogged)
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testAuthorization_whenRemoteConfigurationIsAvailable_performsPayPalRequestAppSwitch() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"

        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        // Depending on whether it's iOS 9 or not, we use different stub delegates to wait for the app switch to occur
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        let stubAppSwitchDelegate = MockAppSwitchDelegate()
        if #available(iOS 9.0, *) {
            stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
            payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        } else {
            stubAppSwitchDelegate.willPerformAppSwitchExpectation =  expectation(description: "Delegate received willPerformAppSwitch")
            stubAppSwitchDelegate.didPerformAppSwitchExpectation = expectation(description: "Delegate received didPerformAppSwitch")
            payPalDriver.appSwitchDelegate = stubAppSwitchDelegate
        }

        payPalDriver.authorizeAccount { _ -> Void in }

        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(mockRequestFactory.authorizationRequest.appSwitchPerformed)
    }
    
    func testAuthorization_whenBillingAgreementsEnabledInConfiguration_performsBillingAgreements() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline",
                "billingAgreementsEnabled": true,
                "currencyIsoCode": "GBP",
            ] ])

        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.authorizeAccount { _ -> Void in
        }
        
        XCTAssertEqual("v1/paypal_hermes/setup_billing_agreement", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        // We want to make sure that currency is not used for Billing Agreements
        XCTAssertTrue(lastPostParameters["currency_iso_code"] == nil)
        // We want to make sure that intent is not used for Billing Agreements
        XCTAssertTrue(lastPostParameters["intent"] == nil)
        XCTAssertEqual(lastPostParameters["return_url"] as? String, "scheme://return")
        XCTAssertEqual(lastPostParameters["cancel_url"] as? String, "scheme://cancel")
    }

    func testAuthorizationRequest_byDefault_containsEmailAndFuturePaymentsScopes() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        // Depending on whether it's iOS 9 or not, we use different stub delegates to wait for the app switch to occur
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        let stubAppSwitchDelegate = MockAppSwitchDelegate()
        if #available(iOS 9.0, *) {
            stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
            payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        } else {
            stubAppSwitchDelegate.willPerformAppSwitchExpectation =  expectation(description: "Delegate received willPerformAppSwitch")
            stubAppSwitchDelegate.didPerformAppSwitchExpectation = expectation(description: "Delegate received didPerformAppSwitch")
            payPalDriver.appSwitchDelegate = stubAppSwitchDelegate
        }

        payPalDriver.authorizeAccount { _ -> Void in }

        waitForExpectations(timeout: 5, handler: nil)
        for expectedScope in ["email", "https://uri.paypal.com/services/payments/futurepayments"] {
            XCTAssertTrue(mockRequestFactory.lastScopeValues!.contains(expectedScope as NSObject))
        }
    }

    func testAuthorizationRequest_whenAdditionalScopesAreSpecified_includesThoseAdditionalScopes() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        // Depending on whether it's iOS 9 or not, we use different stub delegates to wait for the app switch to occur
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        let stubAppSwitchDelegate = MockAppSwitchDelegate()
        if #available(iOS 9.0, *) {
            stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
            payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        } else {
            stubAppSwitchDelegate.willPerformAppSwitchExpectation =  expectation(description: "Delegate received willPerformAppSwitch")
            stubAppSwitchDelegate.didPerformAppSwitchExpectation = expectation(description: "Delegate received didPerformAppSwitch")
            payPalDriver.appSwitchDelegate = stubAppSwitchDelegate
        }

        payPalDriver.authorizeAccount(withAdditionalScopes: Set(["foo", "bar"])) { _ -> Void in }

        waitForExpectations(timeout: 5, handler: nil)
        for expectedScope in ["email", "https://uri.paypal.com/services/payments/futurepayments", "foo", "bar"] {
            XCTAssertTrue(mockRequestFactory.lastScopeValues!.contains(expectedScope as NSObject))
        }
    }
    
    func testAuthorizationRequest_whenUsingTokenizationKey_includesTokenizationKeyInAdditionalPayloadAttributes() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        let mockRequest = mockRequestFactory.authorizationRequest
        // Depending on whether it's iOS 9 or not, we use different stub delegates to wait for the app switch to occur
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        let stubAppSwitchDelegate = MockAppSwitchDelegate()
        if #available(iOS 9.0, *) {
            stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
            payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        } else {
            stubAppSwitchDelegate.willPerformAppSwitchExpectation =  expectation(description: "Delegate received willPerformAppSwitch")
            stubAppSwitchDelegate.didPerformAppSwitchExpectation = expectation(description: "Delegate received didPerformAppSwitch")
            payPalDriver.appSwitchDelegate = stubAppSwitchDelegate
        }
        
        payPalDriver.authorizeAccount { _ -> Void in }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(mockRequest.additionalPayloadAttributes["client_key"] as? String, "development_tokenization_key")
    }
    
    func testAuthorizationRequest_whenUsingClientToken_includesClientTokenInAdditionalPayloadAttributes() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        mockAPIClient.tokenizationKey = nil
        mockAPIClient.clientToken = try! BTClientToken(clientToken: ValidClientToken)
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        let mockRequest = mockRequestFactory.authorizationRequest
        // Depending on whether it's iOS 9 or not, we use different stub delegates to wait for the app switch to occur
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        let stubAppSwitchDelegate = MockAppSwitchDelegate()
        if #available(iOS 9.0, *) {
            stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
            payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        } else {
            stubAppSwitchDelegate.willPerformAppSwitchExpectation =  expectation(description: "Delegate received willPerformAppSwitch")
            stubAppSwitchDelegate.didPerformAppSwitchExpectation = expectation(description: "Delegate received didPerformAppSwitch")
            payPalDriver.appSwitchDelegate = stubAppSwitchDelegate
        }
        
        payPalDriver.authorizeAccount { _ -> Void in }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(mockRequest.additionalPayloadAttributes["client_token"] as? String, ValidClientToken)
    }


    func testAuthorization_whenAppSwitchCancels_callsBackWithNoResultOrError() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = PPOTResultType.cancel

        let expectation = self.expectation(description: "App switch return block invoked")
        payPalDriver.setAuthorizationAppSwitchReturn { (tokenizedAccount, error) -> Void in
            XCTAssertNil(tokenizedAccount)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testAuthorization_whenAppSwitchSucceeds_tokenizesPayPalAccount() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.clientMetadataId = "a-correlation-id"
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = PPOTResultType.success
        payPalDriver.payPalRequest = BTPayPalRequest();
        mockAPIClient.cannedResponseBody = BTJSON(value: ["paypalAccounts": [
            ["nonce": "fake-nonce"]
            ] ] )
        
        payPalDriver.setAuthorizationAppSwitchReturn { _ -> Void in }
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        
        XCTAssertEqual(mockAPIClient.lastPOSTPath, "/v1/payment_methods/paypal_accounts")
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail("Expected POST to contain parameters")
            return
        }
        
        let paypalAccount = lastPostParameters["paypal_account"] as! NSDictionary
        XCTAssertEqual(paypalAccount["correlation_id"] as? String, "a-correlation-id")
        XCTAssertTrue(paypalAccount["intent"] == nil)
        XCTAssertEqual(paypalAccount, FakePayPalOneTouchCoreResult().response as AnyObject as! NSDictionary)
    }

    func testAuthorization_whenAppSwitchingToApp_makesAppSwitchDelegateCallbacks() {
        if #available(iOS 9.0, *) {
            return
        }
        
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.returnURLScheme = "foo://"
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        let delegate = MockAppSwitchDelegate(willPerform: expectation(description: "willPerformAppSwitch called"), didPerform: expectation(description: "didPerformAppSwitch called"))
        delegate.willProcessAppSwitchExpectation = expectation(description: "willProcessPaymentInfo called")
        payPalDriver.appSwitchDelegate = delegate
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = PPOTResultType.success
        
        payPalDriver.authorizeAccount { _ -> Void in }
        payPalDriver.setAuthorizationAppSwitchReturn { _ -> Void in }
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testAuthorization_whenAppSwitchingToApp_postsNotifications() {
        if #available(iOS 9.0, *) {
            return
        }
        
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.returnURLScheme = "foo://"
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        let delegate = MockAppSwitchDelegate()
        delegate.willPerformAppSwitchExpectation = expectation(description: "willPerformAppSwitch called")
        payPalDriver.appSwitchDelegate = delegate
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = PPOTResultType.success

        let willAppSwitchNotificationExpectation = expectation(description: "willAppSwitch notification received")
        observers.append(NotificationCenter.default.addObserver(forName: NSNotification.Name.BTAppSwitchWillSwitch, object: nil, queue: nil) { (notification) -> Void in
            willAppSwitchNotificationExpectation.fulfill()
        })

        let didAppSwitchNotificationExpectation = expectation(description: "didAppSwitch notification received")
        observers.append(NotificationCenter.default.addObserver(forName: NSNotification.Name.BTAppSwitchDidSwitch, object: nil, queue: nil) { (notification) -> Void in
            didAppSwitchNotificationExpectation.fulfill()
        })

        payPalDriver.authorizeAccount { _ -> Void in }

        let willProcessNotificationExpectation = expectation(description: "willProcess notification received")
        observers.append(NotificationCenter.default.addObserver(forName: NSNotification.Name.BTAppSwitchWillProcessPaymentInfo, object: nil, queue: nil) { (notification) -> Void in
            willProcessNotificationExpectation.fulfill()
        })

        payPalDriver.setAuthorizationAppSwitchReturn { _ -> Void in }
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)

        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testAuthorization_whenSwitchingToSFSafariViewController_makesViewControllerPresentingDelegateCallbacks() {
        guard #available(iOS 9.0, *) else {
            return
        }

        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = PPOTResultType.success
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.returnURLScheme = "foo://"
        payPalDriver.requestFactory = FakePayPalRequestFactory()
        let mockViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        mockViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
        payPalDriver.viewControllerPresentingDelegate = mockViewControllerPresentingDelegate
        
        payPalDriver.authorizeAccount { _ -> Void in }
        waitForExpectations(timeout: 2, handler: nil)
        
        // Test dismissal of view controller
        XCTAssertTrue(mockViewControllerPresentingDelegate.lastViewController is SFSafariViewController)
        
        let safariViewController = mockViewControllerPresentingDelegate.lastViewController
        mockViewControllerPresentingDelegate.lastViewController = nil
        mockViewControllerPresentingDelegate.lastPaymentDriver = nil
        mockViewControllerPresentingDelegate.requestsDismissalOfViewControllerExpectation = expectation(description: "Delegate received requestsDismissalOfViewController")
        
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertEqual(mockViewControllerPresentingDelegate.lastViewController, safariViewController)
        XCTAssertEqual(mockViewControllerPresentingDelegate.lastPaymentDriver as? BTPayPalDriver, payPalDriver)
    }

    func testAuthorization_whenSwitchingToSFSafariViewController_doesNotMakeAppSwitchDelegateCallbacks() {
        guard #available(iOS 9.0, *) else {
            return
        }

        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = PPOTResultType.success
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.returnURLScheme = "foo://"
        payPalDriver.requestFactory = FakePayPalRequestFactory()
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
        payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        let mockAppSwitchDelegate = MockAppSwitchDelegate()
        payPalDriver.appSwitchDelegate = mockAppSwitchDelegate
        
        payPalDriver.authorizeAccount { _ -> Void in }
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertFalse(mockAppSwitchDelegate.willPerformAppSwitchCalled)
        XCTAssertFalse(mockAppSwitchDelegate.didPerformAppSwitchCalled)
        
        stubViewControllerPresentingDelegate.requestsDismissalOfViewControllerExpectation = expectation(description: "Delegate received requestsDismissalOfViewController")
        
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertFalse(mockAppSwitchDelegate.willProcessAppSwitchCalled)
    }

    func testAuthorization_whenSwitchingToSFSafariViewControllerAndURLIsNotHTTP_callsBackWithError() {
        guard #available(iOS 9.0, *) else {
            return
        }

        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = PPOTResultType.success
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.returnURLScheme = "foo://"
        let stubPayPalRequestFactory = FakePayPalRequestFactory()
        stubPayPalRequestFactory.authorizationRequest.cannedURL = URL(string: "garbage://garbage")
        payPalDriver.requestFactory = stubPayPalRequestFactory
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        let mockAppSwitchDelegate = MockAppSwitchDelegate()
        payPalDriver.appSwitchDelegate = mockAppSwitchDelegate

        let expectation = self.expectation(description: "Callback invoked")
        payPalDriver.authorizeAccount { (tokenizedPayPalAccount, error) -> Void in
            guard let error = error as? NSError else {return}
            XCTAssertEqual(error.domain, BTPayPalDriverErrorDomain)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testAuthorization_whenAppSwitchResultIsError_returnsUnderlyingError() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = PPOTResultType.error
        let fakeError = NSError(domain: "FakeError", code: 1, userInfo: nil)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedError = fakeError

        let expectation = self.expectation(description: "App switch completion callback")
        payPalDriver.setAuthorizationAppSwitchReturn { (tokenizedAccount, error) -> Void in
            guard let error = error else {
                XCTFail()
                return
            }
            XCTAssertEqual(error as NSError, fakeError)
            expectation.fulfill()
        }

        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testTokenizedPayPalAccount_containsPayerInfo() {
        let authResponse = [
            "paypalAccounts": [
                [
                    "nonce": "a-nonce",
                    "description": "A description",
                    "details": [
                        "email": "hello@world.com",
                        "payerInfo": [
                            "accountAddress": [
                                "recipientName": "Foo Bar",
                                "street1": "1 Foo Ct",
                                "street2": "Apt Bar",
                                "city": "Fubar",
                                "state": "FU",
                                "postalCode": "42",
                                "country": "USA"
                            ]
                        ]
                    ]
                ] ] ]
        assertSuccessfulAuthorizationResponse(authResponse as [String : AnyObject],
            assertionBlock: { (tokenizedPayPalAccount, error) -> Void in
                XCTAssertEqual(tokenizedPayPalAccount!.nonce, "a-nonce")
                XCTAssertEqual(tokenizedPayPalAccount!.localizedDescription, "A description")
                XCTAssertEqual(tokenizedPayPalAccount!.email, "hello@world.com")
                let shippingAddress = tokenizedPayPalAccount!.shippingAddress!
                XCTAssertEqual(shippingAddress.recipientName, "Foo Bar")
                XCTAssertEqual(shippingAddress.streetAddress, "1 Foo Ct")
                XCTAssertEqual(shippingAddress.extendedAddress, "Apt Bar")
                XCTAssertEqual(shippingAddress.locality, "Fubar")
                XCTAssertEqual(shippingAddress.region, "FU")
                XCTAssertEqual(shippingAddress.postalCode, "42")
                XCTAssertEqual(shippingAddress.countryCodeAlpha2, "USA")
        })
    }

    func testTokenizedPayPalAccount_whenEmailAddressIsNestedInsidePayerInfoJSON_usesNestedEmailAddress() {
        let authResponse = [
            "paypalAccounts": [
                [
                    "nonce": "fake-nonce",
                    "details": [
                        "email": "not-hello@world.com",
                        "payerInfo": [
                            "email": "hello@world.com",
                        ]
                    ],
                    ]
            ] ]
        assertSuccessfulAuthorizationResponse(authResponse as [String : AnyObject],
            assertionBlock: { (tokenizedPayPalAccount, error) -> Void in
                XCTAssertEqual(tokenizedPayPalAccount!.email, "hello@world.com")
        })
    }

    func testTokenizedPayPalAccount_whenDescriptionJSONIsPayPal_usesEmailAsLocalizedDescription() {
        let authResponse = [
            "paypalAccounts": [
                [
                    "nonce": "fake-nonce",
                    "description": "PayPal",
                    "details": [
                        "email": "hello@world.com",
                    ],
                    ]
            ] ]
        assertSuccessfulAuthorizationResponse(authResponse as [String : AnyObject],
            assertionBlock: { (tokenizedPayPalAccount, error) -> Void in
                XCTAssertEqual(tokenizedPayPalAccount!.localizedDescription, "hello@world.com")
        })
    }
    
    // MARK: _meta parameter
    
    func testMetaParameter_whenAuthorizationAppSwitchIsSuccessful_isPOSTedToServer() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        let stubPayPalClass = FakePayPalOneTouchCore.self
        stubPayPalClass.cannedResult()?.cannedType = .success
        stubPayPalClass.setCannedIsWalletAppAvailable(true)
        BTPayPalDriver.setPayPalClass(stubPayPalClass)
        payPalDriver.setAuthorizationAppSwitchReturn { _ -> Void in }
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        
        XCTAssertEqual(mockAPIClient.lastPOSTPath, "/v1/payment_methods/paypal_accounts")
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        let metaParameters = lastPostParameters["_meta"] as! NSDictionary
        XCTAssertEqual(metaParameters["source"] as? String, "paypal-app")
        XCTAssertEqual(metaParameters["integration"] as? String, "custom")
        XCTAssertEqual(metaParameters["sessionId"] as? String, mockAPIClient.metadata.sessionId)
    }
    
    func testMetaParameter_whenAuthorizationBrowserSwitchIsSuccessful_isPOSTedToServer() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        let stubPayPalClass = FakePayPalOneTouchCore.self
        stubPayPalClass.cannedResult()?.cannedType = .success
        stubPayPalClass.setCannedIsWalletAppAvailable(false)
        BTPayPalDriver.setPayPalClass(stubPayPalClass)
        payPalDriver.setAuthorizationAppSwitchReturn { _ -> Void in }
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        
        XCTAssertEqual(mockAPIClient.lastPOSTPath, "/v1/payment_methods/paypal_accounts")
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        let metaParameters = lastPostParameters["_meta"] as! NSDictionary
        XCTAssertEqual(metaParameters["source"] as? String, "paypal-browser")
        XCTAssertEqual(metaParameters["integration"] as? String, "custom")
        XCTAssertEqual(metaParameters["sessionId"] as? String, mockAPIClient.metadata.sessionId)
    }

    // MARK: Helpers

    func assertSuccessfulAuthorizationResponse(_ response: [String:AnyObject], assertionBlock: @escaping (BTPayPalAccountNonce?, NSError?) -> Void) {
        mockAPIClient.cannedResponseBody = BTJSON(value: response)
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .success

        payPalDriver.setAuthorizationAppSwitchReturn { (tokenizedPayPalAccount, error) -> Void in
            assertionBlock(tokenizedPayPalAccount, error as NSError?)
        }
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)

        XCTAssertEqual(mockAPIClient.lastPOSTPath, "/v1/payment_methods/paypal_accounts")
    }
}

// MARK: - Checkout

class BTPayPalDriver_Checkout_Tests: XCTestCase {

    var mockAPIClient : MockAPIClient = MockAPIClient(authorization: "development_tokenization_key")!

    override func setUp() {
        super.setUp()

        mockAPIClient = MockAPIClient(authorization: "development_tokenization_key")!
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        mockAPIClient.cannedResponseBody = BTJSON(value: [
            "paymentResource": [
                "redirectUrl": "fakeURL://"
            ] ])

    }
    
    func testCheckout_whenAPIClientIsNil_callsBackWithError() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.apiClient = nil
        
        let request = BTPayPalRequest(amount: "1")
        let expectation = self.expectation(description: "Checkout fails with error")

        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) -> Void in
            XCTAssertNil(tokenizedPayPalAccount)
            guard let error = error as? NSError else {return}
            XCTAssertEqual(error.domain, BTPayPalDriverErrorDomain)
            XCTAssertEqual(error.code, BTPayPalDriverErrorType.integration.rawValue)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testCheckout_whenRemoteConfigurationFetchFails_callsBackWithConfigurationError() {
        mockAPIClient.cannedConfigurationResponseBody = nil
        mockAPIClient.cannedConfigurationResponseError = NSError(domain: "", code: 0, userInfo: nil)
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        let request = BTPayPalRequest(amount: "1")
        let expectation = self.expectation(description: "Checkout fails with error")
        payPalDriver.requestOneTimePayment(request) { (_, error) -> Void in
            XCTAssertEqual(error! as NSError, self.mockAPIClient.cannedConfigurationResponseError!)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 2, handler: nil)
    }

    func testCheckout_whenRemoteConfigurationFetchSucceeds_postsPaymentResource() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertEqual(lastPostParameters["amount"] as? String, "1")
        XCTAssertEqual(lastPostParameters["currency_iso_code"] as? String, "GBP")
        XCTAssertEqual(lastPostParameters["return_url"] as? String, "scheme://return")
        XCTAssertEqual(lastPostParameters["cancel_url"] as? String, "scheme://cancel")
    }
    
    func testCheckout_byDefault_postsPaymentResourceWithNoShipping() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        // no_shipping = true should be the default.
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        payPalDriver.requestOneTimePayment(request) { _ -> Void in }
        
        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        guard let experienceProfile = lastPostParameters["experience_profile"] as? Dictionary<String, AnyObject> else {
            XCTFail()
            return
        }
        XCTAssertEqual(experienceProfile["no_shipping"] as? Bool, true)
    }
    
    func testCheckout_whenShippingAddressIsRequired_postsPaymentResourceWithNoShippingAsFalse() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        request.isShippingAddressRequired = true
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        payPalDriver.requestOneTimePayment(request) { _ -> Void in }
        
        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        guard let experienceProfile = lastPostParameters["experience_profile"] as? Dictionary<String, AnyObject> else {
            XCTFail()
            return
        }
        XCTAssertEqual(experienceProfile["no_shipping"] as? Bool, false)
    }

    func testCheckout_whenIntentIsNotSpecified_postsPaymentResourceWithAuthorizeIntent() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        request.isShippingAddressRequired = true
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertEqual(lastPostParameters["intent"] as? String, "authorize")
        XCTAssertEqual(request.intent, BTPayPalRequestIntent.authorize)
    }

    func testCheckout_whenIntentIsSetToAuthorize_postsPaymentResourceWithIntent() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        request.intent = .authorize;
        request.isShippingAddressRequired = true
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertEqual(lastPostParameters["intent"] as? String, "authorize")
    }

    func testCheckout_whenIntentIsSetToSale_postsPaymentResourceWithIntent() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        request.intent = .sale;
        request.isShippingAddressRequired = true
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }
        
        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertEqual(lastPostParameters["intent"] as? String, "sale")
    }

    func testCheckout_whenIntentIsSetToOrder_postsPaymentResourceWithIntent() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        request.intent = .order;
        request.isShippingAddressRequired = true
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertEqual(lastPostParameters["intent"] as? String, "order")
    }

    func testCheckout_whenLandingPageTypeIsNotSpecified_doesNotPostPaymentResourceWithLandingPageType() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        XCTAssertEqual(BTPayPalRequestLandingPageType.default, request.landingPageType)
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }

        guard let experienceProfile = lastPostParameters["experience_profile"] as? Dictionary<String, AnyObject> else {
            XCTFail()
            return
        }
        XCTAssertNil(experienceProfile["landing_page_type"])
    }

    func testCheckout_whenLandingPageTypeIsBilling_postsPaymentResourceWithBillingLandingPageType() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        request.landingPageType = .billing
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }

        guard let experienceProfile = lastPostParameters["experience_profile"] as? Dictionary<String, AnyObject> else {
            XCTFail()
            return
        }
        XCTAssertEqual(experienceProfile["landing_page_type"] as? String, "billing")
    }

    func testCheckout_whenLandingPageTypeIsLogin_postsPaymentResourceWithLoginLandingPageType() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        request.landingPageType = .login
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }

        guard let experienceProfile = lastPostParameters["experience_profile"] as? Dictionary<String, AnyObject> else {
            XCTFail()
            return
        }
        XCTAssertEqual(experienceProfile["landing_page_type"] as? String, "login")
    }

    func testCheckout_whenUserActionIsNotSet_approvalUrlIsNotModified() {
        mockAPIClient.cannedResponseBody = BTJSON(value: [
            "paymentResource": [
                "redirectUrl": "https://www.paypal.com/checkout/?EC-Token=EC-Random-Value"
            ] ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        guard let lastApprovalURL = mockRequestFactory.lastApprovalURL,
            let approvalURLComponents = URLComponents(url: lastApprovalURL, resolvingAgainstBaseURL: false) else {
                XCTFail("Did not find the last approval URL")
                return
        }
        XCTAssertEqual(approvalURLComponents.queryItems?.filter({ $0.name == "EC-Token" && $0.value == "EC-Random-Value" }).count, 1,
                       "Did not find existing query parameter")
        XCTAssertEqual(approvalURLComponents.queryItems?.filter({ $0.name == "useraction" }).count, 0,
                       "Found useraction query item when not expected")
    }

    func testCheckout_whenUserActionIsSetToDefault_approvalUrlIsNotModified() {
        mockAPIClient.cannedResponseBody = BTJSON(value: [
            "paymentResource": [
                "redirectUrl": "https://www.paypal.com/checkout/?EC-Token=EC-Random-Value"
            ] ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.userAction = BTPayPalRequestUserAction.default
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        guard let lastApprovalURL = mockRequestFactory.lastApprovalURL,
            let approvalURLComponents = URLComponents(url: lastApprovalURL, resolvingAgainstBaseURL: false) else {
                XCTFail("Did not find the last approval URL")
                return
        }
        XCTAssertEqual(approvalURLComponents.queryItems?.filter({ $0.name == "EC-Token" && $0.value == "EC-Random-Value" }).count, 1,
                       "Did not find existing query parameter")
        XCTAssertEqual(approvalURLComponents.queryItems?.filter({ $0.name == "useraction" }).count, 0,
                       "Found useraction query item when not expected")
    }

    func testCheckout_whenUserActionIsSetToCommit_approvalUrlIsModified() {
        mockAPIClient.cannedResponseBody = BTJSON(value: [
            "paymentResource": [
                "redirectUrl": "https://www.paypal.com/checkout/?EC-Token=EC-Random-Value"
        ] ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.userAction = BTPayPalRequestUserAction.commit
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        guard let lastApprovalURL = mockRequestFactory.lastApprovalURL,
            let approvalURLComponents = URLComponents(url: lastApprovalURL, resolvingAgainstBaseURL: false) else {
            XCTFail("Did not find the last approval URL")
            return
        }

        XCTAssertEqual(approvalURLComponents.queryItems?.filter({ $0.name == "EC-Token" && $0.value == "EC-Random-Value" }).count, 1,
                       "Did not find existing query parameter")
        XCTAssertEqual(approvalURLComponents.queryItems?.filter({ $0.name == "useraction" && $0.value == "commit" }).count, 1,
                       "Did not find useraction query item")
    }

    func testCheckout_whenDisplayNameIsNotSet_doesNotPostPaymentResourceWithBrandName() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        XCTAssertNil(request.displayName)

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }

        guard let experienceProfile = lastPostParameters["experience_profile"] as? Dictionary<String, AnyObject> else {
            XCTFail()
            return
        }
        XCTAssertFalse(experienceProfile.keys.contains("brand_name"))
    }

    func testCheckout_whenDisplayNameIsSet_postsPaymentResourceWithDisplayName() {
        let merchantName = "My Random Merchant Name"

        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        request.displayName = merchantName
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }

        guard let experienceProfile = lastPostParameters["experience_profile"] as? Dictionary<String, AnyObject> else {
            XCTFail()
            return
        }
        XCTAssertEqual(experienceProfile["brand_name"] as? String, merchantName)
    }

    func testCheckout_whenDisplayNameIsSetInConfiguration_postsPaymentResourceWithConfigurationBrandName() {
        let merchantName = "My Random Merchant Name"

        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient

        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "displayName": merchantName
            ]
        ])
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        request.displayName = merchantName
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }

        guard let experienceProfile = lastPostParameters["experience_profile"] as? Dictionary<String, AnyObject> else {
            XCTFail()
            return
        }
        XCTAssertEqual(experienceProfile["brand_name"] as? String, merchantName)
    }

    func testCheckout_whenRemoteConfigurationFetchSucceeds_postsPaymentResourceWithShippingAddress() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        let address : BTPostalAddress = BTPostalAddress()
        address.streetAddress = "1234 Fake St."
        address.extendedAddress = "Apt. 0"
        address.region = "CA"
        address.locality = "Oakland"
        address.countryCodeAlpha2 = "US"
        address.postalCode = "12345"
        request.shippingAddressOverride = address
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        payPalDriver.requestOneTimePayment(request) { _ -> Void in }
        
        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        guard let experienceProfile = lastPostParameters["experience_profile"] as? Dictionary<String, AnyObject> else {
            XCTFail()
            return
        }
        XCTAssertEqual(lastPostParameters["offer_paypal_credit"] as? Bool, false)
        XCTAssertEqual(experienceProfile["address_override"] as? Bool, true)
        XCTAssertEqual(lastPostParameters["line1"] as? String, "1234 Fake St.")
        XCTAssertEqual(lastPostParameters["line2"] as? String, "Apt. 0")
        XCTAssertEqual(lastPostParameters["city"] as? String, "Oakland")
        XCTAssertEqual(lastPostParameters["state"] as? String, "CA")
        XCTAssertEqual(lastPostParameters["postal_code"] as? String, "12345")
        XCTAssertEqual(lastPostParameters["country_code"] as? String, "US")
    }

    func testCheckout_whenPayPalCreditOffered_performsSwitchCorrectly() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest(amount: "1")
        request.currencyCode = "GBP"
        request.offerCredit = true
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        // Depending on whether it's iOS 9 or not, we use different stub delegates to wait for the app switch to occur
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        let stubAppSwitchDelegate = MockAppSwitchDelegate()
        if #available(iOS 9.0, *) {
            stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
            payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        } else {
            stubAppSwitchDelegate.willPerformAppSwitchExpectation =  expectation(description: "Delegate received willPerformAppSwitch")
            stubAppSwitchDelegate.didPerformAppSwitchExpectation = expectation(description: "Delegate received didPerformAppSwitch")
            payPalDriver.appSwitchDelegate = stubAppSwitchDelegate
        }

        payPalDriver.requestOneTimePayment(request) { _ in }

        self.waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(mockRequestFactory.checkoutRequest.appSwitchPerformed)

        // Ensure the payment resource had the correct parameters
        XCTAssertEqual("v1/paypal_hermes/create_payment_resource", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertEqual(lastPostParameters["offer_paypal_credit"] as? Bool, true)

        // Make sure analytics event was sent when switch occurred
        let postedAnalyticsEvents = mockAPIClient.postedAnalyticsEvents

        if #available(iOS 9.0, *) {
            XCTAssertTrue(postedAnalyticsEvents.contains("ios.paypal-single-payment.webswitch.credit.offered.started"))
        } else {
            XCTAssertTrue(postedAnalyticsEvents.contains("ios.paypal-single-payment.appswitch.credit.offered.started"))
        }
    }

    func testCheckout_whenPayPalPaymentCreationSuccessful_performsAppSwitch() {
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        // Depending on whether it's iOS 9 or not, we use different stub delegates to wait for the app switch to occur
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        let stubAppSwitchDelegate = MockAppSwitchDelegate()
        if #available(iOS 9.0, *) {
            stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
            payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        } else {
            stubAppSwitchDelegate.willPerformAppSwitchExpectation =  expectation(description: "Delegate received willPerformAppSwitch")
            stubAppSwitchDelegate.didPerformAppSwitchExpectation = expectation(description: "Delegate received didPerformAppSwitch")
            payPalDriver.appSwitchDelegate = stubAppSwitchDelegate
        }

        let request = BTPayPalRequest(amount: "1")
        payPalDriver.requestOneTimePayment(request) { _ -> Void in }

        self.waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(mockRequestFactory.checkoutRequest.appSwitchPerformed)
        XCTAssertEqual(payPalDriver.clientMetadataId, "fake-canned-metadata-id")
    }

    func testCheckout_whenPaymentResourceCreationFails_callsBackWithError() {
        mockAPIClient.cannedResponseError = NSError(domain: "", code: 0, userInfo: nil)

        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let dummyRequest = BTPayPalRequest(amount: "1")
        let expectation = self.expectation(description: "Checkout fails with error")
        payPalDriver.requestOneTimePayment(dummyRequest) { (_, error) -> Void in
            XCTAssertEqual(error! as NSError, self.mockAPIClient.cannedResponseError!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
    }

    func testCheckout_whenAppSwitchCancels_callsBackWithNoResultOrError() {
        let payPalDriver = BTPayPalDriver(apiClient:mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let returnURL = URL(string: "bar://hello/world")!

        let continuationExpectation = self.expectation(description: "Continuation called")

        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .cancel
        payPalDriver.setOneTimePaymentAppSwitchReturn ({ (tokenizedCheckout, error) -> Void in
            XCTAssertNil(tokenizedCheckout)
            XCTAssertNil(error)
            continuationExpectation.fulfill()
        })

        BTPayPalDriver.handleAppSwitchReturn(returnURL)

        self.waitForExpectations(timeout: 2, handler: nil)
    }

    func testCheckout_whenAppSwitchErrors_callsBackWithError() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let returnURL = URL(string: "bar://hello/world")!

        let continuationExpectation = self.expectation(description: "Continuation called")

        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .error
        BTPayPalDriver.payPalClass().cannedResult()?.cannedError = NSError(domain: "", code: 0, userInfo: nil)

        payPalDriver.setOneTimePaymentAppSwitchReturn ({ (tokenizedCheckout, error) -> Void in
            XCTAssertNil(tokenizedCheckout)
            XCTAssertEqual(error! as NSError, BTPayPalDriver.payPalClass().cannedResult()?.error! as! NSError)
            continuationExpectation.fulfill()
            })

        BTPayPalDriver.handleAppSwitchReturn(returnURL)

        self.waitForExpectations(timeout: 2, handler: nil)
    }

    func testCheckout_whenAppSwitchSucceeds_tokenizesPayPalCheckout() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .success
        
        payPalDriver.setOneTimePaymentAppSwitchReturn ({ _ -> Void in })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        
        XCTAssertEqual(mockAPIClient.lastPOSTPath, "/v1/payment_methods/paypal_accounts")
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        let paypalAccount = lastPostParameters["paypal_account"] as! NSDictionary
        let options = paypalAccount["options"] as! NSDictionary
        let validate = (options["validate"] as! NSNumber).boolValue
        XCTAssertFalse(validate)
    }
    
    func testCheckout_whenAppSwitchSucceeds_intentShouldExistAsPayPalAccountParameter() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .success
        payPalDriver.payPalRequest = BTPayPalRequest(amount: "1.34")
        payPalDriver.payPalRequest.intent = .sale
        
        payPalDriver.setOneTimePaymentAppSwitchReturn ({ _ -> Void in })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        
        XCTAssertEqual(mockAPIClient.lastPOSTPath, "/v1/payment_methods/paypal_accounts")
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        let paypalAccount = lastPostParameters["paypal_account"] as! NSDictionary
        XCTAssertEqual(paypalAccount["intent"] as? String, "sale")
        let options = paypalAccount["options"] as! NSDictionary
        let validate = (options["validate"] as! NSNumber).boolValue
        XCTAssertFalse(validate)
    }

    func testCheckout_whenCreditFinancingNotReturned_shouldNotSendCreditAcceptedAnalyticsEvent() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        mockAPIClient.cannedResponseBody = BTJSON(value: [ "paypalAccounts":
            [
                [
                    "description": "jane.doe@example.com",
                    "details": [
                        "email": "jane.doe@example.com",
                    ],
                    "nonce": "a-nonce",
                    "type": "PayPalAccount",
                    ]
                ]
        ])
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .success
        payPalDriver.payPalRequest = BTPayPalRequest(amount: "1.34")

        payPalDriver.setOneTimePaymentAppSwitchReturn ({ _ -> Void in })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)

        XCTAssertFalse(mockAPIClient.postedAnalyticsEvents.contains("ios.paypal-single-payment.credit.accepted"))
    }

    func testCheckout_whenCreditFinancingReturned_shouldSendCreditAcceptedAnalyticsEvent() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        mockAPIClient.cannedResponseBody = BTJSON(value: [ "paypalAccounts":
            [
                [
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
                    "nonce": "a-nonce",
                    "type": "PayPalAccount",
                ]
            ]
        ])
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .success
        payPalDriver.payPalRequest = BTPayPalRequest(amount: "1.34")

        payPalDriver.setOneTimePaymentAppSwitchReturn ({ _ -> Void in })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)

        XCTAssertTrue(mockAPIClient.postedAnalyticsEvents.contains("ios.paypal-single-payment.credit.accepted"))
    }

    func testCheckout_whenAppSwitchSucceeds_makesDelegateCallback() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        let delegate = MockAppSwitchDelegate()
        delegate.willProcessAppSwitchExpectation = expectation(description: "willProcessPaymentInfo called")
        payPalDriver.appSwitchDelegate = delegate
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .success

        payPalDriver.setOneTimePaymentAppSwitchReturn ({ _ -> Void in })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testCheckout_whenAppSwitchResultIsError_returnsUnderlyingError() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .error
        let fakeError = NSError(domain: "FakeError", code: 1, userInfo: nil)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedError = fakeError

        let expectation = self.expectation(description: "App switch completion callback")
        payPalDriver.setOneTimePaymentAppSwitchReturn ({ (tokenizedCheckout, error) -> Void in
            guard let error = error else {
                XCTFail()
                return
            }
            XCTAssertEqual(error as NSError, fakeError)
            expectation.fulfill()
        })

        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)

        self.waitForExpectations(timeout: 5, handler: nil)
    }

    func testCheckout_whenUsingCustomHandler_callsHandleApprovalDelegateMethod() {
        guard #available(iOS 9.0, *) else {
            return
        }

        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        let handler = MockPayPalApprovalHandlerDelegate()
        handler.url = NSURL(string: "some://url")

        handler.handleApprovalExpectation = self.expectation(description: "Delegate received handleApproval")
        let blockExpectation = self.expectation(description: "Completion block reached")
        payPalDriver.requestOneTimePayment(BTPayPalRequest(amount: "1"), handler: handler) { (_, _) in
            XCTAssertNotNil(handler);
            blockExpectation.fulfill()
        }

        self.waitForExpectations(timeout: 2, handler: nil)
    }

    func testtokenizedPayPalAccount_containsPayerInfo() {
        let checkoutResponse = [
            "paypalAccounts": [
                [
                    "nonce": "a-nonce",
                    "description": "A description",
                    "details": [
                        "email": "hello@world.com",
                        "payerInfo": [
                            "firstName": "Some",
                            "lastName": "Dude",
                            "phone": "867-5309",
                            "payerId": "FAKE-PAYER-ID",
                            "accountAddress": [
                                "street1": "1 Foo Ct",
                                "street2": "Apt Bar",
                                "city": "Fubar",
                                "state": "FU",
                                "postalCode": "42",
                                "country": "USA"
                            ],
                            "billingAddress": [
                                "recipientName": "Bar Foo",
                                "line1": "2 Foo Ct",
                                "line2": "Apt Foo",
                                "city": "Barfoo",
                                "state": "BF",
                                "postalCode": "24",
                                "countryCode": "ASU"
                            ],
                            "shippingAddress": [
                                "recipientName": "Some Dude",
                                "line1": "3 Foo Ct",
                                "line2": "Apt 5",
                                "city": "Dudeville",
                                "state": "CA",
                                "postalCode": "24",
                                "countryCode": "US"
                            ]
                        ]
                    ]
                ] ] ]
        assertSuccessfulCheckoutResponse(checkoutResponse as [String : AnyObject],
            assertionBlock: { (tokenizedPayPalAccount, error) -> Void in
                XCTAssertEqual(tokenizedPayPalAccount!.nonce, "a-nonce")
                XCTAssertEqual(tokenizedPayPalAccount!.localizedDescription, "A description")
                XCTAssertEqual(tokenizedPayPalAccount!.firstName, "Some")
                XCTAssertEqual(tokenizedPayPalAccount!.lastName, "Dude")
                XCTAssertEqual(tokenizedPayPalAccount!.phone, "867-5309")
                XCTAssertEqual(tokenizedPayPalAccount!.email, "hello@world.com")
                XCTAssertEqual(tokenizedPayPalAccount!.payerId, "FAKE-PAYER-ID")
                let billingAddress = tokenizedPayPalAccount!.billingAddress!
                let shippingAddress = tokenizedPayPalAccount!.shippingAddress!
                XCTAssertEqual(billingAddress.recipientName, "Bar Foo")
                XCTAssertEqual(billingAddress.streetAddress, "2 Foo Ct")
                XCTAssertEqual(billingAddress.extendedAddress, "Apt Foo")
                XCTAssertEqual(billingAddress.locality, "Barfoo")
                XCTAssertEqual(billingAddress.region, "BF")
                XCTAssertEqual(billingAddress.postalCode, "24")
                XCTAssertEqual(billingAddress.countryCodeAlpha2, "ASU")
                XCTAssertEqual(shippingAddress.recipientName, "Some Dude")
                XCTAssertEqual(shippingAddress.streetAddress, "3 Foo Ct")
                XCTAssertEqual(shippingAddress.extendedAddress, "Apt 5")
                XCTAssertEqual(shippingAddress.locality, "Dudeville")
                XCTAssertEqual(shippingAddress.region, "CA")
                XCTAssertEqual(shippingAddress.postalCode, "24")
                XCTAssertEqual(shippingAddress.countryCodeAlpha2, "US")
        })
    }

    func testtokenizedPayPalAccount_whenEmailAddressIsNestedInsidePayerInfoJSON_usesNestedEmailAddress() {
        let checkoutResponse = [
            "paypalAccounts": [
                [
                    "nonce": "fake-nonce",
                    "details": [
                        "email": "not-hello@world.com",
                        "payerInfo": [
                            "email": "hello@world.com",
                        ]
                    ],
                    ]
            ] ]
        assertSuccessfulCheckoutResponse(checkoutResponse as [String : AnyObject],
            assertionBlock: { (tokenizedPayPalAccount, error) -> Void in
                XCTAssertEqual(tokenizedPayPalAccount!.email, "hello@world.com")
        })
    }

    func testtokenizedPayPalAccount_whenDescriptionJSONIsPayPal_usesEmailAsLocalizedDescription() {
        let checkoutResponse = [
            "paypalAccounts": [
                [
                    "nonce": "fake-nonce",
                    "description": "PayPal",
                    "details": [
                        "email": "hello@world.com",
                    ],
                    ]
            ] ]
        assertSuccessfulCheckoutResponse(checkoutResponse as [String : AnyObject],
            assertionBlock: { (tokenizedPayPalAccount, error) -> Void in
                XCTAssertEqual(tokenizedPayPalAccount!.localizedDescription, "hello@world.com")
        })
    }

    // MARK: _meta parameter

    func testMetadata_whenCheckoutAppSwitchIsSuccessful_isPOSTedToServer() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        let stubPayPalClass = FakePayPalOneTouchCore.self
        stubPayPalClass.cannedResult()?.cannedType = .success
        stubPayPalClass.setCannedIsWalletAppAvailable(true)
        BTPayPalDriver.setPayPalClass(stubPayPalClass)
        payPalDriver.setOneTimePaymentAppSwitchReturn ({ _ -> Void in })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)

        XCTAssertEqual(mockAPIClient.lastPOSTPath, "/v1/payment_methods/paypal_accounts")
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        let metaParameters = lastPostParameters["_meta"] as! NSDictionary
        XCTAssertEqual(metaParameters["source"] as? String, "paypal-app")
        XCTAssertEqual(metaParameters["integration"] as? String, "custom")
        XCTAssertEqual(metaParameters["sessionId"] as? String, mockAPIClient.metadata.sessionId)
    }

    func testMetadata_whenCheckoutBrowserSwitchIsSuccessful_isPOSTedToServer() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        let stubPayPalClass = FakePayPalOneTouchCore.self
        stubPayPalClass.cannedResult()?.cannedType = .success
        stubPayPalClass.setCannedIsWalletAppAvailable(false)
        BTPayPalDriver.setPayPalClass(stubPayPalClass)
        payPalDriver.setOneTimePaymentAppSwitchReturn ({ _ -> Void in })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)

        XCTAssertEqual(mockAPIClient.lastPOSTPath, "/v1/payment_methods/paypal_accounts")
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        let metaParameters = lastPostParameters["_meta"] as! NSDictionary
        XCTAssertEqual(metaParameters["source"] as? String, "paypal-browser")
        XCTAssertEqual(metaParameters["integration"] as? String, "custom")
        XCTAssertEqual(metaParameters["sessionId"] as? String, mockAPIClient.metadata.sessionId)
    }

    // MARK: Helpers

    func assertSuccessfulCheckoutResponse(_ response: [String:AnyObject], assertionBlock: @escaping (BTPayPalAccountNonce?, NSError?) -> Void) {
        mockAPIClient.cannedResponseBody = BTJSON(value: response)
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .success

        payPalDriver.setOneTimePaymentAppSwitchReturn ({ (tokenizedPayPalAccount, error) -> Void in
            assertionBlock(tokenizedPayPalAccount, error as NSError?)
        })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
    }

    // MARK: - Analytics
    
    func testAPIClientMetadata_whenWalletAppIsInstalled_hasSourceSetToPayPalApp() {
        // API client by default uses source = .Unknown and integration = .Custom
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        // It is critical to stub PayPalClass before instantiating the driver, since that is when source is set
        let stubPayPalClass = FakePayPalOneTouchCore.self
        stubPayPalClass.setCannedIsWalletAppAvailable(true)
        BTPayPalDriver.setPayPalClass(stubPayPalClass)
        let payPalDriver = BTPayPalDriver(apiClient: apiClient)
        
        XCTAssertEqual(payPalDriver.apiClient?.metadata.integration, BTClientMetadataIntegrationType.custom)
        XCTAssertEqual(payPalDriver.apiClient?.metadata.source, BTClientMetadataSourceType.payPalApp)
    }
    
    func testAPIClientMetadata_whenWalletAppIsNotAvailable_hasSourceSetToPayPalBrowser() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        let stubPayPalClass = FakePayPalOneTouchCore.self
        stubPayPalClass.setCannedIsWalletAppAvailable(false)
        BTPayPalDriver.setPayPalClass(stubPayPalClass)
        let payPalDriver = BTPayPalDriver(apiClient: apiClient)
        
        XCTAssertEqual(payPalDriver.apiClient?.metadata.integration, BTClientMetadataIntegrationType.custom)
        XCTAssertEqual(payPalDriver.apiClient?.metadata.source, BTClientMetadataSourceType.payPalBrowser)
    }
}

// MARK: - Billing Agreements

class BTPayPalDriver_BillingAgreements_Tests: XCTestCase {
    
    var mockAPIClient : MockAPIClient = MockAPIClient(authorization: "development_tokenization_key")!
    
    override func setUp() {
        super.setUp()
        
        mockAPIClient = MockAPIClient(authorization: "development_tokenization_key")!
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        mockAPIClient.cannedResponseBody = BTJSON(value: [
            "paymentResource": [
                "redirectUrl": "fakeURL://"
            ] ])
        
    }
    
    func testBillingAgreement_whenAPIClientIsNil_callsBackWithError() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.apiClient = nil
        
        let request = BTPayPalRequest(amount: "1")
        let expectation = self.expectation(description: "Billing Agreement fails with error")
        payPalDriver.requestBillingAgreement(request) { (tokenizedPayPalAccount, error) -> Void in
            XCTAssertNil(tokenizedPayPalAccount)
            guard let error = error as? NSError else {return}
            XCTAssertEqual(error.domain, BTPayPalDriverErrorDomain)
            XCTAssertEqual(error.code, BTPayPalDriverErrorType.integration.rawValue)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testBillingAgreement_whenRemoteConfigurationFetchFails_callsBackWithConfigurationError() {
        mockAPIClient.cannedConfigurationResponseBody = nil
        mockAPIClient.cannedConfigurationResponseError = NSError(domain: "", code: 0, userInfo: nil)
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        
        let request = BTPayPalRequest()
        let expectation = self.expectation(description: "Checkout fails with error")
        payPalDriver.requestBillingAgreement(request) { (_, error) -> Void in
            XCTAssertEqual(error! as NSError, self.mockAPIClient.cannedConfigurationResponseError!)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testBillingAgreement_whenRemoteConfigurationFetchSucceeds_postsSetupBillingAgreement() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        payPalDriver.requestBillingAgreement(BTPayPalRequest()) { _ -> Void in }
        
        XCTAssertEqual("v1/paypal_hermes/setup_billing_agreement", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertEqual(lastPostParameters["return_url"] as? String, "scheme://return")
        XCTAssertEqual(lastPostParameters["cancel_url"] as? String, "scheme://cancel")
        XCTAssertEqual(lastPostParameters["offer_paypal_credit"] as? Bool, false)
    }
    
    func testBillingAgreement_whenPayPalCreditOffered_performsSwitchCorrectly() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let request = BTPayPalRequest()
        request.offerCredit = true
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        // Depending on whether it's iOS 9 or not, we use different stub delegates to wait for the app switch to occur
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        let stubAppSwitchDelegate = MockAppSwitchDelegate()
        if #available(iOS 9.0, *) {
            stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
            payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        } else {
            stubAppSwitchDelegate.willPerformAppSwitchExpectation =  expectation(description: "Delegate received willPerformAppSwitch")
            stubAppSwitchDelegate.didPerformAppSwitchExpectation = expectation(description: "Delegate received didPerformAppSwitch")
            payPalDriver.appSwitchDelegate = stubAppSwitchDelegate
        }
        
        payPalDriver.requestBillingAgreement(request) { _ in }
        
        self.waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(mockRequestFactory.billingAgreementRequest.appSwitchPerformed)
        
        // Ensure the payment resource had the correct parameters
        XCTAssertEqual("v1/paypal_hermes/setup_billing_agreement", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertEqual(lastPostParameters["offer_paypal_credit"] as? Bool, true)
        
        // Make sure analytics event was sent when switch occurred
        let postedAnalyticsEvents = mockAPIClient.postedAnalyticsEvents
        
        if #available(iOS 9.0, *) {
            XCTAssertTrue(postedAnalyticsEvents.contains("ios.paypal-ba.webswitch.credit.offered.started"))
        } else {
            XCTAssertTrue(postedAnalyticsEvents.contains("ios.paypal-ba.appswitch.credit.offered.started"))
        }
    }
    
    func testBillingAgreement_whenAppSwitchSucceeds_tokenizesPayPalAccount() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .success
        
        payPalDriver.setBillingAgreementAppSwitchReturn ({ _ -> Void in })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        
        XCTAssertEqual(mockAPIClient.lastPOSTPath, "/v1/payment_methods/paypal_accounts")
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        let paypalAccount = lastPostParameters["paypal_account"] as! NSDictionary
        XCTAssertEqual(paypalAccount, FakePayPalOneTouchCoreResult().response as AnyObject as! NSDictionary)
    }
    
    func testBillingAgreement_whenConfigurationHasCurrency_doesNotSendCurrencyOrIntentViaPOSTParameters() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline",
                "currencyIsoCode": "GBP",
            ] ])
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        
        payPalDriver.requestBillingAgreement(BTPayPalRequest()) { _ -> Void in }
        
        XCTAssertEqual("v1/paypal_hermes/setup_billing_agreement", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertTrue(lastPostParameters["currency_iso_code"] == nil)
        XCTAssertTrue(lastPostParameters["intent"] == nil)
    }
    
    func testBillingAgreement_whenCheckoutRequestHasCurrency_doesNotSendCurrencyViaPOSTParameters() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let request = BTPayPalRequest()
        request.currencyCode = "GBP"
        
        payPalDriver.requestBillingAgreement(request) { _ -> Void in }
        
        XCTAssertEqual("v1/paypal_hermes/setup_billing_agreement", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertTrue(lastPostParameters["currency_iso_code"] == nil)
    }

    func testBillingAgreement_whenRequestHasBillingAgreementDescription_sendsDescriptionInParameters() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let request = BTPayPalRequest()
        request.billingAgreementDescription = "My Billing Agreement description"

        payPalDriver.requestBillingAgreement(request) { _ -> Void in }

        XCTAssertEqual("v1/paypal_hermes/setup_billing_agreement", mockAPIClient.lastPOSTPath)
        guard let lastPostParameters = mockAPIClient.lastPOSTParameters else {
            XCTFail()
            return
        }
        XCTAssertEqual(lastPostParameters["description"] as? String, "My Billing Agreement description")
    }

    func testBillingAgreement_whenSetupBillingAgreementCreationSuccessful_performsPayPalRequestAppSwitch() {
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        let mockRequestFactory = FakePayPalRequestFactory()
        payPalDriver.requestFactory = mockRequestFactory
        // Depending on whether it's iOS 9 or not, we use different stub delegates to wait for the app switch to occur
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        let stubAppSwitchDelegate = MockAppSwitchDelegate()
        if #available(iOS 9.0, *) {
            stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
            payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        } else {
            stubAppSwitchDelegate.willPerformAppSwitchExpectation =  expectation(description: "Delegate received willPerformAppSwitch")
            stubAppSwitchDelegate.didPerformAppSwitchExpectation = expectation(description: "Delegate received didPerformAppSwitch")
            payPalDriver.appSwitchDelegate = stubAppSwitchDelegate
        }
        
        let request = BTPayPalRequest()
        payPalDriver.requestBillingAgreement(request) { _ -> Void in }
        
        self.waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(mockRequestFactory.billingAgreementRequest.appSwitchPerformed)
    }
    
    func testBillingAgreement_whenSetupBillingAgreementCreationFails_callsBackWithError() {
        mockAPIClient.cannedResponseError = NSError(domain: "", code: 0, userInfo: nil)
        
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        let dummyRequest = BTPayPalRequest()
        let expectation = self.expectation(description: "Checkout fails with error")
        payPalDriver.requestBillingAgreement(dummyRequest) { (_, error) -> Void in
            XCTAssertEqual(error! as NSError, self.mockAPIClient.cannedResponseError!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    func testBillingAgreement_whenSFSafariViewControllerIsAvailable_callsViewControllerPresentationDelegateMethods() {
        guard #available(iOS 9.0, *) else {
            return
        }
        
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        let viewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        
        // Setup for requestsPersentationOfViewController
        viewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = self.expectation(description: "Delegate received requestsPresentationOfViewController")
        
        payPalDriver.viewControllerPresentingDelegate = viewControllerPresentingDelegate
        payPalDriver.informDelegatePresentingViewControllerRequestPresent(URL(string: "http://example.com")!)
        
        self.waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertTrue(viewControllerPresentingDelegate.lastViewController is SFSafariViewController)
        XCTAssertEqual(viewControllerPresentingDelegate.lastViewController, payPalDriver.safariViewController)
        let payPalDriverViewControllerPresented = payPalDriver.safariViewController
        XCTAssertEqual(viewControllerPresentingDelegate.lastPaymentDriver as? BTPayPalDriver, payPalDriver)
        
        viewControllerPresentingDelegate.lastViewController = nil
        viewControllerPresentingDelegate.lastPaymentDriver = nil
        
        // Setup for requestsDismissalOfViewController
        viewControllerPresentingDelegate.requestsDismissalOfViewControllerExpectation = self.expectation(description: "Delegate received requestsDismissalOfViewController")
        payPalDriver.informDelegatePresentingViewControllerNeedsDismissal()
        
        self.waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertTrue(viewControllerPresentingDelegate.lastViewController is SFSafariViewController)
        XCTAssertEqual(viewControllerPresentingDelegate.lastViewController as? SFSafariViewController, payPalDriverViewControllerPresented)
        XCTAssertNil(payPalDriver.safariViewController)
        
        XCTAssertEqual(viewControllerPresentingDelegate.lastPaymentDriver as? BTPayPalDriver, payPalDriver)
    }

    func testBillingAgreement_whenSFSafariViewControllerIsAvailableButNoViewControllerPresentingDelegateSet_logsError() {
        guard #available(iOS 9.0, *) else {
            return
        }

        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        
        var criticalMessageLogged = false
        BTLogger.shared().logBlock = {
            (level: BTLogLevel, message: String?) in
            if (level == BTLogLevel.critical && message == "Unable to display View Controller to continue PayPal flow. BTPayPalDriver needs a viewControllerPresentingDelegate<BTViewControllerPresentingDelegate> to be set.") {
                criticalMessageLogged = true
            }
            return
        }

        payPalDriver.informDelegatePresentingViewControllerRequestPresent(URL(string: "http://example.com")!)
        XCTAssertTrue(criticalMessageLogged)
    }
    
    func testBillingAgreement_whenSFSafariViewControllerIsAvailable_doesNotCallAppSwitchDelegateMethods() {
        guard #available(iOS 9.0, *) else {
            return
        }
        
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = PPOTResultType.success
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        payPalDriver.returnURLScheme = "foo://"
        payPalDriver.requestFactory = FakePayPalRequestFactory()
        let stubViewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
        stubViewControllerPresentingDelegate.requestsPresentationOfViewControllerExpectation = expectation(description: "Delegate received requestsPresentationOfViewController")
        payPalDriver.viewControllerPresentingDelegate = stubViewControllerPresentingDelegate
        let mockAppSwitchDelegate = MockAppSwitchDelegate()
        payPalDriver.appSwitchDelegate = mockAppSwitchDelegate
        
        payPalDriver.requestBillingAgreement(BTPayPalRequest(amount: "1")) { _ -> Void in }
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertFalse(mockAppSwitchDelegate.willPerformAppSwitchCalled)
        XCTAssertFalse(mockAppSwitchDelegate.didPerformAppSwitchCalled)
        
        stubViewControllerPresentingDelegate.requestsDismissalOfViewControllerExpectation = expectation(description: "Delegate received requestsDismissalOfViewController")
        
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertFalse(mockAppSwitchDelegate.willProcessAppSwitchCalled)
    }

    func testBillingAgreement_whenUsingCustomHandler_callsHandleApprovalDelegateMethod() {
        guard #available(iOS 9.0, *) else {
            return
        }

        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        payPalDriver.returnURLScheme = "foo://"
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)

        let handler = MockPayPalApprovalHandlerDelegate()
        handler.url = NSURL(string: "some://url")

        handler.handleApprovalExpectation = self.expectation(description: "Delegate received handleApproval")
        let blockExpectation = self.expectation(description: "Completion block reached")
        payPalDriver.requestBillingAgreement(BTPayPalRequest(), handler: handler) { (_, _) in
            XCTAssertNotNil(handler);
            blockExpectation.fulfill()
        }

        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testBillingAgreement_whenCreditFinancingNotReturned_shouldNotSendCreditAcceptedAnalyticsEvent() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        mockAPIClient.cannedResponseBody = BTJSON(value: [ "paypalAccounts":
            [
                [
                    "description": "jane.doe@example.com",
                    "details": [
                        "email": "jane.doe@example.com",
                    ],
                    "nonce": "a-nonce",
                    "type": "PayPalAccount",
                    ]
            ]
            ])
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .success
        payPalDriver.payPalRequest = BTPayPalRequest()
        
        payPalDriver.setBillingAgreementAppSwitchReturn ({ _ -> Void in })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        
        XCTAssertFalse(mockAPIClient.postedAnalyticsEvents.contains("ios.paypal-ba.credit.accepted"))
    }
    
    func testBillingAgreement_whenCreditFinancingReturned_shouldSendCreditAcceptedAnalyticsEvent() {
        let payPalDriver = BTPayPalDriver(apiClient: mockAPIClient)
        mockAPIClient = payPalDriver.apiClient as! MockAPIClient
        mockAPIClient.cannedResponseBody = BTJSON(value: [ "paypalAccounts":
            [
                [
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
                    "nonce": "a-nonce",
                    "type": "PayPalAccount",
                    ]
            ]
            ])
        BTPayPalDriver.setPayPalClass(FakePayPalOneTouchCore.self)
        BTPayPalDriver.payPalClass().cannedResult()?.cannedType = .success
        payPalDriver.payPalRequest = BTPayPalRequest()
        
        payPalDriver.setBillingAgreementAppSwitchReturn ({ _ -> Void in })
        BTPayPalDriver.handleAppSwitchReturn(URL(string: "bar://hello/world")!)
        
        XCTAssertTrue(mockAPIClient.postedAnalyticsEvents.contains("ios.paypal-ba.credit.accepted"))
    }
}

class BTPayPalDriver_DropIn_Tests: XCTestCase {
    
    var mockAPIClient : MockAPIClient = MockAPIClient(authorization: "development_tokenization_key")!
    
    override func setUp() {
        super.setUp()
        
        mockAPIClient = MockAPIClient(authorization: "development_tokenization_key")!
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "paypalEnabled": true,
            "paypal": [
                "environment": "offline"
            ] ])
        mockAPIClient.cannedResponseBody = BTJSON(value: [
            "paymentResource": [
                "redirectUrl": "fakeURL://"
            ] ])
    }
    
    func testDropInViewDelegateSet() {
        let dropInViewController = BTDropInViewController(apiClient: mockAPIClient)

        var paymentButton : BTPaymentButton? = nil
        for subView in dropInViewController.view.subviews.first!.subviews.first!.subviews {
            if let view = subView as? BTPaymentButton {
                paymentButton = view
            }
        }
        
        XCTAssertNotNil(paymentButton)
        XCTAssertNotNil(paymentButton?.viewControllerPresentingDelegate)
        XCTAssertEqual(paymentButton?.viewControllerPresentingDelegate as? BTDropInViewController, dropInViewController)
    }

}

