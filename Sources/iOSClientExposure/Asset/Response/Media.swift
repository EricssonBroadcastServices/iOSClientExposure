//
//  Media.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Media: Codable {
    /// The id of the media.
    public let mediaId: String?
    
    /// The name of the media.
    public let name: String?
    
    /// The DRM of the media.
    public let drm: String?
    
    /// The streaming format of the media.
    public let format: String?
    
    /// The height in pixels.
    public let height: Int?
    
    /// The width in pixels.
    public let width: Int?
    
    /// The duration of the media in milliseconds.
    public let durationMillis: Int64?
    
    /// The id of the EPG program this media is for.
    public let programId: String?
    
    /// The status of the media. "enabled" if playable.
    public let status: String?
}
