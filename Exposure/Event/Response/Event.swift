//
//  Event.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2019-09-13.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

/// `Event` contains *Event* information for a one specific event.
public struct Event : Codable {
    public let assetId: String?
    public let startTime: String?
    public let endTime: String?
    public let asset: Asset?
}


