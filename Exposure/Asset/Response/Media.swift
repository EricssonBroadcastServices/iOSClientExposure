//
//  Media.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Asset {
    public struct Media {
        public let mediaId: String? // The id of the media.,
        public let name: String? // The name of the media.,
        public let drm: String? // The DRM of the media.,
        public let format: String? // The streaming format of the media.,
        public let height: Int? // The height in pixels.,
        public let width: Int? // The width in pixels.,
        public let durationMillis: Int? // The duration of the media in milliseconds.,
        public let programId: String? // The id of the EPG program this media is for.,
        public let status: String? // The status of the media. "enabled" if playable.
        
        public init?(json: Any) {
            let actualJson = JSON(json)
            mediaId = actualJson[JSONKeys.mediaId.rawValue].string
            name = actualJson[JSONKeys.name.rawValue].string
            drm = actualJson[JSONKeys.drm.rawValue].string
            format = actualJson[JSONKeys.format.rawValue].string
            height = actualJson[JSONKeys.height.rawValue].int
            width = actualJson[JSONKeys.width.rawValue].int
            durationMillis = actualJson[JSONKeys.durationMillis.rawValue].int
            programId = actualJson[JSONKeys.programId.rawValue].string
            status = actualJson[JSONKeys.status.rawValue].string
            
            if mediaId == nil && name == nil && drm == nil && format == nil
                && height == nil && width == nil && durationMillis == nil
                && programId == nil && status == nil {
                return nil
            }
        }
        
        internal enum JSONKeys: String {
            case mediaId = "mediaId"
            case name = "name"
            case drm = "drm"
            case format = "format"
            case height = "height"
            case width = "width"
            case durationMillis = "durationMillis"
            case programId = "programId"
            case status = "status"
        }
    }
}
