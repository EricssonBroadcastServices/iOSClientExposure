//
//  ContinueTVShow.swift
//  Exposure
//
//  Created by Johnny Sundblom on 2020-02-28.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

/// `ContinueTVShow` contains *ContinueTVShow* information about the new episode to play for a tv-series.
public struct ContinueTVShow: Decodable {
    /// The next asset/episode to play
    public let asset: Asset
    /// Should start watching or continue tv-show
    public let startedWatching: Bool
    /// Last viewed offset, offset in the last play of the asset.
    public let lastViewedOffset: Int
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        asset = try container.decode(Asset.self, forKey: .asset)
        startedWatching = try container.decode(Bool.self, forKey: .startedWatching)
        lastViewedOffset = try container.decode(Int.self, forKey: .lastViewedOffset)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case asset
        case startedWatching
        case lastViewedOffset
    } 
}
