//
//  FetchPreviousProgram.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-05-08.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

public struct FetchPreviousProgram: ExposureType {
    
    public typealias Response = Program
    
    public var endpointUrl: String {
        return environment.apiUrl + "/epg/program/" + programId + "/previous"
    }
    
    public var parameters: [String: Any]? {
        return queryParams
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    /// `Environment` to use
    public let environment: Environment
    
    /// Identifier for the requested program
    public let programId: String
    
    // MARK: Filters
    public var publishFilter: PublishFilter
    
    internal enum Keys: String {
        case onlyPublished = "onlyPublished"
    }
    
    internal var queryParams: [String: Any] {
        let params:[String: Any] = [
            Keys.onlyPublished.rawValue: publishFilter.onlyPublished
        ]
        
        return params
    }
    
    
    internal init(environment: Environment, programId: String) {
        self.environment = environment
        self.programId = programId
        self.publishFilter = PublishFilter()
    }
}

// MARK: - Request
extension FetchPreviousProgram {
    /// `FetchNextProgram` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
