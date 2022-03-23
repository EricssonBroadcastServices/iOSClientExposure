//
//  FetchCarousel.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for *CarouselList*.
public struct FetchCarousel {
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
}

extension FetchCarousel {
    public func group(id: String) -> FetchCarouselList {
        return FetchCarouselList(groupId: id,
                                 environment: environment)
    }
    
    public func group(id: String, carousel carouselId: String) -> FetchCarouselItem {
        return FetchCarouselItem(groupId: id,
                                 carouselId: carouselId,
                                 environment: environment)
    }
}
