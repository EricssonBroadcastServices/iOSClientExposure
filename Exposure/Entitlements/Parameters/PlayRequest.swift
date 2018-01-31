//
//  PlayRequest.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines a `DRM` request format used by *Exposure*.
public protocol DRMRequest {
    
    /// Request to apply.
    var playRequest: PlayRequest { get set }
}

extension DRMRequest {
    /// Requested *DRM*
    ///
    /// This is normaly `FairPlay`
    public var drm: String {
        return playRequest.drm
    }
    
    /// Specifies the `DRM` to request
    ///
    /// Please note that playback may not be supported for all DRM formats. For more information please consult `Player` documentation.
    ///
    /// Supported DRM
    ///     * "FAIRPLAY"
    ///     * "UNENCRYPTED"
    ///
    /// - parameter value: selected `DRM`
    /// - returns: `Self`
    public func use(drm value: String) -> Self {
        var old = self
        old.playRequest = PlayRequest(drm: value, format: format)
        return old
    }
    
    /// Requested `Format`
    public var format: String {
        return playRequest.format
    }
    
    /// Specifies the `Format` to request
    ///
    /// Please note that playback may not be supported for all formats. For more information please consult `Player` documentation.
    ///
    /// Supported Formats
    ///     * "HLS"
    ///
    /// - parameter value: selected `Format`
    /// - returns: `Self`
    public func use(format value: String) -> Self {
        var old = self
        old.playRequest = PlayRequest(drm: drm, format: value)
        return old
    }
}

/// Used internally to configure the `DRM` request.
public struct PlayRequest: Serializable {
    /// Supported DRM
    ///     * "FAIRPLAY"
    ///     * "UNENCRYPTED"
    public let drm: String
    
    /// Supported Formats
    ///     * "HLS"
    public let format: String
    
    public init(drm: String = "FAIRPLAY", format: String = "HLS") {
        self.drm = drm
        self.format = format
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(drm, forKey: .drm)
        try container.encode(format, forKey: .format)
    }
}

extension PlayRequest {
    public func toJSON() -> [String: Any] {
        return [
            CodingKeys.drm.rawValue: drm,
            CodingKeys.format.rawValue: format
            ]
    }
    
    /// Keys used to specify `json` body for the request.
    internal enum CodingKeys: String, CodingKey {
        case drm
        case format
    }
}
