//
//  FetchLastViewOffsetList.swift
//  Exposure-iOS
//
//  Created by Johnny Sundblom on 2020-02-17.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

// *Exposure* endpoint integration for fetching the last view offset for a specific range of asset id:s
public struct FetchLastViewedOffsetList: ExposureType, FilteredAssetIds, SortedResponse {

    public var endpointUrl: String {
        var environmentV1 = environment
        environmentV1.version = "v1"

        return environmentV1.apiUrl + "/userplayhistory/lastviewedoffset"
    }
    
    public typealias Response = LastViewedOffsetList
    
    /// `Environment` to use
    public var environment: Environment
    
    
    public var parameters: [String: Any] {
        return queryParams
    }
    
    /// `Last view offset Endpoint` requires no headers
    public var headers: [String: String]? {
        return userDataFilter.sessionToken?.authorizationHeader
    }
    
    // MARK: Filters
    public var sortDescription: SortDescription
    public var assetIdFilter: AssetIdFilter
    public var userDataFilter: UserDataFilter

    public init(assetIds: [String]?, environment: Environment, sessionToken: SessionToken?) {
        self.environment = environment
        self.sortDescription = SortDescription()
        self.assetIdFilter = AssetIdFilter(assetIds: assetIds)
        self.userDataFilter = UserDataFilter(sessionToken: sessionToken)
    }
    
    internal enum Keys: String {
        case sort = "sort"
        case assetIds = "assetIds"
    }
    
    internal var queryParams: [String: Any] {
       
        var params:[String: Any] = [:]
        

        
        if let assetIds = assetIdFilter.assetIds {
            let ids = assetIds.map {
                URLEncoding().escape($0)
            }
            params[Keys.assetIds.rawValue] = ids
        }
        
        if let sort = sortDescription.descriptors {
            // Query string is keys separated by ",".
            // Any descending key should include a "-" sign as a prefix.
            params[Keys.sort.rawValue] = sort
                .map{ $0.ascending ? $0.key : "-" + $0.key }
                .joined(separator: ",")
        }
        
        // print(params)
        
        return params
    }
}


// MARK: - Request
extension FetchLastViewedOffsetList {
    
    /// `FetchLastViewOffsetList` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response>{
        return request(.get)
    }
}

