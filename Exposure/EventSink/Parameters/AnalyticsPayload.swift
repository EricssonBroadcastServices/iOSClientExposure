//
//  AnalyticsPayload.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public protocol AnalyticsPayload {
    var payload: [String: Any] { get }
}
