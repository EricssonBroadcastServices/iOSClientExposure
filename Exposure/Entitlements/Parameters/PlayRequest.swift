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
    public typealias DRM = PlayRequest.DRM
    public typealias Format = PlayRequest.Format
    
    /// Requested `DRM`
    public var drm: DRM {
        return playRequest.drm
    }
    
    /// Specifies the `DRM` to request
    ///
    /// Please note that playback may not be supported for all DRM formats. For more information please consult `Player` documentation.
    ///
    /// - parameter value: selected `DRM`
    /// - returns: `Self`
    public func use(drm value: DRM) -> Self {
        var old = self
        old.playRequest = PlayRequest(drm: value, format: format)
        return old
    }
    
    /// Requested `Format`
    public var format: Format {
        return playRequest.format
    }
    
    /// Specifies the `Format` to request
    ///
    /// Please note that playback may not be supported for all formats. For more information please consult `Player` documentation.
    ///
    /// - parameter value: selected `Format`
    /// - returns: `Self`
    public func use(format value: Format) -> Self {
        var old = self
        old.playRequest = PlayRequest(drm: drm, format: value)
        return old
    }
}

/// Used internally to configure the `DRM` request.
public struct PlayRequest: Serializable {
    internal let drm: DRM
    internal let format: Format
    
    internal init(drm: DRM = .fairplay, format: Format = .hls) {
        self.drm = drm
        self.format = format
    }
    
    /// The requested DRM. The playToken will be adapted according to this parameter.
    ///
    /// Please note that playback may not be supported for all DRM formats. For more information please consult `Player` documentation.
    public enum DRM: String {
        case playready = "PLAYREADY"
        case edrm = "EDRM"
        case edrmFairplay = "EDRM_FAIRPLAY"
        case cenc = "CENC"
        case unencrypted = "UNENCRYPTED"
        case fairplay = "FAIRPLAY"
    }
    
    /// The requested format. The server will make sure that the asset is available in this format.
    ///
    /// Please note that playback may not be supported for all formats. For more information please consult `Player` documentation.
    public enum Format: String {
        case dash = "DASH"
        case smoothstreaming = "SMOOTHSTREAMING"
        case hls = "HLS"
        case mp4 = "MP4"
        case syndicated = "SYNDICATED"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(drm.rawValue, forKey: .drm)
        try container.encode(format.rawValue, forKey: .format)
    }
}

extension PlayRequest {
    public func toJSON() -> [String: Any] {
        return [
            CodingKeys.drm.rawValue: drm.rawValue,
            CodingKeys.format.rawValue: format.rawValue
            ]
    }
    
    /// Keys used to specify `json` body for the request.
    internal enum CodingKeys: String, CodingKey {
        case drm
        case format
    }
}
