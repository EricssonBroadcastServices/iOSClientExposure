//
//  Download+Exposure.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import AVFoundation
import Download
import Player

extension Download.SessionManager {
    /// Create a `DownloadTask` for an asset as specified by a `PlaybackEntitlement` supplied through exposure.
    ///
    /// If the requested content is *FairPlay* protected, the appropriate `OfflineFairplayRequester` will be created. Configuration will be taken from the supplied `entitlement`.
    ///
    /// - parameter entitlement: *Exposure* provided entitlement
    /// - parameter assetId: A unique identifier for the entitlement. This is most likely *EMP asset id*
    /// - throws: `DownloadError`
    @available(iOS 10.0, *)
    public func download(entitlement: PlaybackEntitlement, assetId: String) throws -> DownloadTask {
        let fairplayRequester = ExposureDownloadFairplayRequester(entitlement: entitlement, assetId: assetId)
        
        guard let url = URL(string: entitlement.mediaLocator) else {
            // TODO: Init DownloadTask with error instead of throwing
            throw DownloadError.invalidMediaUrl(path: entitlement.mediaLocator)
        }
        
        // Store an initial locator to indicate download is underway
        save(assetId: assetId, entitlement: entitlement, url: nil)
        
        // TODO: Artwork should probably be retrieved from *Exposure*
        return download(mediaLocator: url, assetId: assetId, artwork: nil, using: fairplayRequester)
    }
    
    /// Create a `DownloadTask` for an asset as specified by a `PlaybackEntitlement` supplied through exposure.
    ///
    /// If the requested content is *FairPlay* protected, the appropriate `OfflineFairplayRequester` will be created. Configuration will be taken from the supplied `entitlement`.
    ///
    /// - parameter entitlement: *Exposure* provided entitlement
    /// - parameter assetId: A unique identifier for the entitlement. This is most likely *EMP asset id*
    /// - parameter url: Destination URL for the download.
    /// - throws: `DownloadError`
    @available(iOS, introduced: 9.0, deprecated: 10.0)
    public func download(entitlement: PlaybackEntitlement, assetId: String, to url: URL) throws -> DownloadTask {
        let fairplayRequester = ExposureDownloadFairplayRequester(entitlement: entitlement, assetId: assetId)
        
        guard let url = URL(string: entitlement.mediaLocator) else {
            // TODO: Init DownloadTask with error instead of throwing
            throw DownloadError.invalidMediaUrl(path: entitlement.mediaLocator)
        }
        // Store an initial locator to indicate download is underway
        save(assetId: assetId, entitlement: entitlement, url: nil)
        
        return download(mediaLocator: url, assetId: assetId, to: url, using: fairplayRequester)
    }
}

extension SessionManager {
    @available(iOS 10.0, *)
    public func download(assetId: String, callback: @escaping (PlaybackEntitlement) -> Void) {
        
    }
    
//    @available(iOS, introduced: 9.0, deprecated: 10.0)
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
    fileprivate func baseDirectory() throws -> URL {
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


extension Player {
    public func offline(entitlement: PlaybackEntitlement, assetId: String, urlAsset: AVURLAsset) {
        let fairplayRequester = ExposureDownloadFairplayRequester(entitlement: entitlement, assetId: assetId)
        
        stream(urlAsset: urlAsset, using: fairplayRequester, playSessionId: nil)
    }
}

