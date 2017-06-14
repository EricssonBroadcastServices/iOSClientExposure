//
//  FetchEpg.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Epg {
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
}

extension Epg {
    public func list() -> FetchEpgList {
        return FetchEpgList(environment: environment)
    }
}
