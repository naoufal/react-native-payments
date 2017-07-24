import XCTest

class BTDropInViewController_Tests: XCTestCase {

    class BTDropInViewControllerTestDelegate : NSObject, BTDropInViewControllerDelegate {
        var didLoadExpectation: XCTestExpectation

        init(didLoadExpectation: XCTestExpectation) {
            self.didLoadExpectation = didLoadExpectation
        }

        @objc func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {}

        @objc func drop(inViewControllerDidCancel viewController: BTDropInViewController) {}

        @objc func drop(inViewControllerDidLoad viewController: BTDropInViewController) {
            didLoadExpectation.fulfill()
        }
    }

    var window : UIWindow!
    var viewController : UIViewController!
    let ValidClientToken = "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI3ODJhZmFlNDJlZTNiNTA4NWUxNmMzYjhkZTY3OGQxNTJhODFlYzk5MTBmZDNhY2YyYWU4MzA2OGI4NzE4YWZhfGNyZWF0ZWRfYXQ9MjAxNS0wOC0yMFQwMjoxMTo1Ni4yMTY1NDEwNjErMDAwMFx1MDAyNmN1c3RvbWVyX2lkPTM3OTU5QTE5LThCMjktNDVBNC1CNTA3LTRFQUNBM0VBOEM4Nlx1MDAyNm1lcmNoYW50X2lkPWRjcHNweTJicndkanIzcW5cdTAwMjZwdWJsaWNfa2V5PTl3d3J6cWszdnIzdDRuYzgiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL2RjcHNweTJicndkanIzcW4vY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjpmYWxzZSwibWVyY2hhbnRBY2NvdW50SWQiOiJzdGNoMm5mZGZ3c3p5dHc1IiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sImNvaW5iYXNlRW5hYmxlZCI6dHJ1ZSwiY29pbmJhc2UiOnsiY2xpZW50SWQiOiIxMWQyNzIyOWJhNThiNTZkN2UzYzAxYTA1MjdmNGQ1YjQ0NmQ0ZjY4NDgxN2NiNjIzZDI1NWI1NzNhZGRjNTliIiwibWVyY2hhbnRBY2NvdW50IjoiY29pbmJhc2UtZGV2ZWxvcG1lbnQtbWVyY2hhbnRAZ2V0YnJhaW50cmVlLmNvbSIsInNjb3BlcyI6ImF1dGhvcml6YXRpb25zOmJyYWludHJlZSB1c2VyIiwicmVkaXJlY3RVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbS9jb2luYmFzZS9vYXV0aC9yZWRpcmVjdC1sYW5kaW5nLmh0bWwiLCJlbnZpcm9ubWVudCI6Im1vY2sifSwibWVyY2hhbnRJZCI6ImRjcHNweTJicndkanIzcW4iLCJ2ZW5tbyI6Im9mZmxpbmUiLCJhcHBsZVBheSI6eyJzdGF0dXMiOiJtb2NrIiwiY291bnRyeUNvZGUiOiJVUyIsImN1cnJlbmN5Q29kZSI6IlVTRCIsIm1lcmNoYW50SWRlbnRpZmllciI6Im1lcmNoYW50LmNvbS5icmFpbnRyZWVwYXltZW50cy5zYW5kYm94LkJyYWludHJlZS1EZW1vIiwic3VwcG9ydGVkTmV0d29ya3MiOlsidmlzYSIsIm1hc3RlcmNhcmQiLCJhbWV4Il19fQ=="

    override func setUp() {
        super.setUp()

        viewController = UIApplication.shared.windows[0].rootViewController
    }

    override func tearDown() {
        if viewController.presentedViewController != nil {
            viewController.dismiss(animated: false, completion: nil)
        }

        super.tearDown()
    }

    func testInitializesWithCheckoutRequestCorrectly() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        let request = BTPaymentRequest()
        let dropInViewController = BTDropInViewController(apiClient: apiClient)
        dropInViewController.paymentRequest = request
        XCTAssertEqual(request, dropInViewController.paymentRequest)
        XCTAssertEqual(apiClient.tokenizationKey, dropInViewController.apiClient.tokenizationKey)

        // By default, Drop-in does not set any bar button items. The developer should embed Drop-in in a navigation controller
        // as seen in BraintreeDemoDropInViewController, or provide some other way to dismiss Drop-in.
        XCTAssertNil(dropInViewController.navigationItem.leftBarButtonItem)
        XCTAssertNil(dropInViewController.navigationItem.rightBarButtonItem)

        let didLoadExpectation = self.expectation(description: "Drop-in did finish loading")
        let testDelegate = BTDropInViewControllerTestDelegate(didLoadExpectation: didLoadExpectation) // for strong reference
        dropInViewController.delegate = testDelegate

        DispatchQueue.main.async { () -> Void in
            self.viewController.present(dropInViewController, animated: false, completion: nil)
        }

        self.waitForExpectations(timeout: 5, handler: nil)
    }

    func testInitializesWithoutCheckoutRequestCorrectly() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        let request = BTPaymentRequest()

        // When this is true, the call to action control will be hidden from Drop-in's content view. Instead, a submit button will be
        // added as a navigation bar button item. The default value is false.
        request.shouldHideCallToAction = true

        let dropInViewController = BTDropInViewController(apiClient: apiClient)
        dropInViewController.paymentRequest = request

        XCTAssertEqual(request, dropInViewController.paymentRequest)
        XCTAssertEqual(apiClient.tokenizationKey, dropInViewController.apiClient.tokenizationKey)
        XCTAssertNil(dropInViewController.navigationItem.leftBarButtonItem)

        // There will be a rightBarButtonItem instead of a call to action control because it has been set to hide.
        XCTAssertNotNil(dropInViewController.navigationItem.rightBarButtonItem)

        let didLoadExpectation = self.expectation(description: "Drop-in did finish loading")
        let testDelegate = BTDropInViewControllerTestDelegate(didLoadExpectation: didLoadExpectation) // for strong reference
        dropInViewController.delegate = testDelegate

        DispatchQueue.main.async { () -> Void in
            self.viewController.present(dropInViewController, animated: false, completion: nil)
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }

    func testDropIn_canSetNewCheckoutRequestAfterPresentation() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        let request = BTPaymentRequest()
        let dropInViewController = BTDropInViewController(apiClient: apiClient)
        dropInViewController.paymentRequest = request
        XCTAssertEqual(request, dropInViewController.paymentRequest)
        XCTAssertEqual(apiClient.tokenizationKey, dropInViewController.apiClient.tokenizationKey)

        // By default, Drop-in does not set any bar button items. The developer should embed Drop-in in a navigation controller
        // as seen in BraintreeDemoDropInViewController, or provide some other way to dismiss Drop-in.
        XCTAssertNil(dropInViewController.navigationItem.leftBarButtonItem)
        XCTAssertNil(dropInViewController.navigationItem.rightBarButtonItem)

        let didLoadExpectation = self.expectation(description: "Drop-in did finish loading")
        let testDelegate = BTDropInViewControllerTestDelegate(didLoadExpectation: didLoadExpectation) // for strong reference
        dropInViewController.delegate = testDelegate

        DispatchQueue.main.async { () -> Void in
            self.viewController.present(dropInViewController, animated: false, completion: nil)
        }
        self.waitForExpectations(timeout: 5, handler: nil)

        let newRequest = BTPaymentRequest()
        newRequest.shouldHideCallToAction = true
        dropInViewController.paymentRequest = newRequest
        XCTAssertNil(dropInViewController.navigationItem.leftBarButtonItem)

        // There will now be a rightBarButtonItem because shouldHideCallToAction = true; this button is the replacement
        // of the call to action control.
        XCTAssertNotNil(dropInViewController.navigationItem.rightBarButtonItem)
    }

    func testDropIn_addPaymentMethodViewController_hidesCTA() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        let dropInViewController = BTDropInViewController(apiClient: apiClient)
        let addPaymentMethodDropInViewController = dropInViewController.addPaymentMethod()
        XCTAssertTrue((addPaymentMethodDropInViewController?.paymentRequest!.shouldHideCallToAction)!)
        XCTAssertNotNil(addPaymentMethodDropInViewController?.navigationItem.rightBarButtonItem)

        let didLoadExpectation = self.expectation(description: "Add payment method view controller did finish loading")
        let testDelegate = BTDropInViewControllerTestDelegate(didLoadExpectation: didLoadExpectation) // for strong reference
        addPaymentMethodDropInViewController?.delegate = testDelegate

        DispatchQueue.main.async { () -> Void in
            self.viewController.present(addPaymentMethodDropInViewController!, animated: false, completion: nil)
        }

        self.waitForExpectations(timeout: 5, handler: nil)
    }

    func testDropIn_whenPresentViewControllersFromTopIsTrue_presentsViewControllersFromTopViewController() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        let dropInViewController = BTDropInViewController(apiClient: apiClient)
        let paymentRequest = BTPaymentRequest()
        paymentRequest.presentViewControllersFromTop = true
        dropInViewController.paymentRequest = paymentRequest
        let mockViewController = UIViewController()
        let windowRootController = UIViewController()
        let secondWindow = UIWindow(frame: UIScreen.main.bounds)
        secondWindow.rootViewController = windowRootController
        secondWindow.makeKeyAndVisible()
        secondWindow.windowLevel = 100
        let topSecondTopController = BTDropInUtil.topViewController()

        dropInViewController.paymentDriver(nil, requestsPresentationOf: mockViewController)

        let expectation = self.expectation(description: "Sleeping for presentation")
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertEqual(mockViewController.presentingViewController, topSecondTopController)
    }

    // MARK: - Metadata

    func testAPIClientMetadata_afterInstantiation_hasIntegrationSetToDropIn() {
        let apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        let dropIn = BTDropInViewController(apiClient: apiClient)

        XCTAssertEqual(dropIn.apiClient.metadata.integration, BTClientMetadataIntegrationType.dropIn)
    }

    func testAPIClientMetadata_afterInstantiation_hasSourceSetToOriginalAPIClientMetadataSource() {
        var apiClient = BTAPIClient(authorization: "development_testing_integration_merchant_id")!
        apiClient = apiClient.copy(with: BTClientMetadataSourceType.unknown, integration: BTClientMetadataIntegrationType.custom)
        let dropIn = BTDropInViewController(apiClient: apiClient)

        XCTAssertEqual(dropIn.apiClient.metadata.source, BTClientMetadataSourceType.unknown)
    }

    // MARK: - Payment method fetching

    func testFetchPaymentMethods_byDefault_doesNotCallAPIClientWithDefaultSortedFirst() {
        let mockAPIClient = MockAPIClient(authorization: ValidClientToken)!
        let dropIn = BTDropInViewController(apiClient: mockAPIClient)

        let expectation = self.expectation(description: "Callback invoked")
        dropIn.fetchPaymentMethods { () -> Void in
            XCTAssertTrue(mockAPIClient.didFetchPaymentMethods(sorted: false))
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPaymentMethods_sortDefaultFirstOverriden_callsAPIClientWithDefaultSortedFirst() {
        let mockAPIClient = MockAPIClient(authorization: ValidClientToken)!
        let paymentRequest = BTPaymentRequest()
        paymentRequest.showDefaultPaymentMethodNonceFirst = false
        let dropIn = BTDropInViewController(apiClient: mockAPIClient)
        dropIn.paymentRequest = paymentRequest

        let expectation = self.expectation(description: "Callback invoked")
        dropIn.fetchPaymentMethods { () -> Void in
            XCTAssertTrue(mockAPIClient.didFetchPaymentMethods(sorted: false))
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}
