//
//  PlayRequest.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public protocol DRMRequest {
    var playRequest: PlayRequest { get set }
}

extension DRMRequest {
    public typealias DRM = PlayRequest.DRM
    public typealias Format = PlayRequest.Format
    
    // MARK: DRM
    public var drm: DRM {
        return playRequest.drm
    }
    
    public func use(drm value: DRM) -> Self {
        var old = self
        old.playRequest = PlayRequest(drm: value, format: format)
        return old
    }
    
    // MARK: Format
    public var format: Format {
        return playRequest.format
    }
    
    public func use(format value: Format) -> Self {
        var old = self
        old.playRequest = PlayRequest(drm: drm, format: value)
        return old
    }
}

public struct PlayRequest {
    internal let drm: DRM
    internal let format: Format
    
    internal init(drm: DRM = .fairplay, format: Format = .hls) {
        self.drm = drm
        self.format = format
    }
    
    /// The requested DRM. The token will be adapted according to this parameter.
    public enum DRM: String {
        case playready = "PLAYREADY"
        case edrm = "EDRM"
        case edrmFairplay = "EDRM_FAIRPLAY"
        case cenc = "CENC"
        case unencrypted = "UNENCRYPTED"
        case fairplay = "FAIRPLAY"
    }
    
    /// The requested format. The server will make sure that the asset is available in this format.
    public enum Format: String {
        case dash = "DASH"
        case smoothstreaming = "SMOOTHSTREAMING"
        case hls = "HLS"
        case mp4 = "MP4"
        case syndicated = "SYNDICATED"
    }
}

extension PlayRequest: JSONEncodable {
    public func toJSON() -> [String: Any] {
        return [
            JSONKeys.drm.rawValue: drm.rawValue,
            JSONKeys.format.rawValue: format.rawValue
            ]
    }
    
    internal enum JSONKeys: String {
        case drm = "drm"
        case format = "format"
    }
}
