//
//  PPOTEncryptionHelper.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTEncryptionHelper.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonHMAC.h>
#import "PPOTMacros.h"

@implementation PPOTEncryptionHelper

+ (BOOL)compareSignatureData:(NSData *)data1 withData:(NSData *)data2 {
    if (data1.length != data2.length) {
        return NO;
    }

    NSInteger result = 0;
    uint8_t const *data1Ptr = [data1 bytes];
    uint8_t const *data2Ptr = [data2 bytes];
    for (unsigned int i = 0; i < data1.length; i++) {
        result |= data1Ptr[i] ^ data2Ptr[i];
    }
    return (result == 0);
}

+ (NSData *)randomData:(NSUInteger)length {
    NSMutableData *randomKey = [NSMutableData dataWithLength:length];
    int error = SecRandomCopyBytes(kSecRandomDefault, length, [randomKey mutableBytes]);
    return (error == 0) ? randomKey : nil;
}

+ (NSData *)generate256BitKey {
    return [PPOTEncryptionHelper randomData:kCCKeySizeAES256];
}

// HMACSHA256
+ (NSData *)dataDigest:(NSData *)data encryptionKey:(NSData *)encryptionKey {
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, encryptionKey.bytes, encryptionKey.length, data.bytes, data.length, hash.mutableBytes);
    return hash;
}

#pragma mark - AES CTR
+ (NSData *)encryptAESCTRData:(NSData *)plainData encryptionKey:(NSData *)key {
    if (key.length != kCCKeySizeAES256) {
        // wrong key
        PPSDKLog(@"encryptAESCTRData: Supplied key is not %@ bytes", @(kCCKeySizeAES256));
        return nil;
    }

    NSData *nonce = [PPOTEncryptionHelper randomData:kCCKeySizeAES128];
    NSData *encryptionKey = [key subdataWithRange:NSMakeRange(0, kCCKeySizeAES128)];
    NSData *digestKey = [key subdataWithRange:NSMakeRange(16, kCCKeySizeAES128)];

    // Init cryptor
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = CCCryptorCreateWithMode(kCCEncrypt,
                                                     kCCModeCTR,
                                                     kCCAlgorithmAES,
                                                     ccNoPadding,
                                                     [nonce bytes],
                                                     [encryptionKey bytes],
                                                     encryptionKey.length,
                                                     0,
                                                     0,
                                                     0,
                                                     kCCModeOptionCTR_BE,// deprecated and no longer used
                                                     &cryptor);
    if (status != kCCSuccess) {
        PPSDKLog(@"encryptAESCTRData: createWithMode error: %@", @(status));
        return nil;
    }


    size_t cipherDataSize = plainData.length + kCCKeySizeAES128 +1; // null terminator
    uint8_t *cipherData = malloc(cipherDataSize);
    memset(cipherData, 0, cipherDataSize);


    size_t dataMoved;
    // now re-use buffer to do decryption
    status = CCCryptorUpdate(cryptor, [plainData bytes], [plainData length], cipherData, cipherDataSize, &dataMoved);
    // note: there is no need to call CCCryptorFinal when no padding is used.
    CCCryptorRelease(cryptor);

    // add logging
    if (status != kCCSuccess) {
        PPSDKLog(@"encryptAESCTRData: encryption error: %@", @(status));
        free(cipherData);
        cipherData = NULL;
        return nil;
    }

    // concat nonce and cipher for signing
    NSData *encryptedBlob = [NSData dataWithBytes:cipherData length:dataMoved];
    free(cipherData);
    cipherData = NULL;
    NSMutableData *signData = [NSMutableData dataWithCapacity:encryptedBlob.length + nonce.length];
    [signData appendData:nonce];
    [signData appendData:encryptedBlob];

    // sign
    NSData *digest = [PPOTEncryptionHelper dataDigest:signData encryptionKey:digestKey];

    // construct encrypted payload = signature + nonce + encrypted blob
    NSMutableData *payload = [NSMutableData dataWithCapacity:signData.length + digest.length];
    [payload appendData:digest];
    [payload appendData:signData];

    return payload;
}

+ (NSData *)decryptAESCTRData:(NSData *)cipherData encryptionKey:(NSData *)key {
    if (key.length != kCCKeySizeAES256) {
        // wrong key
        PPSDKLog(@"decryptAESCTRData: Supplied key is not %@ bytes", @(kCCKeySizeAES256));
        return nil;
    }

    if (cipherData.length < CC_SHA256_DIGEST_LENGTH + kCCKeySizeAES128) {
        // we won't be able to decrypt, data sample too small
        PPSDKLog(@"decryptAESCTRData: data is too small to decrypt");
        return nil;
    }

    NSData *resultData = nil;

    NSData *encryptionKey = [key subdataWithRange:NSMakeRange(0, kCCKeySizeAES128)];
    NSData *digestKey = [key subdataWithRange:NSMakeRange(16, kCCKeySizeAES128)];

    NSData *signature = [cipherData subdataWithRange:NSMakeRange(0, CC_SHA256_DIGEST_LENGTH)];
    NSData *digest = [PPOTEncryptionHelper dataDigest:[cipherData subdataWithRange:NSMakeRange(CC_SHA256_DIGEST_LENGTH, cipherData.length-CC_SHA256_DIGEST_LENGTH)]
                                        encryptionKey:digestKey];


    if (![self compareSignatureData:signature withData:digest]) {
        PPSDKLog(@"decryptAESCTRData: signature doesn't match");
        return nil;
    }

    NSData *nonce = [cipherData subdataWithRange:NSMakeRange(CC_SHA256_DIGEST_LENGTH, kCCKeySizeAES128)];

    // Init cryptor
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = CCCryptorCreateWithMode(kCCDecrypt,
                                                     kCCModeCTR,
                                                     kCCAlgorithmAES,
                                                     ccNoPadding,
                                                     [nonce bytes],
                                                     [encryptionKey bytes],
                                                     encryptionKey.length,
                                                     0,
                                                     0,
                                                     0,
                                                     kCCModeOptionCTR_BE,
                                                     &cryptor);
    if (status != kCCSuccess) {
        PPSDKLog(@"decryptAESCTRData: createWithMode error: %@", @(status));
        return nil;
    }

    uint8_t *plainText = malloc(cipherData.length); // that's big enough
    memset(plainText, 0, cipherData.length);

    const uint8_t *encryptionBlockPtr = [cipherData bytes] + CC_SHA256_DIGEST_LENGTH + kCCKeySizeAES128;   // adjust pointer
    size_t encryptionBlockSize = cipherData.length - CC_SHA256_DIGEST_LENGTH - kCCKeySizeAES128; // minus signature, minus nonce

    // now re-use buffer to do decryption
    size_t dataMoved;
    status = CCCryptorUpdate(cryptor, encryptionBlockPtr, encryptionBlockSize, plainText, cipherData.length, &dataMoved);
    // note: there is no need to call CCCryptorFinal when no padding is used.
    CCCryptorRelease(cryptor);

    if (status != kCCSuccess) {
        PPSDKLog(@"decryptAESCTRData: encryption error: %@", @(status));
        free(plainText);
        plainText = NULL;
        return nil;
    }
    resultData = [NSData dataWithBytes:plainText length:dataMoved];
    free(plainText);
    plainText = NULL;
    return resultData;
}


#pragma mark - AES Public Key

+ (SecKeyRef)createPublicKeyUsingCertificate:(NSData *)certificateData {
    SecCertificateRef certificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    if (certificate == NULL) {
        PPSDKLog(@"createPublicKeyUsingData: failed to create public key");
        return NULL;
    }
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trustRef = NULL;
    SecKeyRef keyRef = NULL;
    OSStatus status = SecTrustCreateWithCertificates(certificate, policy, &trustRef);
    if (status == errSecSuccess) {
        keyRef = SecTrustCopyPublicKey(trustRef);
    } else {
        PPSDKLog(@"createPublicKeyUsingData: create certificate failed with error %@", @(status));
    }
    CFRelease(trustRef);
    CFRelease(policy);
    CFRelease(certificate);

    return keyRef;
}

+ (NSData *)encryptRSAData:(NSData *)plainData certificate:(NSData *)certificate {
    if (![certificate length]) {
        PPSDKLog(@"encryptRSAData: no certificate provided");
        return nil;
    }

    SecKeyRef publicKeyRef = [self createPublicKeyUsingCertificate:certificate];
    if (!publicKeyRef) {
        // logging is done above
        return nil;
    }
    size_t keyBlockSize = SecKeyGetBlockSize(publicKeyRef);
    if (plainData.length > keyBlockSize) {
        PPSDKLog(@"encryptRSAData: data too big to encrypt");
        return nil;
    }
    size_t cipherTextLen = keyBlockSize;
    uint8_t *cipherText = malloc(keyBlockSize);
    memset(cipherText, 0, keyBlockSize);
    
    OSStatus status = SecKeyEncrypt(publicKeyRef, kSecPaddingOAEP, [plainData bytes], [plainData length], cipherText, &cipherTextLen);
    CFRelease(publicKeyRef);
    if (status != errSecSuccess) {
        PPSDKLog(@"encryptRSAData: encryption failed with error %@", @(status));
        free(cipherText);
        return nil;
    }

    NSData *resultData = [NSData dataWithBytes:cipherText length:cipherTextLen];
    free(cipherText);
    cipherText = NULL;
    return resultData;
}

@end
