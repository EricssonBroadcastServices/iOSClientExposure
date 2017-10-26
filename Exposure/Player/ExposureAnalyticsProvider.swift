//
//  ExposureAnalyticsProvider.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-26.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

public protocol ExposureAnalyticsProvider: AnalyticsProvider {
    /// Exposure environment used for the active session.
    ///
    /// - Important: should match the `environment` used to authenticate the user.
    var environment: Environment { get }
    
    /// Token identifying the active session.
    ///
    /// - Important: should match the `environment` used to authenticate the user.
    var sessionToken: SessionToken { get }
    
    func finalizeCurrent(playSessionId: String, at offset: Int64, timestamp: Int64)
    
    func prepareStartupEvents(for asset: AssetIdentifier, autoplay: Bool) -> [AnalyticsPayload]
    
    func prepareHandshakeStarted(for asset: AssetIdentifier, with entitlement: PlaybackEntitlement) -> AnalyticsPayload
    
    func finalizePreparation(for playSessionId: String, startupEvents: [AnalyticsPayload], asset: AssetIdentifier, with entitlement: PlaybackEntitlement)
}
