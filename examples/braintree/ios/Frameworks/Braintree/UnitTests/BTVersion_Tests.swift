import XCTest

class BTVersion_Tests: XCTestCase {
    
    func testVersion_returnsAVersion() {
        let regex = try! NSRegularExpression(pattern: "\\d+\\.\\d+\\.\\d+", options: [])
        let matches = regex.matches(in: BRAINTREE_VERSION, options: [], range: NSMakeRange(0, BRAINTREE_VERSION.characters.count))
        XCTAssertTrue(matches.count == 1)
    }

}
