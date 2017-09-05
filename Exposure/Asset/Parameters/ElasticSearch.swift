//
//  ElasticSearch.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines an *Exposure request* filter using *elasic search*.
///
/// For more information regarding *elastic seach*, please see [elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/1.7/query-dsl-query-string-query.html)
public protocol ElasticSearch {
    var elasticSearchQuery: ElasticSearchQuery { get set }
}

extension ElasticSearch {
    /// The search string, as defined in `elastic search dsl`.
    public var elasticSearchString: String? {
        return elasticSearchQuery.query
    }
    
    /// Will replace any currently active query
    ///
    /// The optional query to filter by. In the elasticsearch query string query format, I.E:
    ///
    /// ```
    /// "tags.genres:action AND localized.en-us.title:armageddon"
    /// ```
    ///
    /// elastic.co [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/1.7/query-dsl-query-string-query.html)
    ///
    /// - parameter string: the query as defined in `elastic search dsl`
    /// - returns: `Self`
    public func elasticSearch(query string: String?) -> Self {
        var old = self
        old.elasticSearchQuery = ElasticSearchQuery(query: string)
        return old
    }
}

/// Used internally to configure the *elastic search* query
public struct ElasticSearchQuery {
    public let query: String?
    
    internal init(query: String? = nil) {
        self.query = query
    }
}
