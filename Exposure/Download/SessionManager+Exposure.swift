//
//  SessionManager+Exposure.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Download

extension SessionManager {
    /// Create an `ExposureDownloadTask` by requesting a `PlaybackEntitlement` supplied through exposure.
    ///
    /// If the requested content is *FairPlay* protected, the appropriate `DownloadExposureFairplayRequester` will be created. Configuration will be taken from the `PlaybackEntitlement` response.
    ///
    /// - parameter assetId: A unique identifier for the asset
    /// - parameter environment: `Environment` to use when making the request
    /// - parameter sessionToken: `SessionToken` identifying the user making the request
    /// - returns: `ExposureDownloadTask`
    public func download(assetId: String, environment: Environment, sessionToken: SessionToken) -> ExposureDownloadTask {
        return ExposureDownloadTask(assetId: assetId,
                                    environment: environment,
                                    sessionToken: sessionToken,
                                    sessionManager: self)
    }
}

// MARK: - OfflineMediaAsset
extension SessionManager {
    public func offline(assetId: String) -> OfflineMediaAsset? {
        return offlineAssets()
            .filter{ $0.assetId == assetId }
            .first
    }
    
    public func offlineAssets() -> [OfflineMediaAsset] {
        guard let localMedia = localMediaRecords else { return [] }
        return localMedia.map{ resolve(mediaRecord: $0) }
    }
    
    public func delete(media: OfflineMediaAsset) {
        remove(localRecordId: media.assetId)
        do {
            try media.fairplayRequester.deletePersistedContentKey(for: media.assetId)
            if let url = media.urlAsset?.url {
                try FileManager.default.removeItem(at: url)
            }
            print("✅ SessionManager+Exposure. Cleaned up local media")
        }
        catch {
            print("🚨 SessionManager+Exposure. Failed to clean local media: ",error.localizedDescription)
        }
    }
    
    public func delete(assetId: String) {
        guard let media = offline(assetId: assetId) else { return }
        delete(media: media)
    }
    
    internal func save(assetId: String, entitlement: PlaybackEntitlement, url: URL?) {
        do {
            if let currentAsset = offline(assetId: assetId) {
                print("⚠️ There is another record for an offline asset with id: \(assetId). This data will be overwritten. The location of any downloaded media or content keys will be lost!")
            }
            
            let record = try LocalMediaRecord(assetId: assetId, entitlement: entitlement, completedAt: url)
            save(localRecord: record)
        }
        catch {
            print("🚨 Unable to bookmark local media record \(assetId): ",error.localizedDescription)
        }
    }
}

// MARK: - LocalMediaRecord
extension SessionManager {
    fileprivate var localMediaRecords: [LocalMediaRecord]? {
        do {
            let logFile = try logFileURL()
            
            if !FileManager.default.fileExists(atPath: logFile.path) {
                return []
            }
            let data = try Data(contentsOf: logFile)
            
            let localMedia = try JSONDecoder().decode([LocalMediaRecord].self, from: data)
            
            localMedia.forEach{ print("📎 Local media id: \($0.assetId)") }
            return localMedia
        }
        catch {
            print("localMediaLog failed",error.localizedDescription)
            return nil
        }
    }
    
    fileprivate func resolve(mediaRecord: LocalMediaRecord) -> OfflineMediaAsset {
        var bookmarkDataIsStale = false
        guard let urlBookmark = mediaRecord.urlBookmark else {
            return OfflineMediaAsset(assetId: mediaRecord.assetId, entitlement: mediaRecord.entitlement, url: nil)
        }
        
        do {
            guard let url = try URL(resolvingBookmarkData: urlBookmark, bookmarkDataIsStale: &bookmarkDataIsStale) else {
                return OfflineMediaAsset(assetId: mediaRecord.assetId, entitlement: mediaRecord.entitlement, url: nil)
                
            }
            
            guard !bookmarkDataIsStale else {
                return OfflineMediaAsset(assetId: mediaRecord.assetId, entitlement: mediaRecord.entitlement, url: nil)
            }
            
            return OfflineMediaAsset(assetId: mediaRecord.assetId, entitlement: mediaRecord.entitlement, url: url)
        }
        catch {
            return OfflineMediaAsset(assetId: mediaRecord.assetId, entitlement: mediaRecord.entitlement, url: nil)
        }
    }
}

// MARK: Directory
extension SessionManager {
    fileprivate var localMediaRecordsFile: String {
        return "localMediaRecords"
    }
    
    fileprivate func logFileURL() throws -> URL {
        return try baseDirectory().appendingPathComponent(localMediaRecordsFile)
    }
    
    /// This directory should be reserved for analytics data.
    ///
    /// - returns: `URL` to the base directory
    /// - throws: `FileManager` error
    internal func baseDirectory() throws -> URL {
        return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("emp")
            .appendingPathComponent("exposure")
            .appendingPathComponent("offlineMedia")
    }
}

// MARK: Save / Remove
extension SessionManager {
    
    /// This method will ensure `LocalMediaLog` has a unique list of downloads with respect to `assetId`
    fileprivate func save(localRecord: LocalMediaRecord) {
        let localMedia = localMediaRecords ?? []
        
        var filteredLog = localMedia.filter{ $0.assetId != localRecord.assetId }
        
        filteredLog.append(localRecord)
        save(mediaLog: filteredLog)
        print("✅ Saved bookmark for local media record \(localRecord.assetId): ")
    }
    
    fileprivate func save(mediaLog: [LocalMediaRecord]) {
        do {
            let logURL = try baseDirectory()
            
            let data = try JSONEncoder().encode(mediaLog)
            try data.persist(as: localMediaRecordsFile, at: logURL)
        }
        catch {
            print("save(mediaLog:) failed",error.localizedDescription)
        }
    }
    
    internal func remove(localRecordId: String) {
        guard let localMedia = localMediaRecords else { return }
        
        /// Update and save new log
        let newLog = localMedia.filter{ $0.assetId != localRecordId }
        save(mediaLog: newLog)
    }
}
