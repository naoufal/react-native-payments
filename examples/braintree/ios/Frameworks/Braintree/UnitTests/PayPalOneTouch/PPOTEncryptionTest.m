//
//  PPOTEncryptionTest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PPOTEncryptionHelper.h"
#import "PPOTJSONHelper.h"
#import "PPOTString.h"

@interface PPOTEncryptionTest : XCTestCase

@end

@implementation PPOTEncryptionTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

+ (NSData *)randomData:(NSUInteger)length {
    NSMutableData *randomKey = [NSMutableData dataWithLength:length];
    int error = SecRandomCopyBytes(kSecRandomDefault, length, [randomKey mutableBytes]);
    return (error == 0) ? randomKey : nil;
}

- (void)testEncryptionMultiple {
    for (uint i=1; i<8*1024; i++) {
        NSData *plainData = [[self class] randomData:i];
        NSData *key = [PPOTEncryptionHelper generate256BitKey];
        NSData *cipherData = [PPOTEncryptionHelper encryptAESCTRData:plainData encryptionKey:key];
        XCTAssertNotEqualObjects(plainData, cipherData);

        NSData *outData = [PPOTEncryptionHelper decryptAESCTRData:cipherData encryptionKey:key];
        XCTAssertEqualObjects(outData, plainData);
    }
}

- (void)testRandomKeyGenerator {
    NSInteger numberOfKeys = 10;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:numberOfKeys];
    for (NSInteger i = 0; i < numberOfKeys; i++) {
        NSData *key = [PPOTEncryptionHelper generate256BitKey];
        XCTAssertTrue(key.length == 32);
        XCTAssertNotNil(key);
        XCTAssertFalse([array containsObject:key]);
        [array addObject:key];
    }
}

- (void)testHexFunction {
    NSString *hexStringExpected = @"68656C6C6F";
    NSString *string = @"hello";
    NSString *hexString = [PPOTString hexStringFromData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    XCTAssertEqualObjects(hexString, [hexStringExpected uppercaseString]);

    NSData *data = [PPOTString dataWithHexString:hexString];
    XCTAssertEqualObjects(data, [string dataUsingEncoding:NSUTF8StringEncoding]);
}

- (void)testEncryption {
    NSString *plainData = @"Trust me i am an Engineer !";
    NSData *key = [PPOTEncryptionHelper generate256BitKey];
    NSData *cipherData = [PPOTEncryptionHelper encryptAESCTRData:[plainData dataUsingEncoding:NSUTF8StringEncoding] encryptionKey:key];
    XCTAssertNotEqualObjects([plainData dataUsingEncoding:NSUTF8StringEncoding], cipherData);

    NSData *outData = [PPOTEncryptionHelper decryptAESCTRData:cipherData encryptionKey:key];
    NSString *expectedData = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedData, plainData);
}

- (void)testRealPayloadDecryption {
    NSString *cipherText = @"WTn6Ww9s7KCwu3QUPVe05stH01hy4easqZeR71E7tXKIuEOMWxuara26u3VHACpRGHHxO3SSn+1WbCLRCwI6UCxbUkYl5eWN1TVpQ7a4FvDDkbhH7fSZz/DjENLo9Ap5w/EQ2PyrQt00fkxjf2HW/W2r/SI3GRL/KKu7rCRIjcEgr3RAsqTrDILOhx2ASo99YCSpzETlILqOF7p4bDGzwy5L8AeQcSgDIFqtvhzL6gbud2A90KpRIb5b+ftbf+RCRkW1NSEC/Vb+0MHyFNGJCnSOgz9t3cn/kuF+uQgozsAkTE+PmFSrBvtPag5AKQAgM44E";
    NSData *key = [PPOTString dataWithHexString:@"9b30e222b129c989547f1a6ab6022e2bd191a0217f2efcbf891f3eb07990582c"];
    NSString *message = @"{\"payment_code_type\":\"authcode\",\"payment_code\":\"XXXXX\",\"timestamp\":\"2015-01-16T19:20:30.45+01:00\",\"expires_in\":900,\"scope\":\"\",\"display_name\":\"mockDisplayName\",\"email\":\"mockemailaddress@mock.com\"}";

    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:cipherText options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *plainData = [PPOTEncryptionHelper decryptAESCTRData:cipherData encryptionKey:key];
    // decode base64
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    XCTAssertTrue(plainString);
    XCTAssertEqualObjects(plainData, [message dataUsingEncoding:NSUTF8StringEncoding]);
}


- (void)testPublicKeyImport {

    // openssl req -x509 -out public_key2.crt -outform DER -new -newkey rsa:2048 -keyout private_key2.pem -keyform DER

    NSString *cert = @"MIIDOzCCAiOgAwIBAgIJAMlvCS4UtR7PMA0GCSqGSIb3DQEBBQUAMDQxCzAJBgNVBAYTAlVTMREwDwYDVQQIDAhJbGxpbm9pczESMBAGA1UECgwJQnJhaW50cmVlMB4XDTE1MDMyMDAxMTcyMVoXDTE2MDMxOTAxMTcyMVowNDELMAkGA1UEBhMCVVMxETAPBgNVBAgMCElsbGlub2lzMRIwEAYDVQQKDAlCcmFpbnRyZWUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDfCRhOGeMj4ci5Bbbs/x0G+PkbeL7iGEsX5UWQeA8oCWU8jpipFTC271Q0f5BQzXCN8L4LnwGvtm2cgAEivSBODo7XHsmxrFjKdQx1S7FIuFRKO18Uf8rIGmZHiJfhCbUEGilpwMt7hUMjjv2XDufPCMrJ8Yn2y/yDi5nhs7UsFhROm9oI2PyiJX01yR2ag8cPBb5Ahlwmj1yMWmSuHVnUN8T0rjIXyrBhxTAk3omQkQdHKj2w8afdrAcNUGi4yU/a5/pmb8tZpAa73OZVdOEQepJAAIRWXeS2BdKTkhfRJc7WEIlbi+9a2OdtM3OkIs+rZE7+WVT8XQoiLxpUd/wNAgMBAAGjUDBOMB0GA1UdDgQWBBQhbJ8DtuKFhGTsrvZ41Vw5jYbmazAfBgNVHSMEGDAWgBQhbJ8DtuKFhGTsrvZ41Vw5jYbmazAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQARg2wjhJanhKu1bw63+Xfj25OUa02jK+i4vhkWeuCGd5/kxA1dZMjBfSMxh484xBpaqRIOHvZmRpKcxCgci8xRbbJiaXrb1vIePTTi4lfU6cpfsnjMFCHDk8E/0AxIfOpQ0BSJY35WqB45xaIWBAY8lQ2pNfiPyK4kzajSOg+kbEKLmA0udYy8tsydt+88+R88rYKt4qDBo+Z5zgJ2fZvbAp99cBASHqMCoUoPb96YWEhaWhjArVGzgevpopKA9aOAFdndPKLbe6y29bbfLfQqat0B1fVmutCIHGIXtsPHQDe/cXJtoJk7HmD08++C9YvjxlSi8jxLb5nIA0QGI0yj";

    NSData *certData = [[NSData alloc] initWithBase64EncodedString:cert options:NSDataBase64DecodingIgnoreUnknownCharacters];

    NSString *plainText = @"hello";
    NSData *cipherText = [PPOTEncryptionHelper encryptRSAData:[plainText dataUsingEncoding:NSUTF8StringEncoding] certificate:certData];
    XCTAssertTrue(cipherText);
    NSString *base64 = [cipherText base64EncodedStringWithOptions:0];
    XCTAssertTrue(base64);
}


- (void)testPublicKeyEncryption {

    // openssl req -x509 -out public_key2.crt -outform DER -new -newkey rsa:2048 -keyout private_key2.pem -keyform DER

    NSString *cert = @"MIIDOzCCAiOgAwIBAgIJAMlvCS4UtR7PMA0GCSqGSIb3DQEBBQUAMDQxCzAJBgNVBAYTAlVTMREwDwYDVQQIDAhJbGxpbm9pczESMBAGA1UECgwJQnJhaW50cmVlMB4XDTE1MDMyMDAxMTcyMVoXDTE2MDMxOTAxMTcyMVowNDELMAkGA1UEBhMCVVMxETAPBgNVBAgMCElsbGlub2lzMRIwEAYDVQQKDAlCcmFpbnRyZWUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDfCRhOGeMj4ci5Bbbs/x0G+PkbeL7iGEsX5UWQeA8oCWU8jpipFTC271Q0f5BQzXCN8L4LnwGvtm2cgAEivSBODo7XHsmxrFjKdQx1S7FIuFRKO18Uf8rIGmZHiJfhCbUEGilpwMt7hUMjjv2XDufPCMrJ8Yn2y/yDi5nhs7UsFhROm9oI2PyiJX01yR2ag8cPBb5Ahlwmj1yMWmSuHVnUN8T0rjIXyrBhxTAk3omQkQdHKj2w8afdrAcNUGi4yU/a5/pmb8tZpAa73OZVdOEQepJAAIRWXeS2BdKTkhfRJc7WEIlbi+9a2OdtM3OkIs+rZE7+WVT8XQoiLxpUd/wNAgMBAAGjUDBOMB0GA1UdDgQWBBQhbJ8DtuKFhGTsrvZ41Vw5jYbmazAfBgNVHSMEGDAWgBQhbJ8DtuKFhGTsrvZ41Vw5jYbmazAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQARg2wjhJanhKu1bw63+Xfj25OUa02jK+i4vhkWeuCGd5/kxA1dZMjBfSMxh484xBpaqRIOHvZmRpKcxCgci8xRbbJiaXrb1vIePTTi4lfU6cpfsnjMFCHDk8E/0AxIfOpQ0BSJY35WqB45xaIWBAY8lQ2pNfiPyK4kzajSOg+kbEKLmA0udYy8tsydt+88+R88rYKt4qDBo+Z5zgJ2fZvbAp99cBASHqMCoUoPb96YWEhaWhjArVGzgevpopKA9aOAFdndPKLbe6y29bbfLfQqat0B1fVmutCIHGIXtsPHQDe/cXJtoJk7HmD08++C9YvjxlSi8jxLb5nIA0QGI0yj";

    NSData *certData = [[NSData alloc] initWithBase64EncodedString:cert options:NSDataBase64DecodingIgnoreUnknownCharacters];

    NSString *expectedCipher = @"ZgzjmDx5iD6ogzpiIB9bl2C08pscYQ+8gV8VbRbo2kZiNYj4WBh4rmMWnsADVpXj1JS0xq9HmuQhomm5KUewfEZRTNdk09hI1hWtU+cPucd4gwI7mmqzNUFbfPSMPtWTB2yFSDIiJ1K7XN0C1d5NnfbsI0rxUSxCpgP7S+ckEaWH4uqzV9NFIsplmj+4yBQokngk7j5fn9QcsSylKCBq7rp3Z1Wg/qA5tVPj9osZYwr29kot6onDtajJkl/7ZYxuRrQkqXi5QY2CPvN8A8WpEaMwy0EwZUAB7RZjBAHlKxDZXNRjgfzT+vpnwF+gzebP+k4H44/1wGecSuGYrU+l9Q==";

    NSString *plainText = @"{\"sym_key\": \"9a51aed0da8fb363933efc0f739df5dfbcba34b2e1ea8337f6d5dc1cbd61ced4\", \"some\": \"other_stuff\"}";
    NSData *cipherText = [PPOTEncryptionHelper encryptRSAData:[plainText dataUsingEncoding:NSUTF8StringEncoding] certificate:certData];
    XCTAssertTrue(cipherText);
    NSString *base64 = [cipherText base64EncodedStringWithOptions:0];
    XCTAssertTrue(base64);
    XCTAssertNotEqualObjects(base64, expectedCipher);
}

- (void)testAESCTREncryptionDecryption {
    NSString *plainData = @"Trust me i am an Engineer !";
    NSData *key = [[self class] randomData:32];
    NSData *cipherData = [PPOTEncryptionHelper encryptAESCTRData:[plainData dataUsingEncoding:NSUTF8StringEncoding] encryptionKey:key];
    XCTAssertNotEqualObjects([plainData dataUsingEncoding:NSUTF8StringEncoding], cipherData, @"data shouldn't match");

    NSData *outData = [PPOTEncryptionHelper decryptAESCTRData:cipherData encryptionKey:key];
    NSString *expectedData = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedData, plainData, @"data should match");
}


- (void)testPythonCTRDecryption {
    NSData *cipherText = [[NSData alloc] initWithBase64EncodedString:@"O4ibtOnGreHg1UGcJen7OFOlT/qdBo/3h8Gvc1Jibgj31UGbH+G3ottYCuwHeyJXYX5ubtr8O1SXAoy3X4IEq6o1oPFMJRP8/D5PI0qhexBTXsEEJvuRDlEV/Rcl" options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *key = [PPOTString dataWithHexString:@"dc6d0e61c0a3cd187dd0e41f455effdac77c23c95c2cfcb81993916ab19c0e09"];
    NSData *outData = [PPOTEncryptionHelper decryptAESCTRData:cipherText encryptionKey:key];
    NSString *message = @"A really secret message. Not for prying eyes.";
    XCTAssertEqualObjects([message dataUsingEncoding:NSUTF8StringEncoding], outData, @"message should be the same");
}

@end
