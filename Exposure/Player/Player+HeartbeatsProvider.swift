//
//  Player+HeartbeatsProvider.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-08.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

extension Player: HeartbeatsProvider {
    internal struct PlayerHeartbeatData: HeartbeatData {
        let timestamp: Int64
        let payload: [String: Any]
    }
    
    public func requestHeatbeat() -> HeartbeatData {
        return PlayerHeartbeatData(timestamp: Date().millisecondsSince1970, payload: ["OffsetTime": self.currentTime])
    }
}
