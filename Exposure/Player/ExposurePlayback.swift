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
    public func stream(playback entitlement: PlaybackEntitlement) {
        do {
            guard let mediaLocator = entitlement.mediaLocator else {
                onError(self, PlayerError.asset(reason: .missingMediaUrl))
                return
            }
            
            let requester = EMPFairplayRequester(entitlement: entitlement)
            currentAsset = try MediaAsset(mediaLocator: mediaLocator, fairplayRequester: requester)
            onCreated(self)
            
            currentAsset?.prepare(loading: [.duration, .tracks, .playable]) { [unowned self] error in
                guard error == nil else {
                    self.onError(self, error!)
                    return
                }
                
                self.onInitCompleted(self)
                
                self.readyPlayback(with: self.currentAsset!)
            }
        }
        catch {
            if let playerError = error as? PlayerError {
                onError(self, playerError)
            }
            else {
                onError(self, PlayerError.generalError(error: error))
            }
        }
    }
}
