//
//  ExposureSource.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

/// `MediaSource` object defining the response from a successful playback request in the `ExposureContext`
public class ExposureSource: MediaSource {
    /// Connector used to process Analytics Events
    public var analyticsConnector: AnalyticsConnector = PassThroughConnector()
    
    /// Unique playSession Id
    public var playSessionId: String {
        return entitlement.playSessionId
    }
    
    /// Media locator
    public var url: URL {
        guard isUnifiedPackager else {
            return entitlement.mediaLocator
        }
        return unifiedPackagerUrl
    }
    
    /// Entitlement related to this playback request.
    public let entitlement: PlaybackEntitlement
    
    /// Tracks the timeshift setting
    fileprivate var timeshiftSetting: TimeshiftSetting = .entitlement
    fileprivate enum TimeshiftSetting {
        /// Specifies timeshift will be provided by `entitlement`
        case entitlement
        
        /// User action has changed the `entitlement` provided timeshift delay
        case userSpecified(value: Int64)
    }
    
    internal init(entitlement: PlaybackEntitlement) {
        self.entitlement = entitlement
    }
    
    deinit {
        print("ExposureSource deinit")
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
    
    /// Modifies `PlaybackEntitlement`s `mediaLocator` with any user specified *timeshift delay* and returns an updated manifest `URL` that can be used to reload the source.
    fileprivate var unifiedPackagerUrl: URL {
        switch timeshiftSetting {
        case .entitlement:
            return entitlement.mediaLocator
        case .userSpecified(value: let value):
            return entitlement.mediaLocator.queryParam(key: UnifiedPackageParams.timeshift.rawValue, value: "\(value)") ?? entitlement.mediaLocator
        }
    }
    
    internal var tParam: (Int64, Int64?)? {
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
        get {
            switch timeshiftSetting {
            case .entitlement:
                return entitlement
                    .mediaLocator
                    .queryParam(for: UnifiedPackageParams.timeshift.rawValue)
            case .userSpecified(value: let value):
                return value
            }
        }
        set {
            if let value = newValue {
                timeshiftSetting = .userSpecified(value: max(0, value))
            }
            else {
                timeshiftSetting = .entitlement
            }
        }
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
