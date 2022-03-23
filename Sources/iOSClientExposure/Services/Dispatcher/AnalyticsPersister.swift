//
//  AnalyticsPersister.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-08-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

internal enum PersisterError: Error {
    case failedToPersistWithMalformattedSessionToken
    case failedToPersistMissingAccountId
}

/// Responsible for managing persistence of analytics data.
/// 
/// All data persisted on disk is encrypted.
public struct AnalyticsPersister: StorageProvider {
    public init() { }
    
    /// This directory should be reserved for analytics data.
    ///
    /// - returns: `URL` to the base directory
    /// - throws: `FileManager` error
    fileprivate func baseDirectory() throws -> URL {
        return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("emp")
            .appendingPathComponent("analytics")
    }
    
    /// Each storage path is specific for *businessUnit*, *customer* and *accountId*.
    ///
    /// - returns: `URL` to the requested storage path
    /// - throws: `FileManager` error
    fileprivate func storageDirectory(businessUnit: String, customer: String, accountId: String) throws -> URL {
        return try baseDirectory()
            .appendingPathComponent(customer)
            .appendingPathComponent(businessUnit)
            .appendingPathComponent(accountId)
    }
    
    /// Persists the related analytics batch.
    ///
    /// For more information regarding error handling in relation to `CCCryptorStatus`, please *CommonCrypto/CommonCryptoError.h*
    ///
    /// - parameter analytics: Batch to persist
    /// - throws: `FileManager` error. `CCCryptorStatus` related `Error`.
    public func persist(analytics: AnalyticsBatch) throws {
        // Data protection
        // 1. Convert AnalyticsBatch to data
        let data = try JSONSerialization.data(withJSONObject: analytics.persistencePayload, options: .prettyPrinted)
        
        // 2. Encrypt the data (Currently in Utilities)
        let encryptedData = try encrypt(data: data)
        
        // 3. Generate filename
        let filename = "\(Date().millisecondsSince1970)"
        
        // 4. Generate path
        guard let accountId = analytics.sessionToken.accountId else {
            /// TODO: Log this for debug purposes?
            throw PersisterError.failedToPersistMissingAccountId
        }
        
        let directoryUrl = try storageDirectory(businessUnit: analytics.businessUnit,
                                                customer: analytics.customer,
                                                accountId: accountId)
        
        // 5. Create directory if needed
        try encryptedData?.persist(as: filename, at: directoryUrl)
    }
    
    /// Retrieves *all* perviously persisted analytics data related the specified `accountId`, `customer` and `businessUnit`.
    ///
    /// For more information regarding error handling in relation to `CCCryptorStatus`, please *CommonCrypto/CommonCryptoError.h*
    /// 
    /// - parameter accountId: account for which to retrieve data
    /// - parameter businessUnit: related to `accountId`
    /// - parameter customer: relted to `accountId`
    /// - parameter extractFromDisk: specifying `true` will remove any `PersistedAnalytics` from disk, keeping them only in memory.
    /// - returns: Array of `PersistedAnalytics`
    /// - throws: `FileManager` error. `CCCryptorStatus` related `Error`.
    internal func analytics(accountId: String, businessUnit: String, customer: String, extractFromDisk: Bool = false) throws -> [PersistedAnalytics] {
        let directoryUrl = try storageDirectory(businessUnit: businessUnit,
                                                customer: customer,
                                                accountId: accountId)
        
        return try files(at: directoryUrl, preloadingKeys: [.isDirectoryKey, .isRegularFileKey]) { url, enumerator in
            
            let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey, .isRegularFileKey])
            
            if let isDirectory = resourceValues.isDirectory, let isFile = resourceValues.isRegularFile {
                return !isDirectory && isFile
            }
            return false
            }
            .flatMap{ url -> PersistedAnalytics? in
                do {
                    // 1. Fetch the data
                    let data = try Data(contentsOf: url)
                    
                    // 2. Decrypt the data
                    guard let decryptedData = try decrypt(data: data) else { return nil }
                    if let json = try JSONSerialization.jsonObject(with: decryptedData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] , let batch = AnalyticsBatch(persistencePayload: json) {
                        let persistedAnalytics = PersistedAnalytics(url: url, batch: batch)
                        if extractFromDisk {
                            do {
                                try self.delete(persistedAnalytics: persistedAnalytics)
                                return persistedAnalytics
                            }
                            catch {
                                return nil
                            }
                        }
                        else {
                            return persistedAnalytics
                        }
                    }
                    else {
                        return nil
                    }
                }
                catch {
                    return nil
                }
        }
    }
    
    /// Removes the specified analytics batch from disk
    ///
    /// - parameter persistedAnalytics: persisted analytics to delete.
    /// - throws: `FileManager` error.
    internal func delete(persistedAnalytics: PersistedAnalytics) throws {
        try removeFile(at: persistedAnalytics.url)
    }
    
    /// Will delete any analytics events stored in the base analytics directory older than `timestamp`
    ///
    /// - parameter timestamp: The timestamp in `unix epoch time` in milliseconds
    /// - throws: Filemanager errors
    internal func clearAll(olderThan timestamp: Int64) throws {
        let directoryUrl = try baseDirectory()
        
        try allFiles(at: directoryUrl,
                     olderThan: timestamp)
            .forEach{ try removeFile(at: $0) }
    }
}

extension AnalyticsPersister: EncryptionProvider {
    internal static var password: Data? {
        return "dsp_2017_B72WhPNQe8KLj6edk4WN4g32".sha256Hash
    }
    
    internal static let iv = "dsp_2017_WRApMdC16"
}
