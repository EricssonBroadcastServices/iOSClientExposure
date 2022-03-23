//
//  FetchLastViewOffset.swift
//  Exposure-iOS
//
//  Created by Johnny Sundblom on 2020-02-17.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

/// *Exposure* request for fetching *LastViewedOffset*.
public struct FetchLastViewedOffset {
    /// `Environment` to use
    public let environment: Environment
    public let sessionToken: SessionToken?
    
    public init(environment: Environment, sessionToken: SessionToken?) {
        self.environment = environment
        self.sessionToken = sessionToken
    }
}

extension FetchLastViewedOffset {
    
    /// Fetches all the live events
    ///
    /// - returns: `FetchLastViewedOffsetList` struct used to process the request.
    public func list(assetIds: [String]?) -> FetchLastViewedOffsetList {
        return FetchLastViewedOffsetList(assetIds: assetIds, environment: environment, sessionToken: sessionToken)
    }
}
