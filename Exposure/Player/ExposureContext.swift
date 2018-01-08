//
//  ExposureContext.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player


public class MonotonicTimeService {
    internal let refreshInterval: Int
    internal let exposureDownInterval: Int
    
    
    public init(environment: Environment, refreshInterval: Int = 60000 * 30, errorRetryInterval: Int = 1000) {
        self.environment = environment
        self.refreshInterval = refreshInterval
        self.exposureDownInterval = errorRetryInterval
        
        let queue = DispatchQueue(label: "com.emp.exposure.monotonicTimeService",
                                  qos: DispatchQoS.background,
                                  attributes: DispatchQueue.Attributes.concurrent)
        self.queue = queue
        timer = DispatchSource.makeTimerSource(queue: queue)
        
    }
    
    deinit {
        timer.setEventHandler{}
        timer.cancel()
    }
    
    private var environment: Environment
    private let queue: DispatchQueue
    private let timer: DispatchSourceTimer
    
    
    private var state: State = .notStarted
    private enum State {
        case notStarted
        case running(latest: Difference?)
        case retrying(previous: Difference?)
        
        var currentDifference: Difference? {
            switch self {
            case .notStarted: return nil
            case .running(latest: let latest): return latest
            case .retrying(previous: let previous): return previous
            }
        }
    }
    
    internal struct Difference {
        internal var serverStartTime: Int64
        internal var localStartTime: Int64
        
        var monotonicTime: Int64 {
            return serverStartTime + Date().millisecondsSince1970 - localStartTime
        }
    }
    
    public var currentTime: Int64? {
        switch state {
        case .notStarted:
            startTimer{ _ in }
            return nil
        case .running(latest: let difference):
            return difference?.monotonicTime
        case .retrying(previous: let difference):
            return difference?.monotonicTime
        }
    }
    
    public func currentTime(forceRefresh: Bool = true, callback: @escaping (Int64?) -> Void) {
        switch state {
        case .notStarted:
            startTimer(callback: callback)
        case .running(latest: let latest):
            if forceRefresh {
                fetchServerTime(callback: callback)
            }
            else {
                callback(latest?.monotonicTime)
            }
        case .retrying(previous: let previous):
            if forceRefresh {
                fetchServerTime(callback: callback)
            }
            else {
                callback(previous?.monotonicTime)
            }
        }
    }
    
    private func startTimer(callback: @escaping (Int64?) -> Void) {
        timer.scheduleOneshot(deadline: .now(), leeway: .seconds(1))
        
        timer.setEventHandler{ [weak self] in
            guard let `self` = self else { return }
            self.fetchServerTime(callback: callback)
        }
        
        state = .running(latest: nil)
        timer.resume()
    }
    
    private func fetchServerTime(callback: @escaping (Int64?) -> Void) {
        FetchServerTime(environment: self.environment)
            .request()
            .response{ [weak self] in
                guard let `self` = self else { return }
                if let value = $0.value?.epochMillis {
                    self.queue.sync {
                        self.state = .running(latest: Difference(serverStartTime: Int64(value), localStartTime: Date().millisecondsSince1970))
                        self.timer.scheduleOneshot(deadline: .now() + .milliseconds(self.refreshInterval), leeway: .seconds(1))
                        callback(self.state.currentDifference?.monotonicTime)
                        print("Fired Refresh")
                    }
                }
                else if $0.error != nil {
                    self.queue.sync {
                        self.state = .retrying(previous: self.state.currentDifference)
                        self.timer.scheduleOneshot(deadline: .now() + .milliseconds(self.exposureDownInterval), leeway: .seconds(1))
                        print("Error during refresh. Rescheduling")
                        callback(self.state.currentDifference?.monotonicTime)
                    }
                }
        }
    }
}

//internal protocol MonotonicTimeNetworkHandler {
//    func fetchServerTime(using environment: Environment, callback: @escaping (ServerTime?, ExposureError?) -> Void)
//}



/// Defines the `MediaContext` to be used when contacting *Exposure*.
///
/// Allows retrieval and processing of `PlaybackEntitlement`s through designated extensions on `Player`.
public class ExposureContext: MediaContext {
    /// *Exposure* related errors
    public typealias ContextError = ExposureError
    
    /// Source object encapsulating a fetched `PlaybackEntitlement`
    public typealias Source = ExposureSource
    
    /// Generators used to produce the relevant `AnalyticsProvider`
    public var analyticsGenerators: [(Source?) -> AnalyticsProvider] = []
    
    /// Exposure environment used for the active session.
    public let environment: Environment
    
    /// Token identifying the active session.
    public let sessionToken: SessionToken
    
    ///
    
    
    public init(environment: Environment, sessionToken: SessionToken) {
        self.environment = environment
        self.sessionToken = sessionToken
    }
    
    deinit {
        print("ExposureContext deinit")
    }
}

extension ExposureContext {
    /// Helper method producing an `ExposureSource` for *vod* playback using the supplied assetId.
    ///
    /// - parameter assetId: *EMP* asset identifier for the *vod* asset
    /// - parameter callback: Closure called on request completion
    internal func request(vod assetId: String, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        Entitlement(environment: environment,
                    sessionToken: sessionToken)
            .vod(assetId: assetId)
            .request()
            .validate()
            .response{ [weak self] in
                self?.handle(response: $0, callback: callback)
        }
    }
    
    /// Helper method producing an `ExposureSource` for *live* playback using the supplied assetId.
    ///
    /// - parameter channelId: *EMP* asset identifier for the *live* asset
    /// - parameter callback: Closure called on request completion
    internal func request(live channelId: String, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        let entitlement = Entitlement(environment: environment,
                                      sessionToken: sessionToken)
            .live(channelId: channelId)
        
        entitlement
            .request()
            .validate()
            .response{ [weak self] in
                if let error = $0.error {
                    // Workaround until EMP-10023 is fixed
                    if case let .exposureResponse(reason: reason) = error, (reason.httpCode == 403 && reason.message == "NO_MEDIA_ON_CHANNEL") {
                        entitlement
                            .use(drm: .unencrypted)
                            .request()
                            .validate()
                            .response{ [weak self] in
                                self?.handle(response: $0, callback: callback)
                        }
                    }
                    else {
                        callback(nil,error)
                    }
                }
                else if let entitlement = $0.value {
                    callback(ExposureSource(entitlement: entitlement), nil)
                }
        }
    }
    
    /// Helper method producing an `ExposureSource` for *program* playback using the supplied assetId.
    ///
    /// - parameter programId: *EMP* asset identifier for the program on the specified channel
    /// - parameter channelId: *EMP* asset identifier for the channel
    /// - parameter callback: Closure called on request completion
    internal func request(program programId: String, channelId: String, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        let entitlement = Entitlement(environment: environment,
                                      sessionToken: sessionToken)
            .program(programId: programId,
                     channelId: channelId)
        
        entitlement
            .request()
            .validate()
            .response{ [weak self] in
                if let error = $0.error {
                    // Workaround until EMP-10023 is fixed
                    if case let .exposureResponse(reason: reason) = error, (reason.httpCode == 403 && reason.message == "NO_MEDIA_FOR_PROGRAM") {
                        entitlement
                            .use(drm: .unencrypted)
                            .request()
                            .validate()
                            .response{ [weak self] in
                                self?.handle(response: $0, callback: callback)
                        }
                    }
                    else {
                        callback(nil,error)
                    }
                }
                else if let entitlement = $0.value {
                    callback(ExposureSource(entitlement: entitlement), nil)
                }
        }
    }
    
    /// Transforms the response into the requested `MediaSource` if successful, errors otherwise.
    private func handle(response: ExposureResponse<PlaybackEntitlement>, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        if let entitlement = response.value {
            callback(ExposureSource(entitlement: entitlement), nil)
        }
        else {
            callback(nil,response.error!)
        }
    }
}
