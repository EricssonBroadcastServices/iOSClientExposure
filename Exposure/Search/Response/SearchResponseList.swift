//
//  SearchResponseList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct SearchResponseList: Decodable {
    /// Total number of search response items
    public let totalCount: Int
    
    /// Items per page
    public let pageSize: Int
    
    /// Page number
    public let pageNumber: Int
    
    /// Suggestion
    public let suggestion: String?
    
    /// Search response for search term
    public let items: [SearchResponse]
}
