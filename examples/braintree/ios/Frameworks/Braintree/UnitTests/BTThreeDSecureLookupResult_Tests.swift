import XCTest

class BTThreeDSecureLookupResult_Tests: XCTestCase {
    
    func testRequiresUserAuthentication_whenAcsUrlIsPresent_returnsTrue() {
        let lookup = BTThreeDSecureLookupResult()
        lookup.acsURL = URL(string: "http://example.com")
        lookup.termURL = URL(string: "http://example.com")
        lookup.md = "an-md"
        lookup.paReq = "a-PAReq"

        XCTAssertTrue(lookup.requiresUserAuthentication())
    }

    func testRequiresUserAuthentication_whenAcsUrlIsNotPresent_returnsFalse() {
        let lookup = BTThreeDSecureLookupResult()
        lookup.acsURL = nil
        lookup.termURL = URL(string: "http://example.com")
        lookup.md = "an-md"
        lookup.paReq = "a-PAReq"

        XCTAssertFalse(lookup.requiresUserAuthentication())
    }
}
