//
//  Entitlement.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-12.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Entitlement {
    public let environment: Environment
    public let sessionToken: SessionToken
    
    public init(environment: Environment, sessionToken: SessionToken) {
        self.environment = environment
        self.sessionToken = sessionToken
    }
}

extension Entitlement {
    public func vod(assetId: String) -> PlayVod {
        return PlayVod(assetId: assetId,
                       environment: environment,
                       sessionToken: sessionToken)
    }
}
