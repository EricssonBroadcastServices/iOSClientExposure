//
//  FetchEventList.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2019-09-16.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for fetching *Events* for a specific date range
public struct FetchEventList: ExposureType, PageableResponse, FilteredEventDates, SortedResponse {
    
    public let date: String
    
    public var endpointUrl: String {
        var environmentV2 = environment
        environmentV2.version = "v2"
        return environmentV2.apiUrl + "/event/date/" + date
    }
    
    public typealias Response = EventList
    
    /// `Environment` to use
    public var environment: Environment
    
    
    public var parameters: [String: Any] {
        return queryParams
    }
    
    /// `Event Endpoint` requires no headers
    public var headers: [String: String]? {
        return nil
    }
    
    // MARK: Filters
    public var pageFilter: PageFilter
    public var eventDateFilter: EventDateFilter
    public var sortDescription: SortDescription

    public init(environment: Environment, date: String) {
        self.environment = environment
        self.pageFilter = PageFilter()
        self.eventDateFilter = EventDateFilter()
        self.sortDescription = SortDescription()
        self.date = date
    }
    
    internal enum Keys: String {
        case daysBackward = "daysBackward"
        case daysForward = "daysForward"
        case pageSize = "pageSize"
        case pageNumber = "pageNumber"
        case sort = "sort"
    }
    
    internal var queryParams: [String: Any] {
        var params:[String: Any] = [
            Keys.daysBackward.rawValue: eventDateFilter.daysBackward,
            Keys.daysForward.rawValue: eventDateFilter.daysForward,
            Keys.pageNumber.rawValue: pageFilter.page,
            Keys.pageSize.rawValue: pageFilter.size
        ]
        
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


// MARK: - Request
extension FetchEventList {
    
    /// `FetchEventList` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response>{
        return request(.get)
    }
}
