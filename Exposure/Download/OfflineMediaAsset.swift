//
//  OfflineMediaAsset.swift
//  iOSReferenceApp
//
//  Created by Fredrik Sjöberg on 2017-10-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Download
import AVFoundation

public struct OfflineMediaAsset {
    internal init(assetId: String, entitlement: PlaybackEntitlement, url: URL?) {
        self.assetId = assetId
        self.entitlement = entitlement
        self.fairplayRequester = ExposureDownloadFairplayRequester(entitlement: entitlement, assetId: assetId)
        if let url = url {
            self.urlAsset = AVURLAsset(url: url)
        }
        else {
            self.urlAsset = nil
        }
    }
    
    public let assetId: String
    public let entitlement: PlaybackEntitlement
    public let urlAsset: AVURLAsset?
    internal let fairplayRequester: ExposureDownloadFairplayRequester
 
    
    public func state(callback: @escaping (State) -> Void) {
        guard let urlAsset = urlAsset else {
            callback(.notPlayable)
            return
        }
        
        if #available(iOS 10.0, *) {
            if let assetCache = urlAsset.assetCache, assetCache.isPlayableOffline {
                callback(.completed)
                return
            }
        }
        
        urlAsset.loadValuesAsynchronously(forKeys: ["playable"]) {
            DispatchQueue.main.async {
                
                // Check for any issues preparing the loaded values
                var error: NSError?
                if urlAsset.statusOfValue(forKey: "playable", error: &error) == .loaded {
                    if urlAsset.isPlayable {
                        callback(.completed)
                    }
                    else {
                        callback(.notPlayable)
                    }
                }
                else {
                    callback(.notPlayable)
                }
            }
        }
    }
    
    public enum State {
        case completed
        case notPlayable
    }
}


internal struct LocalMediaRecord: Codable {
    /// URL encoded as bookmark data
    internal var urlBookmark: Data? {
        switch downloadState {
        case .completed(urlBookmark: let data): return data
        case .inProgress: return nil
        }
    }
    
    /// State
    internal let downloadState: DownloadState
    
    /// Id for the asset at `bookmarkURL`
    internal let assetId: String
    
    /// Related entitlement
    internal let entitlement: PlaybackEntitlement
    
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        assetId = try container.decode(String.self, forKey: .assetId)
        entitlement = try container.decode(PlaybackEntitlement.self, forKey: .entitlement)
        
        if let data = try container.decodeIfPresent(Data.self, forKey: .downloadState) {
            downloadState = .completed(urlBookmark: data)
        }
        else {
            downloadState = .inProgress
        }
    }
    
    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(assetId, forKey: .assetId)
        try container.encode(entitlement, forKey: .entitlement)
        
        switch downloadState {
        case .completed(urlBookmark: let data): try container.encode(data, forKey: .downloadState)
        default: return
        }
    }
    
    internal init(assetId: String, entitlement: PlaybackEntitlement, completedAt location: URL?) throws {
        self.assetId = assetId
        self.entitlement = entitlement
        
        if let data = try location?.bookmarkData() {
            downloadState = .completed(urlBookmark: data)
        }
        else {
            downloadState = .inProgress
        }
    }
    
    internal enum DownloadState {
        
        /// URL encoded as bookmark data
        case completed(urlBookmark: Data)
        
        /// No destination might have been set
        case inProgress
    }
    
    internal enum CodingKeys: String, CodingKey {
        case downloadState
        case assetId
        case entitlement
    }
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
}
