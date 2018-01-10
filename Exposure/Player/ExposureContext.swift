//
//  ExposureContext.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

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
    
    /// Service that handles synchronization of local device time with server time
    public let monotonicTimeService: MonotonicTimeService
    
    public init(environment: Environment, sessionToken: SessionToken) {
        self.environment = environment
        self.sessionToken = sessionToken
        self.monotonicTimeService = MonotonicTimeService(environment: environment)
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
