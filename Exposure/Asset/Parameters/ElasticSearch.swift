//
//  ElasticSearch.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public protocol ElasticSearch {
    var elasticSearchQuery: ElasticSearchQuery { get set }
}

extension ElasticSearch {
    /// https://www.elastic.co/guide/en/elasticsearch/reference/1.7/query-dsl-query-string-query.html
    public var elasticSearchString: String? {
        return elasticSearchQuery.query
    }
    
    /// Will replace any currently active query
    /// https://www.elastic.co/guide/en/elasticsearch/reference/1.7/query-dsl-query-string-query.html
    public func elasticSearch(query string: String?) -> Self {
        var old = self
        old.elasticSearchQuery = ElasticSearchQuery(query: string)
        return old
    }
}

public struct ElasticSearchQuery {
    public let query: String?
    
    internal init(query: String? = nil) {
        self.query = query
    }
}
