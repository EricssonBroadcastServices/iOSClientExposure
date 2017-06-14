//
//  Program.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Program: ExposureConvertible {
    public let created: String? //The date the program was created.
    public let changed: String? //The date the program was changed.
    public let programId: String? //The id of the program.
    public let assetId: String? //The id of the asset this program is for.
    public let channelId: String? //The id of the channel this program is on.
    public let startTime: String?
    public let endTime: String?
    public let vodAvailable: Bool? //If this asset is currently available as VOD.
    public let catchup: Bool? //If this asset is currently available as rough cut that is not expired.
    public let catchupBlocked: Bool? //If this asset is currently blocked for catchup.
    public let asset: Asset? // The asset metadata
    public let blackout: Bool? //If this program is currently published as blackout. This means any publication contains blackout, not global blackout
    
    public init?(json: Any) {
        
    }
}
