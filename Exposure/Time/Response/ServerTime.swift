//
//  ServerTime.swift
//  Exposure
//
//  Created by Hui Wang on 2017-04-04.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Response struct detailing *server time*
public struct ServerTime: Decodable {
    /// The number of milliseconds since epoch.
    public let epochMillis: UInt64?
    
    /// Current time as ISO 8601. In UTC.
    public let iso8601:String?
}

