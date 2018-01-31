//
//  Crypto.m
//  Utilities
//
//  Created by Fredrik Sjöberg on 2017-07-28.
//  Copyright © 2017 emp. All rights reserved.
//

#import "Crypto.h"
#import "NSData+CommonCrypto.h"

@implementation NSData (Crypto)
    
- (NSData *)AES256EncryptedUsingKey:(id)key iv:(NSString *)iv error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData *result = [self dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                   key:key
                                  initializationVector:iv
                                               options:kCCOptionPKCS7Padding
                                                 error:&status];
    if ( result != nil )
    return ( result );
    
    if ( error != NULL )
    *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}
    
- (NSData *)AES256DecryptedUsingKey:(id)key iv:(NSString *)iv error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData *result =[self decryptedDataUsingAlgorithm:kCCAlgorithmAES128
                                                  key:key
                                 initializationVector:iv
                                              options:kCCOptionPKCS7Padding
                                                error:&status];
    if ( result != nil )
    return ( result );
    
    if ( error != NULL )
    *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}
    
- (NSData *) SHA256Hash
{
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    (void) CC_SHA256( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA256_DIGEST_LENGTH] );
}

@end
