//
//  EventList.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2019-09-13.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

/// `Event` response contains *ApiEventList* information for a set of Events.
public struct EventList : Decodable {
    public let totalCount: Int?
    public let pageSize: Int?
    public let pageNumber: Int?
    public let items: [Event]?
}
