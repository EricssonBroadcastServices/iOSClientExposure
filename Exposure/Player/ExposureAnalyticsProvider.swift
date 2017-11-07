//
//  ExposureAnalyticsProvider.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-26.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

public protocol ExposureAnalyticsProvider {
    /// Exposure environment used for the active session.
    ///
    /// - Important: should match the `environment` used to authenticate the user.
    var environment: Environment { get }
    
    /// Token identifying the active session.
    ///
    /// - Important: should match the `environment` used to authenticate the user.
    var sessionToken: SessionToken { get }
    
    func prepareStartupEvents(for asset: AssetIdentifier, autoplay: Bool) -> [AnalyticsPayload]
    
    func prepareHandshakeStarted(for asset: AssetIdentifier, with entitlement: PlaybackEntitlement) -> AnalyticsPayload
    
    func finalizePreparation(for playSessionId: String, startupEvents: [AnalyticsPayload], asset: AssetIdentifier, with entitlement: PlaybackEntitlement, heartbeatsProvider: HeartbeatsProvider)
    
    func exposureError(error: ExposureError)
}


/// Simple protocol responsible for configuring *heartbeats* for the `AnalyticsProvider`.
public protocol HeartbeatsProvider: class {
    /// Should return a *heartbeat* configured for the current environment
    ///
    /// - returns: `AnalyticsPayload` specifying the heartbeat
    func requestHeatbeat() -> HeartbeatData
}

public protocol HeartbeatData {
    var timestamp: Int64 { get }
    var payload: [String: Any]  { get }
}

extension Player: HeartbeatsProvider {
    internal struct PlayerHeartbeatData: HeartbeatData {
        let timestamp: Int64
        let payload: [String: Any]
    }
    
    public func requestHeatbeat() -> HeartbeatData {
        return PlayerHeartbeatData(timestamp: Date().millisecondsSince1970, payload: ["OffsetTime": self.currentTime])
    }
}
extension ExposureDownloadTask: HeartbeatsProvider {
    internal struct DownloadHeartbeatData: HeartbeatData {
        let timestamp: Int64
        let payload: [String: Any]
    }
    
    public func requestHeatbeat() -> HeartbeatData {
        return DownloadHeartbeatData(timestamp: Date().millisecondsSince1970, payload: [:])
    }
}
