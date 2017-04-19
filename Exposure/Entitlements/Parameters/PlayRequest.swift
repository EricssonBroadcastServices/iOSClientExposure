//
//  PlayRequest.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct PlayRequest {
    public let drm: DRM
    public let format: Format
    
    public init(drm: DRM = .unencrypted, format: Format = .hls) {
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
    public func toJSON() -> JSON {
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
