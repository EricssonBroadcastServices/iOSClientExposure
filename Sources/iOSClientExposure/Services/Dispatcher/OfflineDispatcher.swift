//
//  OfflineDispatcher.swift
//  
//
//  Created by Udaya Sri Senarathne on 2023-06-21.
//

import Foundation
import UIKit
import SystemConfiguration

/// Offline Dispatcher  : Dispatching Offline Analytic events
public class OfflineDispatcher {
    
    /// Internal state governing dispatcher flush behavior.
    internal enum State {
        /// In idle state, ie waiting
        case idle
        
        /// Currently engaging in dispatch proceedure
        case flushing
        
        /// Connection was lost, awaiting recovery
        case connectionLost
    }
    
    /// Tracks the internal state governing dispatch process
    fileprivate(set) internal var state: State = .idle
    
    /// The currently active batch is intimately tied to the `Dispatcher` instance.
    /// Once a `dispatcher` has been initialized, the associated `SessionToken` and `Environment` will never change.
    /// This ensures **dispatch integrity** by never mixing sessions.
    // fileprivate(set) internal var currentBatch: AnalyticsBatch
    fileprivate(set) internal var currentBatch: AnalyticsBatch

    /// Simple timer used to trigger the anaytics flush proceedure
    fileprivate var flushTrigger: Timer?
    
    /// The interval, in seconds, between each analytics flush
    internal var flushInterval: TimeInterval = 5 * 60  // : 5 * 60  => 5 Minutes
        
    /// Network handler
    internal var networkHandler: DispatcherNetworkHandler

    /// Internal log level
    internal static var logLevel: LogLevel = .none
    
    /// LogLevel option
    internal enum LogLevel {
        case none
        case debug
    }
    
    public init(environment: Environment, sessionToken: SessionToken, assetId: String, playSessionId: String, analytics: AnalyticsFromEntitlement?, startupEvents: [AnalyticsEvent] ) {
        self.currentBatch = AnalyticsBatch(sessionToken: sessionToken,
                                            environment: environment,
                                            playToken: playSessionId,
                                            payload: startupEvents,
                                            analytics: analytics)
        
        self.networkHandler = ExposureNetworkHandler()
        
        // Initial start of period flush
        self.periodicFlush()
    }
    
    deinit {
        terminate()
        OfflineDispatcher.log(message: "OfflineDispatcher.deinit")
    }
    
    public func terminate() {
        OfflineDispatcher.log(message: "❗️ Terminating Offline Dispatcher")
        self.flushTrigger?.invalidate()
    }
    
}


// MARK: Enabled / Disable debugger
extension OfflineDispatcher {
    internal static func log(message: String) {
        if case .debug = logLevel {
            print(message)
        }
    }
    
    internal static func log(status: String = "✅", delivery: AnalyticsBatch) {
        if case .debug = logLevel {
            delivery
                .payload
                .compactMap{ $0 as? AnalyticsEvent}
                .forEach{
                    print(" \(status) ",$0.timestamp, $0.eventType,"payload", $0.jsonPayload.count)
            }
        }
    }
}

// MARK: Persist offline analytic events
extension OfflineDispatcher {
    
    ///  Handles enqueueing the offline analytics events
    /// - Parameters:
    ///   - event: events
    ///   - assetId: asset id
    public func offlineEnqueue(event: AnalyticsEvent, assetId: String ) {
        
        // If the eventType is `GracePeriodStarted`, stop the period flush trigger
        if event.eventType == "Playback.GracePeriodStarted" {
            OfflineDispatcher.log(message: "⏳ GracePeriod has Started")
            self.flushTrigger?.invalidate()
        } else {
            var current =  self.currentBatch.payload
            current.append(event)
            currentBatch = AnalyticsBatch(sessionToken: currentBatch.sessionToken,
                                          environment: currentBatch.environment,
                                          playToken: currentBatch.sessionId ,
                                          payload: current,
                                          analytics: currentBatch.analytics)
            
            if (event.eventType == "Playback.Completed") || (event.eventType == "Playback.Aborted") || (event.eventType == "Playback.Error" || (event.eventType == "Playback.GracePeriodEnded") ) {
                endAnalyticsSession(currentBatch, assetId: assetId)
            } else {
                // Other analytics events, do nothing
            }
        }
    }
    
    fileprivate func endAnalyticsSession(_ currentBatch:AnalyticsBatch , assetId: String) {
        do {
            var sequenceNumber = 1
            if let accountId = currentBatch.sessionToken.accountId {
                sequenceNumber  = AnalyticsPersister().getSequenceNumberForSession(businessUnit: currentBatch.businessUnit, customer: currentBatch.customer, accountId: accountId, sessionId: currentBatch.sessionId)
            }
            
            let newUpdatedOfflineBatch = OfflineAnalyticsBatch(assetId: assetId, analyticsBatch: [currentBatch], sessionToken: currentBatch.sessionToken, environment: currentBatch.environment, playToken: currentBatch.sessionId, payload: currentBatch.payload, sequenceNumber: sequenceNumber)
            
            try AnalyticsPersister().persistOfflineAnalytics(analytics: newUpdatedOfflineBatch, sequenceNumber: sequenceNumber)
            OfflineDispatcher.log(message: "💾 Offline Analytics data saved to disk")
            
            // Trying to flush the events already saved to the disk
            self.flushTriggerEvent()
            
            
        } catch {
            // should not happen, but handle the error in case.
            OfflineDispatcher.log(message: "🚨 Offline Analytics saving to disk failed \(error)")
        }
    }
}


// MARK: Flushing Offline Analytics in periodical order
extension OfflineDispatcher {
    
    /// Initiate periodic flush
    fileprivate func periodicFlush() {
        OfflineDispatcher.log(message: "⏱️ Periodic flush starts")
        flushTrigger?.invalidate()
        flushTrigger = Timer.scheduledTimer(timeInterval: flushInterval, target: self, selector: #selector(flushTriggerEvent), userInfo: nil, repeats: true)
    }
    
    /// Invalidate flush trigger
    fileprivate func invalidateFlushTrigger() {
        flushTrigger?.invalidate()
        flushTrigger = nil
    }
    
    /// Check the connection & start offline analytics flush
    @objc fileprivate func flushTriggerEvent() {
        
        // Try to flush the analytics only if there is network connection available
        if self.isConnectedToNetwork() {
            OfflineDispatcher.log(message: "⚡️Internet connection found, Start flushing offline analytics")
            self.flush()
        } else {
            OfflineDispatcher.log(message: "⚠️ No internet connection to flush offline analytics")
        }
    }
    
    /// Flusing Offline analytics tp backend event sink
    fileprivate func flush() {
        state = .flushing
        do {
            
            guard let accountId = currentBatch.sessionToken.accountId else { return }
            let allPersistedAnalytics = try AnalyticsPersister().extractPersistOfflineAnalytics(env: currentBatch.environment, accountId: accountId)
            for (_, persisted ) in allPersistedAnalytics.enumerated() {
                
                OfflineDispatcher.log(message: "Found offline analytics from local storage")
                
                self.networkHandler.deliver(batch: persisted.batch, clockOffset: 0) { [weak self] response, error in
                    if response != nil {
                        OfflineDispatcher.log(message: "✅ Delivered offline persisted analytics ")
                        OfflineDispatcher.log(status:  "📤", delivery: persisted.batch)
                        
                        self?.state = .idle
                        do {
                            let _ = try AnalyticsPersister().delete(persistedAnalytics: persisted)
                        } catch { OfflineDispatcher.log(message: "✅ Deleted delivered offline analytics") }
                    }
                    if let error = error {
                        self?.state = .idle
                        OfflineDispatcher.log(message: "🚨 Error delivering offline analytics. Dispatcher missing. Re-persisting batch: \(error.code), \(error.message)")
                    }
                }
            }
        } catch {
            // Error extracting offline analytics, will try again when periodically flusher hit the clock.
            self.state = .idle
            OfflineDispatcher.log(message: "🚨 Error extracting offline analytics : \(error)")
        }
           
    }
}


// MARK: Network reachability 
extension OfflineDispatcher {
    
    /// Check network connectivity
    /// - Returns: true / false
    internal func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
}
