//
//  HLSNative+ExposureContext+MediaPlayback.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-01-15.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation
import Exposure
import Player

// MARK: - MediaPlayback overrides
extension Player where Tech == HLSNative<ExposureContext> {
    /// Should perform seeking to `timeInterval` as specified in relation to the current `wallclock` time.
    ///
    /// Seeking will fail if the supplied date is outside the range or if the content is not associated with a range of dates.
    ///
    /// - Parameter timeInterval: target timestamp in unix epoch time (milliseconds)
    public func seek(toTime timeInterval: Int64) {
        guard let currentSource = tech.currentSource, currentSource.isUnifiedPackager else {
            return tech.seek(toTime: timeInterval)
        }
        
    }
}
