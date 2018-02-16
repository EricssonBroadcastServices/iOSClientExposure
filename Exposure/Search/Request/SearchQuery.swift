//
//  SearchQuery.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct SearchQuery: ExposureType, FilteredLocale, SortedResponse, PageableResponse, FilteredFields, FilteredPublish {
    public typealias Response = SearchResponseList
    
    public var endpointUrl: String {
        return environment.apiUrl + "/content/search/query/" + URLEncoding().escape(query)
    }
    
    public var parameters: [String: Any] {
        return queryParams
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public let environment: Environment
    
    /// The query string to request spelling suggestions for
    public let query: String
    
    public var localeFilter: LocaleFilter
    public var sortDescription: SortDescription
    public var pageFilter: PageFilter
    public var fieldsFilter: FieldsFilter
    public var publishFilter: PublishFilter
    
    
    internal var internalQuery: Query
    
    public init(environment: Environment, query: String) {
        self.environment = environment
        self.query = query
        self.localeFilter = LocaleFilter()
        self.sortDescription = SortDescription()
        self.pageFilter = PageFilter()
        self.fieldsFilter = FieldsFilter()
        self.publishFilter = PublishFilter()
        self.internalQuery = Query()
    }
    
    internal enum Keys: String {
        case onlyPublished = "onlyPublished"
        case fieldSet = "fieldSet"
        case excludeFields = "excludeFields"
        case includeFields = "includeFields"
        case pageSize = "pageSize"
        case pageNumber = "pageNumber"
        case types = "types"
        case sort = "sort"
        case locale = "locale"
    }
    
    internal var queryParams: [String: Any] {
        var params:[String: Any] = [
            Keys.onlyPublished.rawValue: publishFilter.onlyPublished,
            Keys.fieldSet.rawValue: fieldsFilter.fieldSet.rawValue,
            Keys.pageNumber.rawValue: pageFilter.page,
            Keys.pageSize.rawValue: pageFilter.size
        ]
        
        if let excluded = fieldsFilter.excludedFields, !excluded.isEmpty {
            // Query string is keys separated by ","
            params[Keys.excludeFields.rawValue] = excluded.joined(separator: ",")
        }
        
        if let included = fieldsFilter.includedFields, !included.isEmpty {
            // Query string is keys separated by ","
            params[Keys.includeFields.rawValue] = included.joined(separator: ",")
        }
        
        if let types = internalQuery.types {
            params[Keys.types.rawValue] = types.joined(separator: ",")
        }
        
        if let locale = localeFilter.specifiedLocale {
            params[Keys.locale.rawValue] = locale
        }
        
        if let sort = sortDescription.descriptors {
            // Query string is keys separated by ",".
            // Any descending key should include a "-" sign as a prefix.
            params[Keys.sort.rawValue] = sort
                .map{ $0.ascending ? $0.key : "-" + $0.key }
                .joined(separator: ",")
        }
        return params
    }
}

extension SearchQuery {
    // MARK: AssetType
    public var types: [String]? {
        return internalQuery.types
    }
    
    public func filter(on assetTypes: [String]?) -> SearchQuery {
        var old = self
        old.internalQuery = Query(types: assetTypes)
        return old
    }
}

extension SearchQuery {
    internal struct Query {
        internal let types: [String]?
        internal init(types: [String]? = nil) {
            self.types = types
        }
    }
}

// MARK: - Request
extension SearchQuery {
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
