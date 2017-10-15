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
    
    public init(environment: Environment) {
        self.environment = environment
    }
}

extension Search {
    /// Searches for the query, performing autocomplete to find matches
    ///
    /// - parameter query: The query to autocomplete
    /// - returns: `SearchAutocomplete` that handles the request
    public func autocomplete(query: String) -> SearchAutocomplete {
        return SearchAutocomplete(environment: environment,
                                  query: query)
    }
    
    /// Request spelling suggestions for the supplied string
    ///
    /// - parameter query: The query to autocomplete
    /// - returns: `SearchSpelling` that handles the request
    public func spelling(for string: String) -> SearchSpelling {
        return SearchSpelling(environment: environment,
                              query: string)
    }
}

