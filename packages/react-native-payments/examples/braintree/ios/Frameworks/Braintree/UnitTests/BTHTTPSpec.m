#import "BTHTTP.h"
#import "BTHTTPTestProtocol.h"
#import "BTSpecHelper.h"
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

NSURL *validDataURL() {
    NSDictionary *validObject = @{@"clientId":@"a-client-id", @"nest": @{@"nested":@"nested-value"}};
    NSError *jsonSerializationError;
    NSData *configurationData = [NSJSONSerialization dataWithJSONObject:validObject
                                                                options:0
                                                                  error:&jsonSerializationError];
    NSString *base64EncodedConfigurationData = [configurationData base64EncodedStringWithOptions:0];
    NSString *dataURLString = [NSString stringWithFormat:@"data:application/json;base64,%@", base64EncodedConfigurationData];
    return [NSURL URLWithString:dataURLString];
}

NSDictionary *parameterDictionary() {
    return @{@"stringParameter": @"value",
             @"crazyStringParameter[]": @"crazy%20and&value",
             @"numericParameter": @42,
             @"trueBooleanParameter": @YES,
             @"falseBooleanParameter": @NO,
             @"dictionaryParameter":  @{ @"dictionaryKey": @"dictionaryValue" },
             @"arrayParameter": @[@"arrayItem1", @"arrayItem2"]
             };
}

void withStub(void (^block)(void (^removeStub)(void))) {
    id<OHHTTPStubsDescriptor> stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
        NSData *jsonResponse = [NSJSONSerialization dataWithJSONObject:@{@"requestHeaders": [request allHTTPHeaderFields]} options:NSJSONWritingPrettyPrinted error:nil];
        return [OHHTTPStubsResponse responseWithData:jsonResponse statusCode:200 headers:@{@"Content-Type": @"application/json"}];
    }];

    block(^{
        [OHHTTPStubs removeStub:stub];
    });
}

NSURLSession *testURLSession() {
    NSURLSessionConfiguration *testConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    [testConfiguration setProtocolClasses:@[[BTHTTPTestProtocol class]]];
    return [NSURLSession sessionWithConfiguration:testConfiguration];
}

@interface BTHTTPSpec : XCTestCase
@end

@implementation BTHTTPSpec {
    BTHTTP *http;
    id<OHHTTPStubsDescriptor> stubDescriptor;
}

#pragma mark - performing a request

- (void)setUp {
    [super setUp];

    http = [[BTHTTP alloc] initWithBaseURL:[BTHTTPTestProtocol testBaseURL] authorizationFingerprint:@"test-authorization-fingerprint"];
    http.session = testURLSession();
}

- (void)tearDown {
    [OHHTTPStubs removeAllStubs];

    [super tearDown];
}

#pragma mark - base URL

- (void)testRequests_useTheSpecifiedURLScheme {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET callback"];

    [http GET:@"200.json" completion:^(BTJSON *body, __unused NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];

        XCTAssertEqualObjects(httpRequest.URL.scheme, @"bt-http-test");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testRequests_useTheHostAtTheBaseURL {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET callback"];

    [http GET:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);
        NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];

        expect(httpRequest.URL.absoluteString).to.startWith(@"bt-http-test://base.example.com:1234/base/path/200.json");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testItAppendsThePathToTheBaseURL {
    waitUntil(^(DoneCallback done){
        [http GET:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);
            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];

            expect(httpRequest.URL.path).to.equal(@"/base/path/200.json");
            done();
        }];
    });
}

- (void)test_whenThePathIsNil_itHitsTheBaseURL {
    waitUntil(^(DoneCallback done){
        [http GET:@"/" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);
            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];

            expect(httpRequest.URL.path).to.equal(@"/base/path");
            done();
        }];
    });

    pending(@"returns a json serialization error if the parameters cannot be serialized");
    pending(@"appends the authorization fingerprint to all requests");
}

#pragma mark - data base URLs

- (void)testReturnsTheData {
    waitUntil(^(DoneCallback done) {
        http = [[BTHTTP alloc] initWithBaseURL:validDataURL() authorizationFingerprint:@"test-authorization-fingerprint"];

        [http GET:@"/" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            expect([body[@"clientId"] asString]).to.equal(@"a-client-id");
            expect([body[@"nest"][@"nested"] asString]).to.equal(@"nested-value");
            done();
        }];
    });
}

- (void)testIgnoresPOSTData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Perform request"];

    http = [[BTHTTP alloc] initWithBaseURL:validDataURL() authorizationFingerprint:@"test-authorization-fingerprint"];

    [http POST:@"/" parameters:@{@"a-post-param":@"POST"} completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);

        expect(response.statusCode).to.equal(200);
        expect(error).to.beNil();
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testIgnoresGETParameters {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Perform request"];

    http = [[BTHTTP alloc] initWithBaseURL:validDataURL() authorizationFingerprint:@"test-authorization-fingerprint"];

    [http GET:@"/" parameters:@{@"a-get-param": @"GET"} completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);

        expect(response.statusCode).to.equal(200);
        expect(error).to.beNil();
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:nil];
}
- (void)testIgnoresTheSpecifiedPath {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Perform request"];

    http = [[BTHTTP alloc] initWithBaseURL:validDataURL() authorizationFingerprint:@"test-authorization-fingerprint"];

    [http GET:@"/resource" completion:^(__unused BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);

        expect(response.statusCode).to.equal(200);
        expect(error).to.beNil();
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testSetsTheContentTypeHeader {
    NSURL *dataURL = [NSURL URLWithString:@"data:text/plain;base64,SGVsbG8sIFdvcmxkIQo="];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Perform request"];

    http = [[BTHTTP alloc] initWithBaseURL:dataURL authorizationFingerprint:@"test-authorization-fingerprint"];

    [http GET:@"/" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNil(body);
        XCTAssertNil(response);
        expect(error.domain).to.equal(BTHTTPErrorDomain);
        expect(error.code).to.equal(BTHTTPErrorCodeResponseContentTypeNotAcceptable);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testSetsTheResponseStatusCode {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Perform request"];

    http = [[BTHTTP alloc] initWithBaseURL:validDataURL() authorizationFingerprint:@"test-authorization-fingerprint"];

    [http GET:@"/" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);

        expect(response.statusCode).notTo.beNil();
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testFailsLikeAnHTTP500WhenTheBase64EncodedDataIsInvalid {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Perform request"];

    NSString *dataURLString = [NSString stringWithFormat:@"data:application/json;base64,%@", @"BAD-BASE-64-STRING"];

    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:dataURLString] authorizationFingerprint:@"test-authorization-fingerprint"];
    [http GET:@"/" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNil(body);
        XCTAssertNil(response);
        XCTAssertNotNil(error);

        expect(response).to.beNil();
        expect(error).notTo.beNil();
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - HTTP methods

- (void)testSendsGETRequest {
    waitUntil(^(DoneCallback done){
        [http GET:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);
            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            expect(httpRequest.URL.path).to.match(@"/200.json$");
            expect(httpRequest.HTTPMethod).to.equal(@"GET");
            expect(httpRequest.HTTPBody).to.beNil();
            done();
        }];
    });
}

- (void)testSendsGETRequestWithParameters {
    waitUntil(^(DoneCallback done){
        [http GET:@"200.json" parameters:@{@"param": @"value"} completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);
            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            expect(httpRequest.URL.path).to.match(@"/200.json$");
            expect(httpRequest.URL.query).to.contain(@"param=value");
            expect(httpRequest.HTTPMethod).to.equal(@"GET");
            expect(httpRequest.HTTPBody).to.beNil();
            done();
        }];
    });
}

- (void)testSendsPOSTRequest {
    waitUntil(^(DoneCallback done) {
        [http POST:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            expect(httpRequest.URL.path).to.match(@"/200.json$");
            expect(httpRequest.HTTPBody).to.beNil();
            expect(httpRequest.HTTPMethod).to.equal(@"POST");
            expect(httpRequest.URL.query).to.beNil();
            done();
        }];
    });
}

- (void)testSendsPOSTRequestWithParameters {
    waitUntil(^(DoneCallback done) {
        [http POST:@"200.json" parameters:@{@"param": @"value"} completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            NSString *httpRequestBody = [BTHTTPTestProtocol parseRequestBodyFromTestResponseBody:body];
            expect(httpRequest.URL.path).to.match(@"/200.json$");
            BTJSON *json = [[BTJSON alloc] initWithData:[httpRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
            expect([json[@"param"] asString]).to.equal(@"value");
            expect(httpRequest.HTTPMethod).to.equal(@"POST");
            expect(httpRequest.URL.query).to.beNil();
            done();
        }];
    });
}

- (void)testSendsPUTRequest {
    waitUntil(^(DoneCallback done) {
        [http PUT:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            expect(httpRequest.URL.path).to.match(@"200.json$");
            expect(httpRequest.HTTPBody).to.beNil();
            expect(httpRequest.HTTPMethod).to.equal(@"PUT");
            expect(httpRequest.URL.query).to.beNil();
            done();
        }];
    });
}

- (void)testSendsPUTRequestWithParameters {
    waitUntil(^(DoneCallback done) {
        [http PUT:@"200.json" parameters:@{@"param": @"value"} completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            NSString *httpRequestBody = [BTHTTPTestProtocol parseRequestBodyFromTestResponseBody:body];
            expect(httpRequest.URL.path).to.match(@"200.json$");
            BTJSON *json = [[BTJSON alloc] initWithData:[httpRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
            expect([json[@"param"] asString]).to.equal(@"value");
            expect(httpRequest.HTTPMethod).to.equal(@"PUT");
            expect(httpRequest.URL.query).to.beNil();
            done();
        }];
    });
}


- (void)testSendsADELETERequest {
    waitUntil(^(DoneCallback done){
        [http DELETE:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            expect(httpRequest.URL.path).to.match(@"200.json$");
            expect(httpRequest.HTTPBody).to.beNil();
            expect(httpRequest.HTTPMethod).to.equal(@"DELETE");
            done();
        }];
    });
}

- (void)testSendsDELETERequestWithParameters {
    waitUntil(^(DoneCallback done) {
        [http DELETE:@"200.json" parameters:@{@"param": @"value"} completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);
            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];

            expect(httpRequest.URL.path).to.match(@"/200.json$");
            expect(httpRequest.URL.query).to.contain(@"param=value");
            expect(httpRequest.HTTPMethod).to.equal(@"DELETE");
            expect(httpRequest.HTTPBody).to.beNil();
            done();
        }];
    });
}

#pragma mark Authentication

- (void)testGETRequests_whenBTHTTPInitializedWithAuthorizationFingerprint_sendAuthorizationInQueryParams {
    waitUntil(^(DoneCallback done){
        [http GET:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            expect(httpRequest.URL.query).to.equal(@"authorization_fingerprint=test-authorization-fingerprint");

            done();
        }];
    });
}

- (void)testGETRequests_whenBTHTTPInitializedWithTokenizationKey_sendTokenizationKeyInHeader {
    http = [[BTHTTP alloc] initWithBaseURL:[BTHTTPTestProtocol testBaseURL] tokenizationKey:@"development_tokenization_key"];
    http.session = testURLSession();

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET callback"];
    [http GET:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);
        NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];

        XCTAssertEqualObjects(httpRequest.allHTTPHeaderFields[@"Client-Key"], @"development_tokenization_key");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testPOSTRequests_whenBTHTTPInitializedWithAuthorizationFingerprint_sendAuthorizationInBody {
    waitUntil(^(DoneCallback done){
        [http POST:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            NSString *httpRequestBody = [BTHTTPTestProtocol parseRequestBodyFromTestResponseBody:body];
            expect(httpRequestBody).to.equal(@"{\"authorization_fingerprint\":\"test-authorization-fingerprint\"}");

            done();
        }];
    });
}

- (void)testPOSTRequests_whenBTHTTPInitializedWithTokenizationKey_sendAuthorization {
    http = [[BTHTTP alloc] initWithBaseURL:[BTHTTPTestProtocol testBaseURL] tokenizationKey:@"development_tokenization_key"];
    http.session = testURLSession();

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET callback"];
    [http POST:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);

        NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
        XCTAssertEqualObjects(httpRequest.allHTTPHeaderFields[@"Client-Key"], @"development_tokenization_key");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testPUTRequests_whenBTHTTPInitializedWithAuthorizationFingerprint_sendAuthorizationInBody {
    waitUntil(^(DoneCallback done){
        [http PUT:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);
            
            NSString *httpRequestBody = [BTHTTPTestProtocol parseRequestBodyFromTestResponseBody:body];
            expect(httpRequestBody).to.equal(@"{\"authorization_fingerprint\":\"test-authorization-fingerprint\"}");

            done();
        }];
    });
}

- (void)testPUTRequests_whenBTHTTPInitializedWithTokenizationKey_sendAuthorization {
    http = [[BTHTTP alloc] initWithBaseURL:[BTHTTPTestProtocol testBaseURL] tokenizationKey:@"development_tokenization_key"];
    http.session = testURLSession();

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET callback"];
    [http PUT:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);

        NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
        XCTAssertEqualObjects(httpRequest.allHTTPHeaderFields[@"Client-Key"], @"development_tokenization_key");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testDELETERequests_whenBTHTTPInitializedWithAuthorizationFingerprint_sendAuthorizationInQueryParams {
    waitUntil(^(DoneCallback done) {
        [http DELETE:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            expect(httpRequest.URL.query).to.equal(@"authorization_fingerprint=test-authorization-fingerprint");

            done();
        }];
    });
}

- (void)testDELETERequests_whenBTHTTPInitializedWithTokenizationKey_sendAuthorization {
    http = [[BTHTTP alloc] initWithBaseURL:[BTHTTPTestProtocol testBaseURL] tokenizationKey:@"development_tokenization_key"];
    http.session = testURLSession();

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET callback"];
    [http DELETE:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);
        
        NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
        XCTAssertEqualObjects(httpRequest.allHTTPHeaderFields[@"Client-Key"], @"development_tokenization_key");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

#pragma mark - default headers

- (void)testIncludeAccept {
    waitUntil(^(DoneCallback done){
        withStub(^(void (^removeStub)(void)){
            [http GET:@"stub://200/resource" parameters:nil completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
                XCTAssertNotNil(body);
                XCTAssertNotNil(response);
                XCTAssertNil(error);

                NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
                NSDictionary *requestHeaders = httpRequest.allHTTPHeaderFields;
                expect(requestHeaders[@"Accept"]).to.equal(@"application/json");
                removeStub();
                done();
            }];
        });
    });
}

- (void)testIncludeUserAgent {
    waitUntil(^(DoneCallback done){
        withStub(^(void (^removeStub)(void)){
            [http GET:@"stub://200/resource" parameters:nil completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
                XCTAssertNotNil(body);
                XCTAssertNotNil(response);
                XCTAssertNil(error);

                NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
                NSDictionary *requestHeaders = httpRequest.allHTTPHeaderFields;
                expect(requestHeaders[@"User-Agent"]).to.match(@"^Braintree/iOS/\\d+\\.\\d+\\.\\d+(-[0-9a-zA-Z-]+)?$");
                removeStub();
                done();
            }];
        });
    });
}

- (void)testIncludeAcceptLanguage {
    waitUntil(^(DoneCallback done) {
        withStub(^(void (^removeStub)(void)) {
            [http GET:@"stub://200/resource" parameters:nil completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
                XCTAssertNotNil(body);
                XCTAssertNotNil(response);
                XCTAssertNil(error);

                NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
                NSDictionary *requestHeaders = httpRequest.allHTTPHeaderFields;
                NSLocale *locale = [NSLocale currentLocale];
                NSString *expectedLanguageString = [NSString stringWithFormat:@"%@-%@", [locale objectForKey:NSLocaleLanguageCode], [locale objectForKey:NSLocaleCountryCode]];
                expect(requestHeaders[@"Accept-Language"]).to.equal(expectedLanguageString);
                removeStub();
                done();
            }];
        });
    });
}


#pragma mark parameters

#pragma mark in GET requests
- (void)testTransmitsTheParametersAsURLEncodedQueryParameters {
    waitUntil(^(DoneCallback done){
        NSArray *expectedQueryParameters = @[ @"numericParameter=42",
                                              @"falseBooleanParameter=0",
                                              @"dictionaryParameter%5BdictionaryKey%5D=dictionaryValue",
                                              @"trueBooleanParameter=1",
                                              @"stringParameter=value",
                                              @"crazyStringParameter%5B%5D=crazy%2520and%26value",
                                              @"arrayParameter%5B%5D=arrayItem1",
                                              @"arrayParameter%5B%5D=arrayItem2" ];

        [http GET:@"200.json" parameters:parameterDictionary() completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            NSArray *actualQueryComponents = [httpRequest.URL.query componentsSeparatedByString:@"&"];

            for(NSString *expectedComponent in expectedQueryParameters){
                expect(actualQueryComponents).to.contain(expectedComponent);
            }

            done();
        }];
    });
}

#pragma mark in non-GET requests

- (void)testTransmitsTheParametersAsJSON {
    waitUntil(^(DoneCallback done){
        NSDictionary *expectedParameters = @{ @"numericParameter": @42,
                                              @"falseBooleanParameter": @NO,
                                              @"dictionaryParameter": @{
                                                      @"dictionaryKey": @"dictionaryValue"
                                                      },
                                              @"trueBooleanParameter": @YES,
                                              @"stringParameter": @"value",
                                              @"crazyStringParameter[]": @"crazy%20and&value",
                                              @"arrayParameter": @[ @"arrayItem1", @"arrayItem2" ],
                                              @"authorization_fingerprint": @"test-authorization-fingerprint" };

        [http POST:@"200.json" parameters:parameterDictionary() completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            NSURLRequest *httpRequest = [BTHTTPTestProtocol parseRequestFromTestResponseBody:body];
            NSString *httpRequestBody = [BTHTTPTestProtocol parseRequestBodyFromTestResponseBody:body];

            expect([httpRequest valueForHTTPHeaderField:@"Content-type"]).to.equal(@"application/json; charset=utf-8");
            NSDictionary *actualParameters = [NSJSONSerialization JSONObjectWithData:[httpRequestBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:0
                                                                               error:NULL];
            expect(actualParameters).to.equal(expectedParameters);
            done();
        }];
    });
}

#pragma mark interpreting responses

- (void)testCallsBackOnMainQueue {
    XCTestExpectation *expectation = [self expectationWithDescription:@"receive callback"];
    [http GET:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(dispatch_get_current_queue()).to.equal(dispatch_get_main_queue());
#pragma clang diagnostic pop
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testCallsBackOnSpecifiedQueue {
    XCTestExpectation *expectation = [self expectationWithDescription:@"receive callback"];
    http.dispatchQueue = dispatch_queue_create("com.braintreepayments.BTHTTPSpec.callbackQueueTest", DISPATCH_QUEUE_SERIAL);
    [http GET:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(dispatch_get_current_queue()).to.equal(http.dispatchQueue);
#pragma clang diagnostic pop
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark response code parser

- (void)testInterprets2xxAsACompletionWithSuccess {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];

    waitUntil(^(DoneCallback done){
        id<OHHTTPStubsDescriptor>stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithData:[NSJSONSerialization dataWithJSONObject:@{} options:NSJSONWritingPrettyPrinted error:NULL] statusCode:200 headers:@{@"Content-Type": @"application/json"}];
        }];

        [http GET:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            expect(response.statusCode).to.equal(200);

            expect(error).to.beNil();

            [OHHTTPStubs removeStub:stub];
            done();
        }];
    });
}

- (void)testResponseCodeParsing_whenStatusCodeIs4xx_returnsError {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];
    NSDictionary *errorBody = @{
                                @"error": @{
                                        @"message": @"This is an error message from the gateway"
                                        }
                                };

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET callback"];

    id<OHHTTPStubsDescriptor>stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[NSJSONSerialization dataWithJSONObject:errorBody options:NSJSONWritingPrettyPrinted error:NULL] statusCode:403 headers:@{@"Content-Type": @"application/json"}];
    }];

    [http GET:@"403.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertEqualObjects(body.asDictionary, errorBody);
        XCTAssertNotNil(response);
        XCTAssertEqualObjects(error.domain, BTHTTPErrorDomain);
        XCTAssertEqual(error.code, BTHTTPErrorCodeClientError);
        XCTAssertEqualObjects(((BTJSON *)error.userInfo[BTHTTPJSONResponseBodyKey]).asDictionary, errorBody);
        XCTAssertTrue([error.userInfo[BTHTTPURLResponseKey] isKindOfClass:[NSHTTPURLResponse class]]);
        XCTAssertEqualObjects(error.localizedDescription, @"This is an error message from the gateway");
        XCTAssertNotNil(error.userInfo[NSLocalizedFailureReasonErrorKey]);

        [OHHTTPStubs removeStub:stub];
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testResponseCodeParsing_whenStatusCodeIs429_returnsRateLimitError {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET callback"];
    
    id<OHHTTPStubsDescriptor>stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[NSJSONSerialization dataWithJSONObject:@{} options:NSJSONWritingPrettyPrinted error:NULL] statusCode:429 headers:@{@"Content-Type": @"application/json"}];
    }];
    
    [http GET:@"429.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertEqualObjects(body.asDictionary, @{});
        XCTAssertNotNil(response);
        XCTAssertEqualObjects(error.domain, BTHTTPErrorDomain);
        XCTAssertEqual(error.code, BTHTTPErrorCodeRateLimitError);
        XCTAssertEqualObjects(((BTJSON *)error.userInfo[BTHTTPJSONResponseBodyKey]).asDictionary, @{});
        XCTAssertTrue([error.userInfo[BTHTTPURLResponseKey] isKindOfClass:[NSHTTPURLResponse class]]);
        XCTAssertNotNil(error.userInfo[NSLocalizedFailureReasonErrorKey]);
        XCTAssertEqualObjects(error.userInfo[NSLocalizedDescriptionKey], @"You are being rate-limited.");
        XCTAssertEqualObjects(error.userInfo[NSLocalizedRecoverySuggestionErrorKey], @"Please try again in a few minutes.");

        [OHHTTPStubs removeStub:stub];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testResponseCodeParsing_whenStatusCodeIs5xx_returnsError {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];
    NSDictionary *errorBody = @{
                                @"error": @{
                                        @"message": @"This is an error message from the gateway"
                                        }
                                };
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET callback"];

    id<OHHTTPStubsDescriptor>stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[NSJSONSerialization dataWithJSONObject:errorBody options:NSJSONWritingPrettyPrinted error:NULL] statusCode:503 headers:@{@"Content-Type": @"application/json"}];
    }];

    [http GET:@"403.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertEqualObjects(body.asDictionary, errorBody);
        XCTAssertNotNil(response);
        XCTAssertEqualObjects(error.domain, BTHTTPErrorDomain);
        XCTAssertEqual(error.code, BTHTTPErrorCodeServerError);
        XCTAssertEqualObjects(((BTJSON *)error.userInfo[BTHTTPJSONResponseBodyKey]).asDictionary, errorBody);
        XCTAssertTrue([error.userInfo[BTHTTPURLResponseKey] isKindOfClass:[NSHTTPURLResponse class]]);
        XCTAssertEqualObjects(error.localizedDescription, @"This is an error message from the gateway");
        XCTAssertEqualObjects(error.localizedRecoverySuggestion, @"Please try again later.");
        XCTAssertNotNil(error.userInfo[NSLocalizedFailureReasonErrorKey]);

        [OHHTTPStubs removeStub:stub];
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}


- (void)testInterpretsTheNetworkBeingDownAsAnError {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];

    waitUntil(^(DoneCallback done){
        id<OHHTTPStubsDescriptor>stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil]];
        }];

        [http GET:@"network-down" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            expect(body).to.beNil();
            expect(response).to.beNil();
            expect(error.domain).to.equal(NSURLErrorDomain);
            expect(error.code).to.equal(NSURLErrorNotConnectedToInternet);
            [OHHTTPStubs removeStub:stub];
            done();
        }];
    });
}

- (void)testInterpretsTheServerBeingUnavailableAsAnError {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];

    waitUntil(^(DoneCallback done){
        id<OHHTTPStubsDescriptor>stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil]];
        }];


        [http GET:@"gateway-down" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            expect(body).to.beNil();
            expect(response).to.beNil();
            expect(error.domain).to.equal(NSURLErrorDomain);
            expect(error.code).to.equal(NSURLErrorCannotConnectToHost);
            [OHHTTPStubs removeStub:stub];
            done();
        }];
    });
}

#pragma mark response body parser

- (void)testParsesAJSONResponseBody {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];

    waitUntil(^(DoneCallback done){
        id<OHHTTPStubsDescriptor>stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithData:[@"{\"status\": \"OK\"}" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 headers:@{@"Content-Type": @"application/json"}];
        }];

        [http GET:@"200.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error){
            XCTAssertNotNil(body);
            XCTAssertNotNil(response);
            XCTAssertNil(error);

            expect([body[@"status"] asString]).to.equal(@"OK");

            [OHHTTPStubs removeStub:stub];
            done();
        }];
    });
}

- (void)testAcceptsEmptyResponses {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];

    waitUntil(^(DoneCallback done){
        id<OHHTTPStubsDescriptor>stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithData:[[NSData alloc] init] statusCode:200 headers:@{@"Content-Type": @"application/json"}];
        }];

        [http GET:@"empty.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error){
            expect(response.statusCode).to.equal(200);
            expect(body).to.beKindOf([BTJSON class]);
            expect(body.isObject).to.beTruthy();
            expect(body.asDictionary.count).to.equal(0);
            expect(error).to.beNil();

            [OHHTTPStubs removeStub:stub];
            done();
        }];
    });
}

- (void)testInterpretsInvalidJSONResponsesAsAJSONError {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];

    waitUntil(^(DoneCallback done){
        id<OHHTTPStubsDescriptor>stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithData:[@"{ really invalid json ]" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 headers:@{@"Content-Type": @"application/json"}];
        }];

        [http GET:@"invalid.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            expect(response).to.beNil();
            expect(body).to.beNil();
            expect(error.domain).to.equal(NSCocoaErrorDomain);

            [OHHTTPStubs removeStub:stub];
            done();
        }];
    });
}

- (void)testInterpretsNonJSONResponsesAsAContentTypeNotAcceptableError {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];

    waitUntil(^(DoneCallback done){
        id<OHHTTPStubsDescriptor>stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(__unused NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(__unused NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithData:[@"<html>response</html>" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 headers:@{@"Content-Type": @"text/html"}];
        }];

        [http GET:@"200.html" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
            XCTAssertNil(body);
            XCTAssertNil(response);
            XCTAssertNotNil(error);

            expect(response).to.beNil();

            expect(error.domain).to.equal(BTHTTPErrorDomain);
            expect(error.code).to.equal(BTHTTPErrorCodeResponseContentTypeNotAcceptable);

            [OHHTTPStubs removeStub:stub];
            done();
        }];
    });
}

- (void)testNoopsForANilCompletionBlock {
    http = [[BTHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"stub://stub"] authorizationFingerprint:@"test-authorization-fingerprint"];

    waitUntil(^(DoneCallback done){
        setAsyncSpecTimeout(2);

        [http GET:@"200.json" parameters:nil completion:nil];

        wait_for_potential_async_exceptions(done);
    });
}

#pragma mark isEqual:

- (void)testReturnsYESIfBTHTTPsHaveTheSameBaseURLAndAuthorizationFingerprint {
    NSURL *baseURL = [NSURL URLWithString:@"an-url://hi"];
    BTHTTP *http1  = [[BTHTTP alloc] initWithBaseURL:baseURL authorizationFingerprint:@"test-authorization-fingerprint"];
    BTHTTP *http2  = [[BTHTTP alloc] initWithBaseURL:baseURL authorizationFingerprint:@"test-authorization-fingerprint"];

    expect(http1).to.equal(http2);
}

- (void)testReturnsNOIfBTHTTPsDoNotHaveTheSameBaseURL {
    NSURL *baseURL1 = [NSURL URLWithString:@"an-url://hi"];
    NSURL *baseURL2 = [NSURL URLWithString:@"an-url://hi-again"];
    BTHTTP *http1  = [[BTHTTP alloc] initWithBaseURL:baseURL1 authorizationFingerprint:@"test-authorization-fingerprint"];
    BTHTTP *http2  = [[BTHTTP alloc] initWithBaseURL:baseURL2 authorizationFingerprint:@"test-authorization-fingerprint"];

    expect(http1).notTo.equal(http2);
}

- (void)testReturnsNOIfBTHTTPsDoNotHaveTheSameAuthorizationFingerprint {
    NSURL *baseURL1 = [NSURL URLWithString:@"an-url://hi"];
    BTHTTP *http1  = [[BTHTTP alloc] initWithBaseURL:baseURL1 authorizationFingerprint:@"test-authorization-fingerprint"];
    BTHTTP *http2  = [[BTHTTP alloc] initWithBaseURL:baseURL1 authorizationFingerprint:@"OTHER"];

    expect(http1).notTo.equal(http2);
}

#pragma mark copy

- (void)testReturnsADifferentInstance {
    http = [[BTHTTP alloc] initWithBaseURL:[BTHTTPTestProtocol testBaseURL] authorizationFingerprint:@"test-authorization-fingerprint"];

    expect(http).toNot.beIdenticalTo([http copy]);
}

- (void)testReturnsAnEqualInstance {
    http = [[BTHTTP alloc] initWithBaseURL:[BTHTTPTestProtocol testBaseURL] authorizationFingerprint:@"test-authorization-fingerprint"];
    
    expect([http copy]).to.equal(http);
}

- (void)testReturnedInstanceHasTheSameCertificates {
    http = [[BTHTTP alloc] initWithBaseURL:[BTHTTPTestProtocol testBaseURL] authorizationFingerprint:@"test-authorization-fingerprint"];
    
    BTHTTP *copiedHTTP = [http copy];
    expect(copiedHTTP.pinnedCertificates).to.equal(http.pinnedCertificates);
}

@end
