//
//  Data+Extensions.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-07-28.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import CommonCrypto

enum CommonCryptoError: Swift.Error {
    case encryptionError(status: CCCryptorStatus)
    case decryptionError(status: CCCryptorStatus)
    case keyDerivationError(status: CCCryptorStatus)
}

extension Data {
    /// Convenience function for persisting a `Data` blob through `FileManager`.
    ///
    /// - parameter filename: Name of the file, including extension
    /// - parameter directoryUrl: `URL` to the storage directory
    /// - throws: `FileManager` related `Error` or `Data` related error in the *Cocoa Domain*
    internal func persist(as filename: String, at directoryUrl: URL) throws {
        if !FileManager.default.fileExists(atPath: directoryUrl.path) {
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
        }
        
        try self.write(to: directoryUrl.appendingPathComponent(filename))
    }
    
    internal func sha256Hash() -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &hash)
        }
        return Data(hash)
    }
}
