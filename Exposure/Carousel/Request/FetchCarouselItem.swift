//
//  FetchCarouselItem.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for *CarouselList*.
public struct FetchCarouselItem: ExposureType {
    public typealias Response = CarouselItem
    
    public var parameters: [String: Any]? {
        return nil
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public let environment: Environment
    
    /// The group id for the carousel
    public let groupId: String
    
    // The id for the carousel
    public let carouselId: String
    
    internal init(groupId: String, carouselId: String, environment: Environment) {
        self.groupId = groupId
        self.environment = environment
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/carouselgroup/" + groupId + "/carousel/" + carouselId
    }
}

extension FetchCarouselItem {
    /// `FetchCarouselList` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.get)
    }
}
