//
//  Crypto.h
//  Utilities
//
//  Created by Fredrik Sjöberg on 2017-07-28.
//  Copyright © 2017 emp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Crypto)

/// Encrypts `Self`
///
/// - parameter key: Raw key material
/// - parameter iv: Initialization vector
/// - parameter error: NSError
/// - returns: `Self` encrypted
- (NSData *)AES256EncryptedUsingKey:(id)key iv:(NSString *)iv error:(NSError **)error;

/// Decrypts `Self`
///
/// - parameter key: Raw key material
/// - parameter iv: Initialization vector
/// - parameter error: NSError
/// - returns: `Self` decrypted
- (NSData *)AES256DecryptedUsingKey:(id)key iv:(NSString *)iv error:(NSError **)error;

/// Returns `Self` as `sha256` hash
- (NSData *) SHA256Hash;
@end
