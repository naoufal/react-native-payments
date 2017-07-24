import XCTest

class BTPaymentRequest_Tests: XCTestCase {
    
    func testPaymentRequest_initializesAndCopiesCorrectly() {
        let paymentRequest = BTPaymentRequest()
        XCTAssertNil(paymentRequest.summaryTitle)
        XCTAssertNil(paymentRequest.summaryDescription)
        XCTAssertEqual("", paymentRequest.displayAmount)
        XCTAssertEqual("Pay", paymentRequest.callToActionText)
        XCTAssertFalse(paymentRequest.shouldHideCallToAction)
        XCTAssertNil(paymentRequest.amount)
        XCTAssertNil(paymentRequest.currencyCode)
        XCTAssertFalse(paymentRequest.noShipping)
        XCTAssertFalse(paymentRequest.presentViewControllersFromTop)
        XCTAssertNil(paymentRequest.shippingAddress)
        XCTAssertFalse(paymentRequest.showDefaultPaymentMethodNonceFirst)
        
        let paymentRequestCopy = paymentRequest.copy() as! BTPaymentRequest
        XCTAssertNil(paymentRequestCopy.summaryTitle)
        XCTAssertNil(paymentRequestCopy.summaryDescription)
        XCTAssertEqual("", paymentRequestCopy.displayAmount)
        XCTAssertEqual("Pay", paymentRequestCopy.callToActionText)
        XCTAssertFalse(paymentRequestCopy.shouldHideCallToAction)
        XCTAssertNil(paymentRequestCopy.amount)
        XCTAssertNil(paymentRequestCopy.currencyCode)
        XCTAssertFalse(paymentRequestCopy.noShipping)
        XCTAssertFalse(paymentRequestCopy.presentViewControllersFromTop)
        XCTAssertNil(paymentRequestCopy.shippingAddress)
        XCTAssertFalse(paymentRequest.showDefaultPaymentMethodNonceFirst)
    }
    
    func testPaymentRequest_valuesAreSetAndCopiedCorrectly() {
        let paymentRequest = BTPaymentRequest()
        paymentRequest.summaryTitle = "My Summary Title"
        paymentRequest.summaryDescription = "My Summary Description"
        paymentRequest.displayAmount = "$123.45"
        paymentRequest.callToActionText = "My Call To Action"
        paymentRequest.shouldHideCallToAction = true
        paymentRequest.amount = "123.45"
        paymentRequest.currencyCode = "USD"
        paymentRequest.noShipping = true
        paymentRequest.presentViewControllersFromTop = true
        let shippingAddress = BTPostalAddress()
        paymentRequest.shippingAddress = shippingAddress
        
        XCTAssertEqual("My Summary Title", paymentRequest.summaryTitle)
        XCTAssertEqual("My Summary Description", paymentRequest.summaryDescription)
        XCTAssertEqual("$123.45", paymentRequest.displayAmount)
        XCTAssertEqual("My Call To Action", paymentRequest.callToActionText)
        XCTAssertTrue(paymentRequest.shouldHideCallToAction)
        XCTAssertEqual("123.45", paymentRequest.amount)
        XCTAssertEqual("USD", paymentRequest.currencyCode)
        XCTAssertTrue(paymentRequest.noShipping)
        XCTAssertTrue(paymentRequest.presentViewControllersFromTop)
        XCTAssertEqual(shippingAddress, paymentRequest.shippingAddress)
        
        let paymentRequestCopy = paymentRequest.copy() as! BTPaymentRequest
        XCTAssertEqual("My Summary Title", paymentRequestCopy.summaryTitle)
        XCTAssertEqual("My Summary Description", paymentRequestCopy.summaryDescription)
        XCTAssertEqual("$123.45", paymentRequestCopy.displayAmount)
        XCTAssertEqual("My Call To Action", paymentRequestCopy.callToActionText)
        XCTAssertTrue(paymentRequestCopy.shouldHideCallToAction)
        XCTAssertEqual("123.45", paymentRequestCopy.amount)
        XCTAssertEqual("USD", paymentRequestCopy.currencyCode)
        XCTAssertTrue(paymentRequestCopy.noShipping)
        XCTAssertTrue(paymentRequestCopy.presentViewControllersFromTop)
        XCTAssertEqual(shippingAddress, paymentRequestCopy.shippingAddress)
    }
}
