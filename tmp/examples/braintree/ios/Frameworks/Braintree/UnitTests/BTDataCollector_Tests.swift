import XCTest
import PayPalDataCollector
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class BTDataCollector_Tests: XCTestCase {
    
    var testDelegate: TestDelegateForBTDataCollector?
    
    /// We check the delegate because it's the only exposed property of the dataCollector
    func testInitsWithNilDelegate() {
        let dataCollector = BTDataCollector(environment: BTDataCollectorEnvironment.sandbox)
        XCTAssertNil(dataCollector.delegate)
    }
    
    func testSuccessfullyCollectsCardDataAndCallsDelegateMethods() {
        let dataCollector = BTDataCollector(environment: .sandbox)
        testDelegate = TestDelegateForBTDataCollector(didStartExpectation: expectation(description: "didStart"), didCompleteExpectation: expectation(description: "didComplete"))
        dataCollector.delegate = testDelegate
        let stubKount = FakeDeviceCollectorSDK()
        dataCollector.kount = stubKount

        let jsonString = dataCollector.collectCardFraudData()

        let data = jsonString.data(using: String.Encoding.utf8)
        let dictionary = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
        XCTAssert((dictionary["device_session_id"] as! String).characters.count >= 32)
        XCTAssertEqual(dictionary["fraud_merchant_id"] as? String, "600000") // BTDataCollectorSharedMerchantId
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    /// Ensure that both Kount and PayPal data can be collected together
    func testCollectFraudData() {
        let dataCollector = BTDataCollector(environment: .sandbox)
        testDelegate = TestDelegateForBTDataCollector(didStartExpectation: expectation(description: "didStart"), didCompleteExpectation: expectation(description: "didComplete"))
        dataCollector.delegate = testDelegate
        let stubKount = FakeDeviceCollectorSDK()
        dataCollector.kount = stubKount
        BTDataCollector.setPayPalDataCollectorClass(FakePPDataCollector.self)
        
        let jsonString = dataCollector.collectFraudData()
        
        let data = jsonString.data(using: String.Encoding.utf8)
        let dictionary = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
        XCTAssert((dictionary["device_session_id"] as! String).characters.count >= 32)
        XCTAssertEqual(dictionary["fraud_merchant_id"] as? String, "600000") // BTDataCollectorSharedMerchantId
        
        // Ensure correlation_id (clientMetadataId) is not nil and has a length of at least 12.
        // This is just a guess of a reasonable id length. In practice, the id
        // typically has a length of 32.
        XCTAssertEqual(dictionary["correlation_id"] as? String, "fakeclientmetadataid")

        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCollectCardFraudData_doesNotReturnCorrelationId() {
        let config = [
            "environment":"development" as AnyObject,
            "kount": [
                "enabled": true,
                "kountMerchantId": "500000"
            ]
            ] as [String : Any]
        let apiClient = clientThatReturnsConfiguration(config as [String : AnyObject])
        
        let dataCollector = BTDataCollector(apiClient: apiClient)
        let expectation = self.expectation(description: "Returns fraud data")
        
        dataCollector.collectCardFraudData { (fraudData: String) in
            let json = BTJSON(data: fraudData.data(using: String.Encoding.utf8)!)
            XCTAssertNil(json["correlation_id"] as? String)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testOverrideMerchantId_usesMerchantProvidedId() {
        let config = [
            "environment":"development",
            "kount": [
                "enabled": true,
                "kountMerchantId": "500000"
            ]
            ] as [String : Any]
        
        let apiClient = clientThatReturnsConfiguration(config as [String : AnyObject])
        
        let dataCollector = BTDataCollector(apiClient: apiClient)
        dataCollector.setFraudMerchantId("500001")
        let expectation = self.expectation(description: "Returns fraud data")
        
        dataCollector.collectFraudData { (fraudData: String) in
            let json = BTJSON(data: fraudData.data(using: String.Encoding.utf8)!)
            XCTAssertEqual((json["fraud_merchant_id"] as AnyObject).asString(), "500001")
            XCTAssert((json["device_session_id"] as AnyObject).asString()?.characters.count >= 32)
            XCTAssert((json["correlation_id"] as AnyObject).asString()?.characters.count > 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCollectFraudDataWithCompletionBlock_whenMerchantHasKountConfiguration_usesConfiguration() {
        let config = [
            "environment": "development" as AnyObject,
            "kount": [
                "enabled": true,
                "kountMerchantId": "500000"
            ]
            ] as [String : Any]
        let apiClient = clientThatReturnsConfiguration(config as [String : AnyObject])
        let dataCollector = BTDataCollector(apiClient: apiClient)

        let expectation = self.expectation(description: "Returns fraud data")
        dataCollector.collectFraudData { fraudData in
            let json = BTJSON(data: fraudData.data(using: String.Encoding.utf8)!)
            XCTAssertEqual((json["fraud_merchant_id"] as AnyObject).asString(), "500000")
            XCTAssert((json["device_session_id"] as AnyObject).asString()!.characters.count >= 32)
            XCTAssert((json["correlation_id"] as AnyObject).asString()!.characters.count > 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testCollectFraudDataWithCompletionBlock_whenMerchantHasKountConfiguration_setsMerchantIDOnKount() {
        let config = [
            "environment": "sandbox",
            "kount": [
                "enabled": true,
                "kountMerchantId": "500000"
            ]
        ] as [String : Any]
        let apiClient = clientThatReturnsConfiguration(config as [String : AnyObject])
        let dataCollector = BTDataCollector(apiClient: apiClient)
        let stubKount = FakeDeviceCollectorSDK()
        dataCollector.kount = stubKount

        let expectation = self.expectation(description: "Returns fraud data")
        dataCollector.collectFraudData { fraudData in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertEqual(500000, stubKount.merchantID)
        XCTAssertEqual(KEnvironment.test, stubKount.environment)
    }

    func testCollectFraudData_doesNotCollectKountDataIfDisabledInConfiguration() {
        let apiClient = clientThatReturnsConfiguration([
            "environment":"development" as AnyObject
        ])
        
        let dataCollector = BTDataCollector(apiClient: apiClient)
        let expectation = self.expectation(description: "Returns fraud data")
        dataCollector.collectFraudData { fraudData in
            let json = BTJSON(data: fraudData.data(using: String.Encoding.utf8)!)
            XCTAssertNil(json["fraud_merchant_id"] as? String)
            XCTAssertNil(json["device_session_id"] as? String)
            XCTAssert((json["correlation_id"] as AnyObject).asString()?.characters.count > 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}

func clientThatReturnsConfiguration(_ configuration: [String:AnyObject]) -> BTAPIClient {
    let apiClient = BTAPIClient(authorization: "development_tokenization_key", sendAnalyticsEvent: false)!
    let fakeHttp = BTFakeHTTP()!
    let cannedConfig = BTJSON(value: configuration)
    fakeHttp.cannedConfiguration = cannedConfig
    fakeHttp.cannedStatusCode = 200
    apiClient.configurationHTTP = fakeHttp
    
    return apiClient
}

class TestDelegateForBTDataCollector: NSObject, BTDataCollectorDelegate {
    
    var didStartExpectation: XCTestExpectation?
    var didCompleteExpectation: XCTestExpectation?
    
    var didFailExpectation: XCTestExpectation?
    var error: NSError?
    
    init(didStartExpectation: XCTestExpectation, didCompleteExpectation: XCTestExpectation) {
        self.didStartExpectation = didStartExpectation
        self.didCompleteExpectation = didCompleteExpectation
    }
    
    init(didFailExpectation: XCTestExpectation) {
        self.didFailExpectation = didFailExpectation
    }
    
    func dataCollectorDidStart(_ dataCollector: BTDataCollector) {
        didStartExpectation?.fulfill()
    }
    
    func dataCollectorDidComplete(_ dataCollector: BTDataCollector) {
        didCompleteExpectation?.fulfill()
    }
    
    func dataCollector(_ dataCollector: BTDataCollector, didFailWithError error: Error) {
        self.error = error as NSError
        self.didFailExpectation?.fulfill()
    }
}

class FakeDeviceCollectorSDK: KDataCollector {
    
    var lastCollectSessionID: String?
    var forceError = false

    override func collect(forSession sessionID: String, completion completionBlock: ((String, Bool, Error?) -> Void)? = nil) {
        lastCollectSessionID = sessionID
        if forceError {
            completionBlock?("1981", false, NSError(domain: "Fake", code: 1981, userInfo: nil))
        } else {
            completionBlock?(sessionID, true, nil)
        }
    }
}

class FakePPDataCollector: PPDataCollector {
    
    static var didGetClientMetadataID = false

    override class func generateClientMetadataID() -> String {
        return generateClientMetadataID(nil)
    }

    override class func generateClientMetadataID(_ pairingID: String?) -> String {
        didGetClientMetadataID = true
        return "fakeclientmetadataid"
    }
}
