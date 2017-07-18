/*
 IMPORTANT
 Hardware keyboard should be disabled on simulator for tests to run reliably.
 */

import XCTest

class BraintreeDropInLegacy_TokenizationKey_CardForm_UITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-EnvironmentSandbox")
        app.launchArguments.append("-TokenizationKey")
        app.launchArguments.append("-Integration:BraintreeDemoDropInLegacyViewController")
        app.launch()
        sleep(1)
        self.waitForElementToBeHittable(app.buttons["Buy Now"])
        app.buttons["Buy Now"].tap()
        
    }
    
    func testDropInLegacy_cardInput_receivesNonce() {
        
        let elementsQuery = app.scrollViews.otherElements
        let cardNumberTextField = elementsQuery.textFields["Card Number"]
        let expiryTextField = elementsQuery.textFields["MM/YY"]
        let postalCodeTextField = elementsQuery.textFields["Postal Code"]
        let cvvTextField = elementsQuery.textFields["CVV"]
        
        self.waitForElementToBeHittable(cardNumberTextField)
        
        cardNumberTextField.forceTapElement()
        cardNumberTextField.typeText("4111111111111111")
        expiryTextField.typeText("1119")

        let postalCodeField = elementsQuery.textFields["Postal Code"]
        self.waitForElementToBeHittable(postalCodeField)
        postalCodeField.forceTapElement()
        postalCodeField.typeText("12345")
        
        let securityCodeField = elementsQuery.textFields["CVV"]
        self.waitForElementToBeHittable(securityCodeField)
        securityCodeField.forceTapElement()
        securityCodeField.typeText("123")

        elementsQuery.buttons["$19 - Subscribe Now"].forceTapElement()

        self.waitForElementToAppear(app.buttons["Got a nonce. Tap to make a transaction."])
        
        XCTAssertTrue(app.buttons["Got a nonce. Tap to make a transaction."].exists);
    }
    
    func testDropInLegacy_cardInput_showsInvalidState_withInvalidCardNumber() {
        
        let elementsQuery = app.scrollViews.otherElements
        let cardNumberTextField = elementsQuery.textFields["Card Number"]
        
        self.waitForElementToBeHittable(cardNumberTextField)
        
        cardNumberTextField.forceTapElement()
        cardNumberTextField.typeText("4141414141414141")
        
        self.waitForElementToAppear(elementsQuery.textFields["Invalid: Card Number"])
    }
    
    func testDropInLegacy_cardInput_showsInvalidState_withInvalidExpirationDate() {
        
        let elementsQuery = app.scrollViews.otherElements
        let expiryTextField = elementsQuery.textFields["MM/YY"]
        self.waitForElementToBeHittable(expiryTextField)
        
        expiryTextField.forceTapElement()
        expiryTextField.typeText("1111")
        
        self.waitForElementToAppear(elementsQuery.textFields["Invalid: MM/YY"])
    }
    
    func testDropInLegacy_cardInput_hidesInvalidCardNumberState_withDeletion() {
        
        let elementsQuery = app.scrollViews.otherElements
        let cardNumberTextField = elementsQuery.textFields["Card Number"]
        self.waitForElementToBeHittable(cardNumberTextField)
        
        cardNumberTextField.forceTapElement()
        cardNumberTextField.typeText("4141414141414141")
        
        self.waitForElementToAppear(elementsQuery.textFields["Invalid: Card Number"])
        
        cardNumberTextField.typeText("\u{8}")
        
        XCTAssertFalse(elementsQuery.textFields["Invalid: Card Number"].exists);
    }
    
    func testDropInLegacy_cardInput_hidesInvalidExpirationState_withDeletion() {
        
        let elementsQuery = app.scrollViews.otherElements
        let expirationField = elementsQuery.textFields["MM/YY"]
        self.waitForElementToBeHittable(expirationField)
        
        expirationField.forceTapElement()
        expirationField.typeText("1111")
        
        self.waitForElementToAppear(elementsQuery.textFields["Invalid: MM/YY"])
        
        expirationField.typeText("\u{8}")
        
        XCTAssertFalse(elementsQuery.textFields["Invalid: MM/YY"].exists);
    }
}

class BraintreeDropInLegacy_ClientToken_CardForm_UITests: XCTestCase {
    
    //    var app: XCUIApplication!
    //
    //    override func setUp() {
    //        super.setUp()
    //        continueAfterFailure = false
    //        app = XCUIApplication()
    //        app.launchArguments.append("-EnvironmentSandbox")
    //        app.launchArguments.append("-ClientToken")
    //        app.launchArguments.append("-Integration:BraintreeDemoDropInLegacyViewController")
    //        app.launch()
    //        self.waitForElementToAppear(app.buttons["Buy Now"])
    //        app.buttons["Buy Now"].forceTapElement()
    //    }
    //
    //    // This test card number is now valid
    //    // Is this related to Union Pay?
    //    func pendDropInLegacy_cardInput_displaysErrorForFailedValidation() {
    //
    //        let elementsQuery = app.scrollViews.otherElements
    //        let cardNumberTextField = elementsQuery.textFields["Card Number"]
    //        let expirationField = elementsQuery.textFields["MM/YY"]
    //
    //        cardNumberTextField.forceTapElement()
    //        cardNumberTextField.typeText("5105105105105100")
    //        expirationField.typeText("1119")
    //
    //        elementsQuery.buttons["$19 - Subscribe Now"].forceTapElement()
    //
    //        self.waitForElementToAppear(app.alerts.staticTexts["Credit card verification failed"])
    //
    //        XCTAssertTrue(app.alerts.staticTexts["Credit card verification failed"].exists);
    //    }
}


class BraintreeDropInLegacy_PayPal_UITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-EnvironmentSandbox")
        app.launchArguments.append("-TokenizationKey")
        app.launchArguments.append("-Integration:BraintreeDemoDropInLegacyViewController")
        app.launch()
        sleep(1)
        self.waitForElementToBeHittable(app.buttons["Buy Now"])
        app.buttons["Buy Now"].forceTapElement()
    }
    
    func testDropInLegacy_paypal_receivesNonce() {
        
        let elementsQuery = app.collectionViews["Payment Options"].cells
        let paypalButton = elementsQuery.element(boundBy: 0)
        paypalButton.forceTapElement()
        sleep(3)
        
        let webviewElementsQuery = app.webViews.element.otherElements
        
        self.waitForElementToBeHittable(webviewElementsQuery.links["Proceed with Sandbox Purchase"])
        
        webviewElementsQuery.links["Proceed with Sandbox Purchase"].forceTapElement()
        
        self.waitForElementToAppear(app.buttons["Got a nonce. Tap to make a transaction."])
        
        XCTAssertTrue(app.buttons["Got a nonce. Tap to make a transaction."].exists);
    }
}
