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
    
    /// Should prepare and configure the remaining parts of the Analytics environment.
    /// This step is required because we are dependant on the response from Exposure with regards to the playSessionId. Further more, some analytics events may need to be generated before hand. These are supplied as `startupEvents`.
    ///
    /// Once this is called, a Dispatcher should be associated with the session.
    ///
    /// - parameter playSessionId: Unique identifier for the current playback session.
    /// - parameter startupEvents: Events `exposureAnalytics` should deliver as the initial payload
    /// - parameter asset: *EMP* asset identifiers.
    /// - parameter entitlement: The entitlement this session concerns
    /// - parameter heartbeatsProvider: Will deliver heartbeats metadata during the session
    func finalizePreparation(for playSessionId: String, startupEvents: [AnalyticsPayload], asset: AssetIdentifier, with entitlement: PlaybackEntitlement, heartbeatsProvider: HeartbeatsProvider)
    
    /// Expected to deliver the error received while trying to finalize a session to the analytics backend.
    ///
    /// This step is required because we are dependant on the response from Exposure with regards to the playSessionId. Further more, some analytics events may need to be generated before hand. These are supplied as `startupEvents`.
    ///
    /// - parameter error: The encountered error.
    /// - parameter startupEvents: Events `ExposureAnalytics` should deliver as the initial payload related to the error in question.
    func finalize(error: ExposureError, startupEvents: [AnalyticsPayload])
}

public protocol ExposureDownloadAnalyticsProvider: ExposureAnalyticsProvider {
    func downloadStartedEvent(task: ExposureDownloadTask)
    func downloadPausedEvent(task: ExposureDownloadTask)
    func downloadResumedEvent(task: ExposureDownloadTask)
    func downloadCancelledEvent(task: ExposureDownloadTask)
    func downloadStoppedEvent(task: ExposureDownloadTask)
    func downloadCompletedEvent(task: ExposureDownloadTask)
    
    
    /// Triggered if the download process encounters an error during its lifetime
    ///
    /// - parameter ExposureDownloadTask: `ExposureDownloadTask` broadcasting the event
    /// - parameter error: `ExposureError` causing the event to fire
    func downloadErrorEvent(task: ExposureDownloadTask, error: ExposureError)
}
