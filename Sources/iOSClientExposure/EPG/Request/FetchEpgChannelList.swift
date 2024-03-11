//
//  FetchEpgChannelList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for fetching *EPG* for a set of channels
public struct FetchEpgChannelList: ExposureType, SortedResponse, PageableResponse, FilteredPublish, FilteredDates, FilteredAssetIds {
    public typealias Response = [ChannelEpg]
    
    public var endpointUrl: String {
        let channelIds = assetIdFilter.assetIds?.joined(separator: ",") ?? ""
        let escaped = URLEncoding().escape(channelIds)
        switch version {
        case .v1:
            return environment.apiUrl + "/epg/" + escaped
        case .v2:
            return environment.apiUrl + "/epg/" + escaped + "/date/" + date.todaySimple
        }
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
    public var assetIdFilter: AssetIdFilter
    
    /// `Environment` to use
    public let environment: Environment
    
    private let version: FetchEpg.Version
    private let date: Date
    
    internal init(
        environment: Environment,
        date: Date = Date(),
        version: FetchEpg.Version
    ) {
        self.environment = environment
        self.sortDescription = SortDescription()
        self.pageFilter = PageFilter()
        self.publishFilter = PublishFilter()
        self.dateFilter = DateFilter()
        self.assetIdFilter = AssetIdFilter()
        
        self.date = date
        self.version = version
    }
    
    internal enum Keys: String {
        case onlyPublished
        case pageSize
        case pageNumber
        case sort
        case from
        case to
        case daysBackward
        case daysForward
    }
    
    internal var queryParams: [String: Any] {
        var params:[String: Any]
        
        switch version {
        case .v1:
            params = [
                Keys.onlyPublished.rawValue: publishFilter.onlyPublished,
                Keys.pageNumber.rawValue: pageFilter.page,
                Keys.pageSize.rawValue: pageFilter.size,
                Keys.from.rawValue: dateFilter.startMillis,
                Keys.to.rawValue: dateFilter.endMillis
            ]
        case .v2:
            params = [
                Keys.pageNumber.rawValue: pageFilter.page,
                Keys.pageSize.rawValue: pageFilter.size,
                Keys.daysBackward.rawValue: dateFilter.daysBackward(date: date),
                Keys.daysForward.rawValue: dateFilter.daysForward(date: date)
            ]
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

// MARK: - Request
extension FetchEpgChannelList {
    /// `FetchEpgChannelList` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
