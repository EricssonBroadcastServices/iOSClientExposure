//
//  SearchResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct SearchResponse: Decodable {
    /// Asset response for the search term
    public let asset: Asset
    
    /// Highlighted title
    public let highlightedTitle: String?
    
    /// Highlighted description
    public let highlightedDescription: String?
}
