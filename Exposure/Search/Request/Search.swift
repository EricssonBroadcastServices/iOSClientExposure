//
//  Search.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Search {
    /// Evironment to search in
    public let environment: Environment
}

extension Search {
    /// Searches for the query, performing autocomplete to find matches
    ///
    /// - parameter for: The query to autocomplete
    /// - returns: `SearchAutocomplete` that handles the request
    public func autocomplete(for string: String) -> SearchAutocomplete {
        return SearchAutocomplete(environment: environment,
                                  query: string)
    }
    
    /// Request spelling suggestions for the supplied string
    ///
    /// - parameter for: The query to autocomplete
    /// - returns: `SearchSpelling` that handles the request
    public func spelling(for string: String) -> SearchSpelling {
        return SearchSpelling(environment: environment,
                              query: string)
    }
    
    /// Query *Exposure* for a list of assets based on the supplied search strig
    ///
    /// - parameter for: The query to search for
    /// - returns: `SearchQuery` that handles the request
    public func query(for string: String) -> SearchQuery {
        return SearchQuery(environment: environment,
                           query: string)
    }
}

