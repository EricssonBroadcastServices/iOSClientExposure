//
//  AssetUserData.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct AssetUserData: Decodable {
    public let playHistory: AssetUserPlayHistory?
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        playHistory = try? container.decode(AssetUserPlayHistory.self, forKey: .playHistory)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case playHistory
    }
}
