//
//  ExposureSource.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

public protocol Playable {
    var assetId: String { get }
    
    func prepareSource(environment: Environment, sessionToken: SessionToken, callback: @escaping (ExposureSource?, ExposureError?) -> Void)
}

public protocol ChannelPlayConvertible {
    var channelPlayable: ChannelPlayable { get }
}

extension Asset: ChannelPlayConvertible {
    public var channelPlayable: ChannelPlayable {
        return ChannelPlayable(assetId: assetId)
    }
}

public protocol AssetPlayConvertible {
    var assetPlayable: AssetPlayable { get }
}

extension Asset: AssetPlayConvertible {
    public var assetPlayable: AssetPlayable {
        return AssetPlayable(assetId: assetId)
    }
}


public protocol ProgramServiceEnabled {
    var programServiceChannelId: String { get }
}

public protocol ProgramPlayConvertible {
    var programPlayable: ProgramPlayable { get }
}

extension Program: ProgramPlayConvertible {
    public var programPlayable: ProgramPlayable {
        return ProgramPlayable(assetId: assetId, channelId: channelId)
    }
}

public struct ProgramPlayable: Playable {
    public let assetId: String
    public let channelId: String
}

extension ProgramPlayable {
    /// Helper method producing an `ProgramSource` for *program* playback using the supplied `environment` and `sessionToken`
    ///
    /// - parameter environment: `Environment` to request the Source from
    /// - parameter sessionToken: `SessionToken` validating the user
    /// - parameter callback: Closure called on request completion
    public func prepareSource(environment: Environment, sessionToken: SessionToken, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        let entitlement = Entitlement(environment: environment,
                                      sessionToken: sessionToken)
            .program(programId: assetId,
                     channelId: channelId)
        
        entitlement
            .request()
            .response{
                if let error = $0.error {
                    // Workaround until EMP-10023 is fixed
                    if case let .exposureResponse(reason: reason) = error, (reason.httpCode == 403 && reason.message == "NO_MEDIA_FOR_PROGRAM") {
                        entitlement
                            .use(drm: .unencrypted)
                            .request()
                            .response{
                                if let entitlement = $0.value {
                                    callback(ProgramSource(entitlement: entitlement, assetId: self.assetId, channelId: self.channelId), nil)
                                }
                                else {
                                    callback(nil,$0.error!)
                                }
                        }
                    }
                    else {
                        callback(nil,error)
                    }
                }
                else if let entitlement = $0.value {
                    callback(ProgramSource(entitlement: entitlement, assetId: self.assetId, channelId: self.channelId), nil)
                }
        }
    }
}

public struct ChannelPlayable: Playable {
    public var assetId: String
}

extension ChannelPlayable {
    /// Helper method producing an `ChannelSource` for *live* playback using the supplied assetId.
    ///
    /// - parameter environment: `Environment` to request the Source from
    /// - parameter sessionToken: `SessionToken` validating the user
    /// - parameter callback: Closure called on request completion
    public func prepareSource(environment: Environment, sessionToken: SessionToken, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        prepareChannelSource(environment: environment, sessionToken: sessionToken, callback: callback)
    }
    
    internal func prepareChannelSource(environment: Environment, sessionToken: SessionToken, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        let entitlement = Entitlement(environment: environment,
                                      sessionToken: sessionToken)
            .live(channelId: assetId)
        
        entitlement
            .request()
            .validate()
            .response{
                if let error = $0.error {
                    // Workaround until EMP-10023 is fixed
                    if case let .exposureResponse(reason: reason) = error, (reason.httpCode == 403 && reason.message == "NO_MEDIA_ON_CHANNEL") {
                        entitlement
                            .use(drm: .unencrypted)
                            .request()
                            .validate()
                            .response{
                                if let entitlement = $0.value {
                                    callback(ChannelSource(entitlement: entitlement, assetId: self.assetId), nil)
                                }
                                else {
                                    callback(nil,$0.error!)
                                }
                        }
                    }
                    else {
                        callback(nil,error)
                    }
                }
                else if let entitlement = $0.value {
                    callback(ChannelSource(entitlement: entitlement, assetId: self.assetId), nil)
                }
        }
    }
}

public struct AssetPlayable: Playable {
    public var assetId: String
}

extension AssetPlayable {
    /// Helper method producing an `AssetSource` for *vod* playback using the supplied assetId.
    ///
    /// - parameter environment: `Environment` to request the Source from
    /// - parameter sessionToken: `SessionToken` validating the user
    /// - parameter callback: Closure called on request completion
    public func prepareSource(environment: Environment, sessionToken: SessionToken, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        prepareAssetSource(environment: environment, sessionToken: sessionToken, callback: callback)
    }
    
    internal func prepareAssetSource(environment: Environment, sessionToken: SessionToken, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        Entitlement(environment: environment,
                    sessionToken: sessionToken)
            .vod(assetId: assetId)
            .request()
            .validate()
            .response{
                if let entitlement = $0.value {
                    callback(AssetSource(entitlement: entitlement, assetId: self.assetId), nil)
                }
                else {
                    callback(nil,$0.error!)
                }
        }
    }
}

public class ProgramSource: ExposureSource {
    public let channelId: String
    public init(entitlement: PlaybackEntitlement, assetId: String, channelId: String) {
        self.channelId = channelId
        super.init(entitlement: entitlement, assetId: assetId)
    }
    internal override func handleStartTime(for tech: HLSNative<ExposureContext>, in context: ExposureContext) {
        switch context.playbackProperties.playFrom {
        case .defaultBehaviour:
            defaultStartTime(for: tech, in: context)
        case .beginning:
            if isUnifiedPackager {
                // Start from  program start (using a t-param with stream start at program start)
                tech.startOffset(atPosition: 0 + ExposureSource.segmentLength)
            }
            else {
                // Relies on traditional vod manifest
                tech.startOffset(atPosition: nil)
            }
        case .bookmark:
            // Use *EMP* supplied bookmark
            if let offset = entitlement.lastViewedOffset {
                if isUnifiedPackager {
                    tech.startOffset(atPosition: Int64(offset))
                    // Wallclock timestamp
                    //                    tech.startOffset(atTime: Int64(offset))
                }
                else {
                    // 0 based offset
                    tech.startOffset(atPosition: Int64(offset))
                }
            }
            else {
                defaultStartTime(for: tech, in: context)
            }
        case .custom(offset: let offset):
            // Use the custom supplied offset
            if isUnifiedPackager {
                // Wallclock timestamp
                tech.startOffset(atTime: offset)
            }
            else {
                // 0 based offset
                tech.startOffset(atPosition: offset)
            }
        }
    }
    
    private func defaultStartTime(for tech: HLSNative<ExposureContext>, in context: ExposureContext) {
        if isUnifiedPackager {
            if entitlement.live {
                // Start from the live edge (relying on live manifest)
                tech.startOffset(atTime: nil)
            }
            else {
                // Start from program start (using a t-param with stream start at program start)
                tech.startOffset(atPosition: 0 + ExposureSource.segmentLength)
            }
        }
        else {
            // Default is to start from program start (relying on traditional vod manifest)
            tech.startOffset(atPosition: nil)
        }
    }
}

extension ProgramSource: ProgramServiceEnabled {
    public var programServiceChannelId: String {
        return channelId
    }
}

public class ChannelSource: ExposureSource {
    internal override func handleStartTime(for tech: HLSNative<ExposureContext>, in context: ExposureContext) {
        
        switch context.playbackProperties.playFrom {
        case .defaultBehaviour:
            defaultStartTime(for: tech, in: context)
        case .beginning:
            if isUnifiedPackager {
                // Start from  program start (using a t-param with stream start at program start)
                tech.startOffset(atPosition: 0 + ExposureSource.segmentLength)
            }
            else {
                // Relies on traditional vod manifest
                tech.startOffset(atPosition: nil)
            }
        case .bookmark:
            // Use *EMP* supplied bookmark
            if let offset = entitlement.lastViewedOffset {
                if isUnifiedPackager {
                    // Wallclock timestamp
                    tech.startOffset(atTime: Int64(offset))
                }
                else {
                    // 0 based offset
                    tech.startOffset(atPosition: Int64(offset))
                }
            }
            else {
                defaultStartTime(for: tech, in: context)
            }
        case .custom(offset: let offset):
            // Use the custom supplied offset
            if isUnifiedPackager {
                // Wallclock timestamp
                tech.startOffset(atTime: offset)
            }
            else {
                // 0 based offset
                tech.startOffset(atPosition: offset)
            }
        }
    }
    
    private func defaultStartTime(for tech: HLSNative<ExposureContext>, in context: ExposureContext) {
        if isUnifiedPackager {
            // Start from the live edge (relying on live manifest)
            tech.startOffset(atTime: nil)
        }
        else {
            // Default is to start from  live edge (relying on live manifest)
            tech.startOffset(atPosition: nil)
        }
    }
}

extension ChannelSource: ProgramServiceEnabled {
    public var programServiceChannelId: String {
        return assetId
    }
}

public class AssetSource: ExposureSource {
    internal override func handleStartTime(for tech: HLSNative<ExposureContext>, in context: ExposureContext) {
        switch context.playbackProperties.playFrom {
        case .defaultBehaviour:
            defaultStartTime(for: tech, in: context)
        case .beginning:
            // Start from offset 0
            tech.startOffset(atPosition: 0)
        case .bookmark:
            // Use *EMP* supplied bookmark, else default behaviour (ie nil bookmark)
            if let offset = entitlement.lastViewedOffset {
                tech.startOffset(atPosition: Int64(offset))
            }
            else {
                defaultStartTime(for: tech, in: context)
            }
        case .custom(offset: let offset):
            // Use the custom supplied offset
            tech.startOffset(atPosition: offset)
        }
    }
    
    private func defaultStartTime(for tech: HLSNative<ExposureContext>, in context: ExposureContext) {
        // Default is to start from the beginning
        tech.startOffset(atPosition: nil)
    }
}

/// `MediaSource` object defining the response from a successful playback request in the `ExposureContext`
public class ExposureSource: MediaSource {
    internal static let segmentLength: Int64 = 6000
    
    /// Connector used to process Analytics Events
    public var analyticsConnector: AnalyticsConnector = PassThroughConnector()
    
    /// Unique playSession Id
    public var playSessionId: String {
        return entitlement.playSessionId
    }
    
    /// Media locator
    public var url: URL {
        return entitlement.mediaLocator
    }
    
    /// Entitlement related to this playback request.
    public let entitlement: PlaybackEntitlement
    
    /// *EMP* assetId
    public let assetId: String
    
    public init(entitlement: PlaybackEntitlement, assetId: String) {
        self.entitlement = entitlement
        self.assetId = assetId
    }
    
    deinit {
        print("ExposureSource deinit")
    }
    
    internal func handleStartTime(for tech: HLSNative<ExposureContext>, in context: ExposureContext) {
        
    }
}

extension ExposureSource {
    /// Checks if the manifest comes from the *Unified Packager*
    internal var isUnifiedPackager: Bool {
        return entitlement
            .mediaLocator
            .pathComponents
            .reduce(false) { $0 || $1.contains(".isml") }
    }
}

extension ExposureSource {
    private enum UnifiedPackageParams: String {
        case dvrWindowLength = "dvr_window_length"
        case timeshift = "time_shift"
        case tParam = "t"
    }
    
    internal var tParameter: (Int64, Int64?)? {
        if let param:String = entitlement
            .mediaLocator
            .queryParam(for: UnifiedPackageParams.tParam.rawValue) {
            let formatter = Program.exposureDateFormatter
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            if let ms = formatter.date(from: param)?.millisecondsSince1970 {
                return (ms, nil)
            }
            return nil
        }
        return nil
    }
    
    /// Retrieves the *DVR* window
    internal var dvrWindowLength: Int64? {
        return entitlement
            .mediaLocator
            .queryParam(for: UnifiedPackageParams.dvrWindowLength.rawValue)
    }
    
    /// Specifies the timeshift delay *in seconds* (if available).
    ///
    /// Negative timeshift delays will be clamped at zero.
    ///
    /// - note: Requires a *Unified Packager* sourced stream.
    internal var timeshiftDelay: Int64? {
        return entitlement
            .mediaLocator
            .queryParam(for: UnifiedPackageParams.timeshift.rawValue)
    }
}

extension ExposureSource: HLSNativeConfigurable {
    public var hlsNativeConfiguration: HLSNativeConfiguration {
        let drmAgent = ExposureStreamFairplayRequester(entitlement: entitlement)
        return HLSNativeConfiguration(url: url,
                                      playSessionId: entitlement.playSessionId,
                                      drm: drmAgent)
    }
}
