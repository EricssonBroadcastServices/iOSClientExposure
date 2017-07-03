//
//  ExposurePlayback.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

public protocol ExposurePlayback {
    func stream(playback entitlement: PlaybackEntitlement)
    func offline(playback entitlement: PlaybackEntitlement)
}

extension Player {
    // MOVED TO EXPOSURE
    public func stream(playback entitlement: PlaybackEntitlement) throws {
        guard let mediaLocator = entitlement.mediaLocator else {
            throw PlayerError.asset(reason: .missingMediaUrl)
        }
        
        let requester = ExposureFairplayRequester(entitlement: entitlement)
        
        stream(url: mediaLocator, using: requester)
    }
}
