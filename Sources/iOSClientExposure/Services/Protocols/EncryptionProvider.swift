//
//  EncryptionProvider.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-07-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

/// Adopting this protocol enables some basic encryption functionality based on the AES256 algorithm.
internal protocol EncryptionProvider {
    /// Password used for encryption as a data blob
    static var password: Data? { get }
    
    /// Initialization vector
    static var iv: String { get }
}
extension EncryptionProvider {
    /// Encrypts the supplied `data` using an *AES256* algorithm.
    ///
    /// For more information regarding error handling in relation to `CCCryptorStatus`, please *CommonCrypto/CommonCryptoError.h*
    ///
    /// - parameter data: raw data to be encrypted,
    /// - returns: encrypted `Data`, or nil if `password` or `data` is missing.
    /// - throws: `CCCryptorStatus` related `Error`.
    internal func encrypt(data: Data?) throws -> Data? {
        guard let nsData = data else { return nil }
        guard let k = Self.password else { return nil }
        return AES(key: k, iv: AnalyticsPersister.iv)?.encrypt(data: nsData)
        // return nil
        /* guard let nsData = data as NSData? else { return nil }
        guard let k = Self.password else { return nil }
        return try nsData.aes256Encrypted(usingKey: k, iv: AnalyticsPersister.iv) */
        
    }
    
    /// Decrypts the supplied `data` using an *AES256* algorithm.
    ///
    /// For more information regarding error handling in relation to `CCCryptorStatus`, please *CommonCrypto/CommonCryptoError.h*
    ///
    /// - parameter data: encrypted data
    /// - returns: decrypted `Data`, or nil if `password` or `data` is missing.
    /// - throws: `CCCryptorStatus` related `Error`.
    internal func decrypt(data: Data?) throws -> Data? {
        guard let nsData = data else { return nil }
        guard let k = Self.password else { return nil }
       
        return AES(key: k, iv: AnalyticsPersister.iv)?.decrypt(data: nsData)
    }
}
