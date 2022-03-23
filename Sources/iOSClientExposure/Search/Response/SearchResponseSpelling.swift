//
//  SearchResponseSpelling.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct SearchResponseSpelling: Decodable {
    /// The suggested spelling
    public let text: String
    
    /// Related assetId
    public let assetId: String?
}
