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
    internal init(assetId: String, entitlement: PlaybackEntitlement?, url: URL?) {
        self.assetId = assetId
        self.entitlement = entitlement
        
        if let entitlement = entitlement {
            self.fairplayRequester = ExposureDownloadFairplayRequester(entitlement: entitlement, assetId: assetId)
        }
        else {
            self.fairplayRequester = nil
        }
        
        if let url = url {
            self.urlAsset = AVURLAsset(url: url)
        }
        else {
            self.urlAsset = nil
        }
    }
    
    public let assetId: String
    public let entitlement: PlaybackEntitlement?
    public let urlAsset: AVURLAsset?
    internal let fairplayRequester: ExposureDownloadFairplayRequester?
 
    
    public func state(callback: @escaping (State) -> Void) {
        guard let entitlement = entitlement else {
            callback(.notPlayable(entitlement: self.entitlement, url: self.urlAsset?.url))
            return
        }
        
        guard let urlAsset = urlAsset else {
            callback(.notPlayable(entitlement: entitlement, url: self.urlAsset?.url))
            return
        }
        
        
        if #available(iOS 10.0, *) {
            if let assetCache = urlAsset.assetCache, assetCache.isPlayableOffline {
                callback(.completed(entitlement: entitlement, url: urlAsset.url))
                return
            }
        }
        
        urlAsset.loadValuesAsynchronously(forKeys: ["playable"]) { [entitlement, urlAsset] in
            DispatchQueue.main.async {
                
                // Check for any issues preparing the loaded values
                var error: NSError?
                if urlAsset.statusOfValue(forKey: "playable", error: &error) == .loaded {
                    if urlAsset.isPlayable {
                        callback(.completed(entitlement: entitlement, url: urlAsset.url))
                    }
                    else {
                        callback(.notPlayable(entitlement: entitlement, url: urlAsset.url))
                    }
                }
                else {
                    callback(.notPlayable(entitlement: entitlement, url: urlAsset.url))
                }
            }
        }
    }
    
    public enum State {
        case completed(entitlement: PlaybackEntitlement, url: URL)
        case notPlayable(entitlement: PlaybackEntitlement?, url: URL?)
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
