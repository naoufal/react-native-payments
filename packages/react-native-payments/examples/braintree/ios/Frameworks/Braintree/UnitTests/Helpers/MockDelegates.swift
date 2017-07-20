import XCTest

@objc class MockAppSwitchDelegate : NSObject, BTAppSwitchDelegate {
    var willPerformAppSwitchExpectation : XCTestExpectation? = nil
    var didPerformAppSwitchExpectation : XCTestExpectation? = nil
    var willProcessAppSwitchExpectation : XCTestExpectation? = nil
    // XCTestExpectations verify that delegates callbacks are made; the below bools verify that they are NOT made
    var willPerformAppSwitchCalled = false
    var didPerformAppSwitchCalled = false
    var willProcessAppSwitchCalled = false
    var lastAppSwitcher : AnyObject? = nil

    override init() { }

    init(willPerform: XCTestExpectation?, didPerform: XCTestExpectation?) {
        willPerformAppSwitchExpectation = willPerform
        didPerformAppSwitchExpectation = didPerform
    }

    @objc func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        lastAppSwitcher = appSwitcher as AnyObject?
        willPerformAppSwitchExpectation?.fulfill()
        willPerformAppSwitchCalled = true
    }

    @objc func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        lastAppSwitcher = appSwitcher as AnyObject?
        didPerformAppSwitchExpectation?.fulfill()
        didPerformAppSwitchCalled = true
    }

    @objc func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        lastAppSwitcher = appSwitcher as AnyObject?
        willProcessAppSwitchExpectation?.fulfill()
        willProcessAppSwitchCalled = true
    }
}

@objc class MockViewControllerPresentationDelegate : NSObject, BTViewControllerPresentingDelegate {
    var requestsPresentationOfViewControllerExpectation : XCTestExpectation? = nil
    var requestsDismissalOfViewControllerExpectation : XCTestExpectation? = nil
    var lastViewController : UIViewController? = nil
    var lastPaymentDriver : AnyObject? = nil

    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        lastPaymentDriver = driver as AnyObject?
        lastViewController = viewController
        requestsDismissalOfViewControllerExpectation?.fulfill()
    }

    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        lastPaymentDriver = driver as AnyObject?
        lastViewController = viewController
        requestsPresentationOfViewControllerExpectation?.fulfill()
    }
}

@objc class MockPayPalApprovalHandlerDelegate : NSObject, BTPayPalApprovalHandler {
    var handleApprovalExpectation : XCTestExpectation? = nil
    var url : NSURL? = nil
    var cancel : Bool = false

    func handleApproval(_ request: PPOTRequest, paypalApprovalDelegate delegate: BTPayPalApprovalDelegate) {
        if (cancel) {
            delegate.onApprovalCancel()
        } else {
            delegate.onApprovalComplete(url as! URL)
        }
        handleApprovalExpectation?.fulfill()
    }
}
