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
    public let asset: Asset
    public let startedWatching: Bool
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        asset = try container.decode(Asset.self, forKey: .asset)
        startedWatching = try container.decode(Bool.self, forKey: .startedWatching)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case asset
        case startedWatching
    }
}
