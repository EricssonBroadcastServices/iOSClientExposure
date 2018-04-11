//
//  LastViewedList.swift
//  Exposure-iOS
//
//  Created by Fredrik Sjöberg on 2018-03-31.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

/// Response receieved from the UserPlayHistory endpoint.
public struct LastViewedList: Decodable {
    /// List of assets the user has played before
    public let items: [Asset]
}

