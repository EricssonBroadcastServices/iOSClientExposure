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
    func stream(vod entitlement: PlaybackEntitlement) throws
    func stream(catchup entitlement: PlaybackEntitlement) throws
    func stream(live entitlement: PlaybackEntitlement) throws
    func offline(playback entitlement: PlaybackEntitlement) throws
}

extension Player: ExposurePlayback {
    public func stream(vod entitlement: PlaybackEntitlement) throws {
        guard let mediaLocator = entitlement.mediaLocator else {
            throw PlayerError.asset(reason: .missingMediaUrl)
        }
        
        let requester = ExposureFairplayRequester(entitlement: entitlement)
        
        stream(url: mediaLocator, using: requester)
    }
    
    public func stream(catchup entitlement: PlaybackEntitlement) throws {
        guard let mediaLocator = entitlement.mediaLocator else {
            throw PlayerError.asset(reason: .missingMediaUrl)
        }
        
        let requester = ExposureFairplayRequester(entitlement: entitlement)
        
        stream(url: mediaLocator, using: requester)
    }
    
    public func stream(live entitlement: PlaybackEntitlement) throws {
        guard let mediaLocator = entitlement.mediaLocator else {
            throw PlayerError.asset(reason: .missingMediaUrl)
        }
        
        let requester = ExposureFairplayRequester(entitlement: entitlement)
        
        stream(url: mediaLocator, using: requester)
    }
    
    public func offline(playback entitlement: PlaybackEntitlement) throws {
        
    }
}
