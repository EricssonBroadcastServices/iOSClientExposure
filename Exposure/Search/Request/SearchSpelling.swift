//
//  SearchSpelling.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct SearchSpelling: ExposureType, FilteredLocale {
    public typealias Response = SearchResponseAutocomplete
    
    public var endpointUrl: String {
        return environment.apiUrl + "content/search/suggestions/" + query
    }
    
    public var parameters: [String: Any]? {
        return queryParams
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public let environment: Environment
    
    /// The query string to request spelling suggestions for
    public let query: String
    
    public var localeFilter: LocaleFilter
    
    public init(environment: Environment, query: String) {
        self.environment = environment
        self.query = query
        self.localeFilter = LocaleFilter()
    }
    
    internal var queryParams: [String: Any]? {
        guard let locale = localeFilter.specifiedLocale else { return nil }
        return ["locale":locale]
    }
}
