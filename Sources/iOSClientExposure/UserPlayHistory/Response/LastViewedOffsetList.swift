//
//  LastViewedOffsetList.swift
//  Exposure-iOS
//
//  Created by Johnny Sundblom on 2020-02-17.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

/// Response receieved from the UserPlayHistory offset endpoint.
public struct LastViewedOffsetList: Decodable {
    public let items: [LastViewedOffset]?
}
