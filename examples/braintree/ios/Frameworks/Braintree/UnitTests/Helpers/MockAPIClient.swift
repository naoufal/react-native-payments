import BraintreeCore

class MockAPIClient : BTAPIClient {
    var lastPOSTPath = ""
    var lastPOSTParameters = [:] as [AnyHashable: Any]?
    var lastGETPath = ""
    var lastGETParameters = [:] as [String : String]?
    var postedAnalyticsEvents : [String] = []

    var cannedConfigurationResponseBody : BTJSON? = nil
    var cannedConfigurationResponseError : NSError? = nil

    var cannedResponseError : NSError? = nil
    var cannedHTTPURLResponse : HTTPURLResponse? = nil
    var cannedResponseBody : BTJSON? = nil

    var fetchedPaymentMethods = false
    var fetchPaymentMethodsSorting = false
    
    override func get(_ path: String, parameters: [String : String]?, completion completionBlock: ((BTJSON?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        lastGETPath = path
        lastGETParameters = parameters

        guard let completionBlock = completionBlock else {
            return
        }
        completionBlock(cannedResponseBody, cannedHTTPURLResponse, cannedResponseError)
    }

    override func post(_ path: String, parameters: [AnyHashable : Any]?, completion completionBlock: ((BTJSON?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        lastPOSTPath = path
        lastPOSTParameters = parameters

        guard let completionBlock = completionBlock else {
            return
        }
        completionBlock(cannedResponseBody, cannedHTTPURLResponse, cannedResponseError)
    }

    override func fetchOrReturnRemoteConfiguration(_ completionBlock: @escaping (BTConfiguration?, Error?) -> Void) {
        guard let responseBody = cannedConfigurationResponseBody else {
            completionBlock(nil, cannedConfigurationResponseError)
            return
        }
        completionBlock(BTConfiguration(json: responseBody), cannedConfigurationResponseError)
    }

    override func fetchPaymentMethodNonces(_ completion: @escaping ([BTPaymentMethodNonce]?, Error?) -> Void) {
        fetchedPaymentMethods = true
        fetchPaymentMethodsSorting = false
        completion([], nil)
    }
    
    override func fetchPaymentMethodNonces(_ defaultFirst: Bool, completion: @escaping ([BTPaymentMethodNonce]?, Error?) -> Void) {
        fetchedPaymentMethods = true
        fetchPaymentMethodsSorting = false
        completion([], nil)
    }

    /// BTAPIClient gets copied by other classes like BTPayPalDriver, BTVenmoDriver, etc.
    /// This copy causes MockAPIClient to lose its stubbed data (canned responses), so the
    /// workaround for tests is to stub copyWithSource:integration: to *not* copy itself
    override func copy(with source: BTClientMetadataSourceType, integration: BTClientMetadataIntegrationType) -> Self {
        return self
    }

    override func sendAnalyticsEvent(_ name: String) {
        postedAnalyticsEvents.append(name)
    }

    func didFetchPaymentMethods(sorted: Bool) -> Bool {
        return fetchedPaymentMethods && fetchPaymentMethodsSorting == sorted
    }
}
