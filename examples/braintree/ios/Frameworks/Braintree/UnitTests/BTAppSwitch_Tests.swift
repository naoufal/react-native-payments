import XCTest

class BTAppSwitch_Tests: XCTestCase {

    var appSwitch = BTAppSwitch.sharedInstance()

    override func setUp() {
        super.setUp()
        appSwitch = BTAppSwitch.sharedInstance()
    }
    
    override func tearDown() {
        MockAppSwitchHandler.cannedCanHandle = false
        MockAppSwitchHandler.lastCanHandleURL = nil
        MockAppSwitchHandler.lastCanHandleSourceApplication = nil
        MockAppSwitchHandler.lastHandleAppSwitchReturnURL = nil
        super.tearDown()
    }

    func testHandleOpenURL_whenHandlerIsRegistered_invokesCanHandleAppSwitchReturnURL() {
        appSwitch.register(MockAppSwitchHandler.self)
        let expectedURL = URL(string: "fake://url")!
        let expectedSourceApplication = "fakeSourceApplication"

        BTAppSwitch.handleOpen(expectedURL, sourceApplication: expectedSourceApplication)

        XCTAssertEqual(MockAppSwitchHandler.lastCanHandleURL!, expectedURL)
        XCTAssertEqual(MockAppSwitchHandler.lastCanHandleSourceApplication!, expectedSourceApplication)
    }

    func testHandleOpenURL_whenHandlerCanHandleOpenURL_invokesHandleAppSwitchReturnURL() {
        appSwitch.register(MockAppSwitchHandler.self)
        MockAppSwitchHandler.cannedCanHandle = true
        let expectedURL = URL(string: "fake://url")!

        let handled = BTAppSwitch.handleOpen(expectedURL, sourceApplication: "not important")
        
        XCTAssert(handled)
        XCTAssertEqual(MockAppSwitchHandler.lastHandleAppSwitchReturnURL!, expectedURL)
    }

    func testHandleOpenURL_whenHandlerCantHandleOpenURL_doesNotInvokeHandleAppSwitchReturnURL() {
        appSwitch.register(MockAppSwitchHandler.self)
        MockAppSwitchHandler.cannedCanHandle = false

        BTAppSwitch.handleOpen(URL(string: "fake://url")!, sourceApplication: "not important")

        XCTAssertNil(MockAppSwitchHandler.lastHandleAppSwitchReturnURL)
    }

    func testHandleOpenURL_whenHandlerCantHandleOpenURL_returnsFalse() {
        appSwitch.register(MockAppSwitchHandler.self)
        MockAppSwitchHandler.cannedCanHandle = false

        XCTAssertFalse(BTAppSwitch.handleOpen(URL(string: "fake://url")!, sourceApplication: "not important"))
    }
    
    func testHandleOpenURL_acceptsOptionalSourceApplication() {
        // This doesn't assert any behavior about nil source application. It only checks that the code will compile!
        let sourceApplication : String? = nil
        BTAppSwitch.handleOpen(URL(string: "fake://url")!, sourceApplication: sourceApplication)
    }
    
    func testHandleOpenURL_withNoAppSwitching() {
        let handled = BTAppSwitch.handleOpen(URL(string: "scheme://")!, sourceApplication: "com.yourcompany.hi")
        XCTAssertFalse(handled)
    }

}

class MockAppSwitchHandler: BTAppSwitchHandler {
    static var cannedCanHandle = false
    static var lastCanHandleURL : URL? = nil
    static var lastCanHandleSourceApplication : String? = nil
    static var lastHandleAppSwitchReturnURL : URL? = nil

    @objc static func canHandleAppSwitchReturn(_ url: URL, sourceApplication: String) -> Bool {
        lastCanHandleURL = url
        lastCanHandleSourceApplication = sourceApplication
        return cannedCanHandle
    }

    @objc static func handleAppSwitchReturn(_ url: URL) {
        lastHandleAppSwitchReturnURL = url
    }
}
