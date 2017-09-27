//
//  Download+Exposure.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Download

/// *Exposure* specific implementation of the `OfflineFairplayRequester` protocol.
///
/// This class handles any *Exposure* related `DRM` validation with regards to *Fairplay*. It is designed to be *plug-and-play* and should require no configuration to use.
internal class ExposurePersistentFairplayRequester: NSObject, OfflineFairplayRequester {
    /// Entitlement related to this specific *Fairplay* request.
    internal let entitlement: PlaybackEntitlement
    
    init(entitlement: PlaybackEntitlement) {
        self.entitlement = entitlement
    }
}

extension Downloader {
    /// Create a `DownloadTask` for an asset as specified by a `PlaybackEntitlement` supplied through exposure.
    ///
    /// If the requested content is *FairPlay* protected, the appropriate `OfflineFairplayRequester` will be created. Configuration will be taken from the supplied `entitlement`.
    ///
    /// - parameter entitlement: *Exposure* provided entitlement
    @available(iOS 10.0, *)
    public static func download(entitlement: PlaybackEntitlement) throws -> DownloadTask {
        let fairplayRequester = ExposurePersistentFairplayRequester(entitlement: entitlement)
        
        return try download(mediaLocator: entitlement.mediaLocator, named: entitlement.mediaLocator, artwork: nil, using: fairplayRequester)
    }
    
    @available(iOS, introduced: 9.0, deprecated: 10.0)
    public static func download(entitlement: PlaybackEntitlement, to url: URL) throws -> DownloadTask {
        let fairplayRequester = ExposurePersistentFairplayRequester(entitlement: entitlement)
        
        return try download(mediaLocator: entitlement.mediaLocator, to: url, using: fairplayRequester)
    }
}
