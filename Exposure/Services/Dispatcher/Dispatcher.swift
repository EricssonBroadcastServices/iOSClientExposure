//
//  Dispatcher.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-07-25.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Analytics dispatch consists of several subcomponents each responsible for a distinct task.
/// The core system consists of a realtime delivery engine which optimizes the networking process for minimal usage and maximum responsiveness. This is achived by batching the events in a pipe.
///
/// A second subsystem watches for delivery response errors and maintains a retry queue. Once the dispatcher recieves an error message, as a server response or a networking issue, the current batch is marked for retry. 
/// This process is active as long as the `dispatcher` is alive.
///
/// Once the `dispatcher` reaches the end of it's lifecycle, the `termination` procedure activates. This subsytem will handle any unsent data by either dispatch or, failing that, storing the events to disk. Persisted events are delivered as soon another `dispatcher` is instantiated.
public class Dispatcher {
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
    fileprivate(set) internal var currentBatch: AnalyticsBatch
    
    /// In the event the `dispatcher` fails to deliver the current batch, that batch will be *marked for retry*
    fileprivate var undeliveredBatch: AnalyticsBatch?
    
    /// Stores the internal dispatch environment
    fileprivate var configuration: Configuration
    
    /// Manages local storage access for persisted analytics payloads
    fileprivate let persister: AnalyticsPersister
    
    /// Provides the `dispatcher` with a configured heartbeat if available
    fileprivate var heartbeatsProvider: () -> AnalyticsEvent?
    
    /// Simple timer used to trigger the anaytics flush proceedure
    fileprivate var flushTrigger: Timer?
    
    /// The interval, in seconds, between each analytics flush
    internal var flushInterval: TimeInterval = 3
    
    
    internal var networkHandler: DispatcherNetworkHandler
    
    public init(environment: Environment, sessionToken: SessionToken, playSessionId: String, startupEvents: [AnalyticsEvent], heartbeatsProvider: @escaping () -> AnalyticsEvent?) {
        self.currentBatch = AnalyticsBatch(sessionToken: sessionToken,
                                           environment: environment,
                                           playToken: playSessionId,
                                           payload: startupEvents)
        self.configuration = Configuration()
        self.heartbeatsProvider = heartbeatsProvider
        self.persister = AnalyticsPersister()
        self.networkHandler = AlamofireNetworkHandler()
    }
    
    deinit {
        terminate()
        print("Dispatcher.deinit")
    }
    
    /// Will merge undelivered events with the currently active batch. The async nature of dispatch requires us to have one point where we, before delivery, can decide what to send.
    ///
    /// - important: 
    /// Calling this method will *detach* `currentBatch` and `undeliveredBatch`, effectivley clearing them. The two detached batches will then be merged and returned. Failure to handle the returned `AnalyticsBatch` by dispatch or persistence will cause the payload to be lost.
    /// 
    /// - returns: merged `AnalyticsBatch`
    fileprivate func extractBatch() -> AnalyticsBatch {
        var current = currentBatch
        
        if let undeliveredBatch = undeliveredBatch {
            print("♻️ Retrying delivery by merging \(undeliveredBatch.payload.count) underlivered events")
            // By design, undeliveredBatch events occured before the currentBatch events, no sort should be required
            
            var combinedPayload = undeliveredBatch.payload
            combinedPayload.append(contentsOf: current.payload)
            
            // Replace the object we want to send with a merged payload unit
            current = AnalyticsBatch(sessionToken: current.sessionToken,
                                     environment: current.environment,
                                     playToken: current.sessionId,
                                     payload: combinedPayload)
            self.undeliveredBatch = nil
        }
        
        currentBatch = AnalyticsBatch(sessionToken: currentBatch.sessionToken,
                                      environment: currentBatch.environment,
                                      playToken: currentBatch.sessionId)
        return current
    }
}

extension Dispatcher {
    /// Dispatch termination requires any outstanding analytics events be processed before the `dispatcher` is disposed. This happens in two steps where the first consists of an attempt to dispatch the events. If that fails, for example due to networking issues, the payload will be persisted on disk locally.
    ///
    /// - important:
    /// This method should be called before the `dispatcher` is disposed, preferably manually. It should be noted that since this involves an async networking call. If this fails, the `persister` will attempt to persist the related analytics.
    public func terminate() {
        print("❗️ Terminating Dispatcher")
        invalidateFlushTrigger()
        configuration.heartbeatsEnabled = false
        
        let current = extractBatch()
        guard !current.payload.isEmpty else { return }
        
        networkHandler.deliver(batch: current,
                               clockOffset: configuration.synchronizedClockOffset) { [persister] _, error in
                // NOTE: Capture of self needs to be strong. Else we can not ensure saving will work properly. Reference will be cleaned up after block finishes.
                if let error = error {
                    // These events need to be stored to disk
                    print("🚨 Failed to deliver events on termination.", error.message)
                    
                    do {
                        try persister.persist(analytics: current)
                        print("💾 Analytics data saved to disk")
                    }
                    catch {
                        print("🚨 AnalyticsPersister failed to persist analytics data before terminating",error)
                    }
                }
                else {
                    print("Delivered: \(current.payload.count) events before terminating")
                    current
                        .payload
                        .flatMap{ $0 as? AnalyticsEvent}
                        .forEach{
                            print(" ✅ ",$0.eventType)
                    }
                }
        }
    }
    
}

extension Dispatcher {
    /// The flush trigger is responsible for periodic invocation of the delivery pipeline. Once disabled, the system may not flush analytics events in a predictable manner.
    ///
    /// - Important:
    /// Flush trigger should be disabled before the `dispatcher` is disposed since it contains a reference to self. In general, this should be done through `terminate`.
    /// Disabling the *flush trigger* will also disable heartbeats
    ///
    /// - parameter enabled: `true` for enabled, `false` to disable
    public func flushTrigger(enabled: Bool) {
        if enabled {
            flushTrigger?.invalidate()
            flushTrigger = Timer.scheduledTimer(timeInterval: flushInterval, target: self, selector: #selector(flushTriggerEvent), userInfo: nil, repeats: true)
        }
        else {
            invalidateFlushTrigger()
            heartbeat(enabled: false)
            flush(forced: true)
        }
    }
    
    fileprivate func invalidateFlushTrigger() {
        flushTrigger?.invalidate()
        flushTrigger = nil
    }
    
    /// Indicates if `flush trigger` has been enabled. If so, the dispatcher will continuously deliver any payload it has aquired.
    internal var flushTriggerEnabled: Bool {
        return flushTrigger != nil && flushTrigger!.isValid
    }
    
    /// Consumed by `flushTrigger`.
    @objc private func flushTriggerEvent() {
        flush(forced: false)
    }
}

extension Dispatcher {
    /// Triggers the analytics delivery process, delivering any previously persisted events and, pending the system state is acceptable, delivering realtime analytics.
    ///
    /// Delivery of the currently active batch is guided by several factors. First, flushing will only take place if the `dispatcher` is in an `idle` state. This is to ensure delivery robustness. 
    /// 
    /// Secondly, in order to minimize network traffic the system imposes a `buffer limit` on analytics payload limiting how long they may be kept before delivery is required. Unless this limit is reached, no flushing will take place.
    ///
    /// Once the active batch has been empty and no events have taken place for a specified amount of time the `dispatcher` will send a `heartbeat` to inform the server the session is still active. Heartbeats should only be sent on an active session. This functionality can be controlled by calling `heartbeat(enabled:)`.
    ///
    /// Finaly, specifying `forced = true` will force flush the system (if the system state is acceptable).
    internal func flush(forced: Bool) {
        processUndeliveredAnalytics()
        
        guard state == .idle else { return }
        
        let currentTime = Date().millisecondsSince1970
        
        if forced {
            flush()
        }
        else if let limit = currentBatch.bufferLimit(), currentTime >= limit {
            // Existance of a bufferLimit indicates we have payload to send
            flush()
        }
        else {
            // No Payload, check if we should send a heartbeat
            guard configuration.heartbeatsEnabled else { return }
            if let lastDispatch = configuration.lastDispatchTimestamp {
                if (currentTime - lastDispatch) > configuration.reportingTimeinterval || forced {
                    if let heartbeat = heartbeatsProvider() {
                        appendToCurrentBatch(event: heartbeat)
                        flush()
                    }
                }
            }
            else {
                // No dispatch as been made yet. This really should not happen, but in case it does we mark this time as the last dispatch
                configuration.lastDispatchTimestamp = currentTime
            }
        }
    }
    
    /// Will trigger the realtime delivery process pending the analytics batch is not empty,
    ///
    /// - Note:
    /// Every dispatch is preceeded by a clock sync with the server
    private func flush() {
        guard !currentBatch.payload.isEmpty else { return }
        
        state = .flushing
        
        synchronize{ [weak self] error in
            guard let weakSelf = self else { return }
            
            let currentBatch = weakSelf.extractBatch()
            
            weakSelf.realtime(analytics: currentBatch,
                              clockOffset: weakSelf.configuration.synchronizedClockOffset)
        }
    }
}

extension Dispatcher {
    /// Delivers the specified analytics batch to the server and processes the resulting response.
    /// Failure to dispatch will result in a retry if applicable.
    ///
    /// - parameter analytics: analytics batch to deliver
    /// - parameter clockOffset: current offset between server timestamp and device time, or `nil` if not available
    fileprivate func realtime(analytics: AnalyticsBatch, clockOffset: Int64?) {
        print("Delivering Realtime: \(analytics.payload.count) events")
        analytics
            .payload
            .flatMap{ $0 as? AnalyticsEvent}
            .forEach{
                print(" 📤 ",$0.eventType)
        }
        
        networkHandler
            .deliver(batch: analytics,
                     clockOffset: clockOffset) { [weak self] success, error in
                        if let error = error {
                            self?.handle(error: error, for: analytics)
                        }
                        else if let success = success {
                            self?.process(response: success, for: analytics)
                        }
        }
    }
    
    /// Finalizes the successful delivery of an anlytics batch by processing the server response, updating
    /// `reportingTimeinterval` with the requested frequency and setting `lastDispatchTimestamp` to the current time.
    ///
    /// - parameter response: Response received while delivering the analytics batch.
    /// - parameter analytics: Analytics batch successfully delivered.
    private func process(response: AnalyticsConfigResponse, for analytics: AnalyticsBatch) {
        defer {
            // Update state
            state = .idle
        }
        
        print("Delivered: \(analytics.payload.count) events")
        analytics
            .payload
            .flatMap{ $0 as? AnalyticsEvent}
            .forEach{
                print(" ✅ ",$0.eventType)
        }
        
        // Update reporting interval
        if let reportingInterval = response.secondsUntilNextReport {
            self.configuration.reportingTimeinterval = Int64(reportingInterval) * 1000
        }
        
        // Last event in delivered batch marks last dispatch timestamp
        if let event = analytics.payload.last as? AnalyticsEvent {
            if let lastDispatch = configuration.lastDispatchTimestamp {
                if event.timestamp > lastDispatch {
                    configuration.lastDispatchTimestamp = event.timestamp
                }
            }
            else {
                configuration.lastDispatchTimestamp = event.timestamp
            }
        }
    }
    
    /// Handles retry logic for failed delivery of realtime analytics.
    ///
    /// - parameter error: `ExposureError` casuing the delivery to fail
    /// - parameter analytics: the batch for which delivery failed
    ///
    /// - Note: This method should **not** be called for offline analytics. *INVALID_SESSION_TOKEN* should not lock playback for previously generated analytics trying to be sent on a new session.
    private func handle(error: ExposureError, for analytics: AnalyticsBatch) {
        defer {
            // Update state
            state = .idle
        }
        
        if case let .exposureResponse(reason: reason) = error, (reason.httpCode == 401 && reason.message == "INVALID_SESSION_TOKEN") {
            // The sessionToken was rendered invalid during playback. This signals player lockdown should be performed.
        }
        else {
            // Check if the error was due to connection lost
            print("🚨 Failed to deliver payload: ",error.message)
            
            print("📎 Marking failed dispatch events for retry")
            
            // In the event we have any undelivered payload at this point, merge it with the incoming `analytics` payload
            var combinedPayload = undeliveredBatch?.payload ?? []
            combinedPayload.append(contentsOf: analytics.payload)
            undeliveredBatch = AnalyticsBatch(sessionToken: analytics.sessionToken,
                                              environment: analytics.environment,
                                              playToken: analytics.sessionId,
                                              payload: combinedPayload)
        }
    }
}

extension Dispatcher {
    /// Persisted events and sessions occur when the Dispatcher was previously unable to deliver its payload. These `batches` are related to an accountId (through the attached SessionToken) and a playSessionId.
    ///
    /// Batches where `sessionToken.accountId` matches the current active batch can be delivered using that sessionToken.
    /// Batches with a sessionToken containing a non-matching `accountId` falls under one of two scenarios:
    /// 1. SessionToken still valid
    ///     => send the analytics
    /// 2. SessionToken not valid
    ///    a. AccountId for the batch is the same as the accountId for the currently active batch.
    ///        => Send batch using `currentlyActive` sessionToken
    ///    b. AccountId does not match.
    ///        (x) do not send. We need a matching accountId OR a valid sessionToken to deliver the analytics
    ///
    /// Further more, batches should not be kept in storage forever. Once the timestamp of a persisted batch is older than `limit`, the batch should be deleted as the data is considered lost.
    ///
    /// Once a persisted batch has been successfully delivered, it can be deleted from storage.
    fileprivate func processUndeliveredAnalytics() {
        procesRelatedAnalytics()
        clearStaleAnalytics()
        
    }
    
    /// Will fetch and dispatch any previously persisted analytics with the same `accountId` as the currently active batch.
    /// A first attempt to deliver the payload will be made using the `sessionToken` attached to the persisted batch.
    /// Failing that, the system will try dispatch through `process(error:delivery:)`.
    private func procesRelatedAnalytics() {
        guard let accountId = currentBatch.sessionToken.accountId else { return }
        do {
            let relatedAnalytics = try persister.analytics(accountId: accountId,
                                                           businessUnit: currentBatch.businessUnit,
                                                           customer: currentBatch.customer)
            
            relatedAnalytics.forEach{ persisted in
                print("Delivering Persisted: \(persisted.batch.payload.count) events")
                persisted
                    .batch
                    .payload
                    .forEach{ print(" 📤 PayloadCount", $0.jsonPayload.count) }
                
                networkHandler.deliver(batch: persisted.batch,
                                       clockOffset: configuration.synchronizedClockOffset) { [weak self] response, error in
                        if let error = error {
                            self?.process(error: error, delivery: persisted)
                        }
                        else if response != nil {
                            self?.process(delivery: persisted)
                        }
                }
            }
        }
        catch {
            print("🚨 Failed to retrieve related, persisted analytics for \(accountId) due to",error.localizedDescription)
        }
        
        
    }
    
    /// Once a related persisted analytics batch has been successfully delivered, this method is called causing the local file to be removed.
    private func process(delivery: PersistedAnalytics) {
        print("Delivered Persisted Analytics: \(delivery.batch.payload.count) events")
        delivery
            .batch
            .payload
            .forEach{ print(" ✅ PayloadCount", $0.jsonPayload.count) }
        
        do {
            try self.persister.delete(persistedAnalytics: delivery)
        }
        catch {
            print("🚨 Unable to delete persisted batch after delivery:",error.localizedDescription)
        }
    }
    
    /// If a related, persisted analytics batch failed to be delivered, this method will handle the related error
    /// 
    /// - parameter error: `ExposureError` to handle
    /// - parameter delivery: `PersistedAnalytics` that failed to deliver.
    private func process(error: ExposureError, delivery: PersistedAnalytics) {
        if case let .exposureResponse(reason: reason) = error, (reason.httpCode == 401 && reason.message == "INVALID_SESSION_TOKEN") {
            // There is still a possbility to resend the persisted batch. If the currently active analytics batch contain a sessionToken with an accountId that matches the persisted batch, we can use that sessionToken to send the payload
            if let currentAccountId = currentBatch.sessionToken.accountId,
                let persistedAccountId = delivery.batch.sessionToken.accountId,
                currentAccountId == persistedAccountId {
                let updatedBatch = AnalyticsBatch(sessionToken: currentBatch.sessionToken,
                                                  environment: delivery.batch.environment,
                                                  playToken: delivery.batch.sessionId,
                                                  payload: delivery.batch.payload)
                
                networkHandler.deliver(batch: updatedBatch,
                                       clockOffset: configuration.synchronizedClockOffset) { [weak self] response, error in
                        if let secondaryError = error {
                            print("🚨 Failed to deliver persisted payload on new sessionToken:",secondaryError.message)
                            print("⚠️ Undelivered persisted payload will remain on disk")
                        }
                        else if response != nil {
                            print("✅ Delivered persisted payload on new sessionToken")
                            self?.process(delivery: delivery)
                        }
                }
            }
        }
        else {
            print("🚨 Failed to deliver persisted payload:",error.message)
            print("⚠️ Undelivered persisted payload will remain on disk")
        }
    }
    
    /// Once persisted analytics batches reaches a `time limit`, they are considered stale and should be removed
    private func clearStaleAnalytics() {
        do {
            let timelimit = Date().millisecondsSince1970 - configuration.analyticsStorageLimit
            try persister.clearAll(olderThan: timelimit)
        }
        catch {
            print("🚨 Failed to clear stale, persisted analytics events:",error.localizedDescription)
            print("⚠️ No stale events will be removed from disk")
        }
    }
}

extension Dispatcher {
    /// Specifies dispatcher behavior.
    fileprivate struct Configuration {
        /// Difference between device time and server time, in milliseconds
        fileprivate var synchronizedClockOffset: Int64?
        
        /// Time the last dispatch was sent, in unix epoch time
        fileprivate var lastDispatchTimestamp: Int64?
        
        /// Time between each successive contact with the server, in milliseconds
        fileprivate var reportingTimeinterval: Int64
        
        /// Indicates wether heartbeats should be sent periodically if no analytics events are stored
        fileprivate var heartbeatsEnabled: Bool
        
        /// Determines how long persisted analytics batches should be kept in storage.
        ///
        /// in milliseconds
        fileprivate let analyticsStorageLimit: Int64 = 60 * 60 * 24 * 30 * 1000 /// 30 days
        
        fileprivate init(synchronizedClockOffset: Int64? = nil, lastDispatchTimestamp: Int64? = nil, reportingTimeinterval: Int64 = 60000, heartbeatsEnabled: Bool = false) {
            self.synchronizedClockOffset = synchronizedClockOffset
            self.lastDispatchTimestamp = lastDispatchTimestamp
            self.reportingTimeinterval = reportingTimeinterval
            self.heartbeatsEnabled = heartbeatsEnabled
        }
    }
    
    /// Indicates if `HeartBeat`s has been enabled. If so, the dispatcher will continuously deliver heartbeats to the `EventSink` endpoint.
    internal var heartbeatsEnabled: Bool {
        return configuration.heartbeatsEnabled
    }
    
    /// With heartbeats enabled, the `dispatcher` will deliver periodic messages to the server letting it know the session is still active. This is important for a number of reasons, including but not limited to *concurrent streams*.
    ///
    /// - important: Enabling `Heartbeats` will start the *flush trigger* (if not already started).
    ///
    /// - parameter enabled: `true` if hearbeats should be enabled, `false` otherwise.
    public func heartbeat(enabled: Bool) {
        configuration.heartbeatsEnabled = enabled
        if enabled && flushTrigger == nil {
            flushTrigger(enabled: true)
        }
    }
}

extension Dispatcher {
    /// Synchronizes dispatch environment with the server. This should be done atleast once (preferably on initialization) but may occur on multiple occations.
    /// 
    /// - parameter callback: a closure returning an `ExposureError` if the call failed, or `nil` if successful.
    internal func synchronize(callback: @escaping (ExposureError?)  -> Void) {
        let clientStart = Date().millisecondsSince1970
        
        networkHandler.initialize(using: currentBatch.environment) { [weak self] response, error in
                if let error = error {
                    callback(error)
                    return
                }

                let clientEnd = Date().millisecondsSince1970
                guard let success = response else {
                    callback(nil)
                    return
                }
                
                if let receivedTime = success.receivedTime,
                    let repliedTime = success.repliedTime {

                    self?.configuration.synchronizedClockOffset = (clientEnd - repliedTime + clientStart - receivedTime) / 2
                }

                if let reportingInterval = success.settings?.secondsUntilNextReport {
                    self?.configuration.reportingTimeinterval = Int64(reportingInterval) * 1000
                }
                callback(nil)
        }
    }
}

extension Dispatcher {
    /// Adds an analytics event to the currently active batch.
    /// Once that is done, the buffer will be flushed as nessescary.
    /// 
    /// - parameter event: analytics event to dispatch
    public func enqueue(event: AnalyticsEvent) {
        appendToCurrentBatch(event: event)
        flush(forced: false)
    }
    
    /// Appends the specified `event` to the currently active `AnalyticsBatch`
    fileprivate func appendToCurrentBatch(event: AnalyticsEvent) {
        var current = currentBatch.payload
        current.append(event)
        
        // TODO: Replace AnalyticsPayload with AnalyticsEvent
        
        currentBatch = AnalyticsBatch(sessionToken: currentBatch.sessionToken,
                                      environment: currentBatch.environment,
                                      playToken: currentBatch.sessionId,
                                      payload: current)
    }
}
