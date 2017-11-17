//
//  FetchProgramAiring.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-07.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct FetchProgramAiring: ExposureType {
    public typealias Response = Airing
    
    public var endpointUrl: String {
        return environment.apiUrl + "/epg/" + channelId + "/program/" + programId + "/airing"
    }
    
    public var parameters: [String: Any]? {
        return nil
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
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
    }
}

// MARK: - Request
extension FetchProgramAiring {
    /// `FetchProgramAiring` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
