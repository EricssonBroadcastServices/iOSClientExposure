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
    /// If the entitlement checks pass, will return the information needed to initialize the 
    /// player for the requested streaming format.
    ///
    /// Default streaming format is [drm:FAIRPLAY format:HLS]
    public func vod(assetId: String) -> PlayVod {
        return PlayVod(assetId: assetId,
                       environment: environment,
                       sessionToken: sessionToken)
    }
    
    /// Entitlements are set on program level, so this is shorthand for getting the epg 
    /// and playing the currently live program. If the entitlement checks pass, will 
    /// return the information needed to initialize the player for the requested streaming format.
    ///
    /// Default streaming format is [drm:FAIRPLAY format:HLS]
    ///
    /// If there is no current program live will return NOT_ENABLED.
    public func live(channelId: String) -> PlayLive {
        return PlayLive(channelId: channelId,
                        environment: environment,
                        sessionToken: sessionToken)
    }
    
    /// If the entitlement checks pass, will return the information needed to initialize the 
    /// player for the requested streaming format.
    ///
    /// Default streaming format is [drm:FAIRPLAY format:HLS]
    public func catchup(channelId: String, programId: String) -> PlayCatchup {
        return PlayCatchup(channelId: channelId,
                           programId: programId,
                           environment: environment,
                           sessionToken: sessionToken)
    }
}
