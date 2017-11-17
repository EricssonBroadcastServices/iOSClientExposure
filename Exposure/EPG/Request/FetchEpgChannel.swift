//
//  FetchEpgChannel.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-10.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for fetching *EPG* a specified channel
public struct FetchEpgChannel: ExposureType, SortedResponse, PageableResponse, FilteredPublish, FilteredDates {
    public typealias Response = ChannelEpg
    
    public var endpointUrl: String {
        return environment.apiUrl + "/epg/" + channelId
    }
    
    public var parameters: [String: Any] {
        return queryParams
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    
    // MARK: Filters
    public var sortDescription: SortDescription
    public var pageFilter: PageFilter
    public var publishFilter: PublishFilter
    public var dateFilter: DateFilter
    
    /// Identifier for the requested channel
    public let channelId: String
    
    /// `Environment` to use
    public let environment: Environment
    
    internal init(environment: Environment, channelId: String) {
        self.environment = environment
        self.channelId = channelId
        
        self.sortDescription = SortDescription()
        self.pageFilter = PageFilter()
        self.publishFilter = PublishFilter()
        self.dateFilter = DateFilter()
    }
    
    internal enum Keys: String {
        case onlyPublished = "onlyPublished"
        case pageSize = "pageSize"
        case pageNumber = "pageNumber"
        case sort = "sort"
        case from = "from"
        case to = "to"
    }
    
    internal var queryParams: [String: Any] {
        var params:[String: Any] = [
            Keys.onlyPublished.rawValue: publishFilter.onlyPublished,
            Keys.pageNumber.rawValue: pageFilter.page,
            Keys.pageSize.rawValue: pageFilter.size,
            Keys.from.rawValue: dateFilter.startMillis,
            Keys.to.rawValue: dateFilter.endMillis
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
extension FetchEpgChannel {
    /// `FetchEpgChannel` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get, encoding: ExposureURLEncoding(destination: .queryString))
    }
}
