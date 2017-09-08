//
//  FetchEpgProgram.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for fetching *Program Data* for a specific program.
public struct FetchEpgProgram: Exposure, FilteredPublish {
    public typealias Response = Program
    
    public var endpointUrl: String {
        return environment.apiUrl + "/epg/" + channelId + "/program/" + programId
    }
    
    public var parameters: [String: Any] {
        return queryParams
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    // MARK: Filters
    public var publishFilter: PublishFilter
    
    /// `Environment` to use
    public let environment: Environment
    
    /// Identifier for the requested channel
    public let channelId: String
    
    /// Identifier for the requested program
    public let programId: String
    
    internal init(environment: Environment, channelId: String, programId: String) {
        self.environment = environment
        self.channelId = channelId
        self.programId = programId
        self.publishFilter = PublishFilter()
    }
    
    internal enum Keys: String {
        case onlyPublished = "onlyPublished"
    }
    
    internal var queryParams: [String: Any] {
        let params:[String: Any] = [
            Keys.onlyPublished.rawValue: publishFilter.onlyPublished
        ]
        
        return params
    }
}

// MARK: - Request
extension FetchEpgProgram {
    /// `FetchEpgProgram` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.get, encoding: ExposureURLEncoding(destination: .queryString))
    }
}
