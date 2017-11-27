//
//  FetchCarouselItem.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for *CarouselList*.
public struct FetchCarouselItem: ExposureType, FilteredFields, FilteredPublish, PageableResponse {
    public typealias Response = CarouselItem
    
    public var parameters: [String: Any]? {
        return queryParams
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public let environment: Environment
    
    /// The group id for the carousel
    public let groupId: String
    
    // The id for the carousel
    public let carouselId: String
    
    public var fieldsFilter: FieldsFilter
    public var publishFilter: PublishFilter
    public var pageFilter: PageFilter
    
    internal init(groupId: String, carouselId: String, environment: Environment) {
        self.groupId = groupId
        self.carouselId = carouselId
        self.environment = environment
        
        self.fieldsFilter = FieldsFilter()
        self.publishFilter = PublishFilter()
        self.pageFilter = PageFilter()
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/carouselgroup/" + groupId + "/carousel/" + carouselId
    }
    
    internal enum Keys: String {
        case onlyPublished = "onlyPublished"
        case fieldSet = "fieldSet"
        case excludeFields = "excludeFields"
        case includeFields = "includeFields"
        case pageSize = "pageSize"
        case pageNumber = "pageNumber"
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
        
        return params
    }
}

extension FetchCarouselItem {
    /// `FetchCarouselList` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get, encoding: ExposureURLEncoding(destination: .queryString))
    }
}
