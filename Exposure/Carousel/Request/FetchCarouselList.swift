//
//  FetchCarouselList.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for *CarouselList*.
public struct FetchCarouselList: ExposureType {
  public typealias Response = CarouselList

  public var parameters: [String: Any]? {
    return nil
  }

  public var headers: [String: String]? {
    return nil
  }

  public let environment: Environment

  /// The group id for the carousel
  public let groupId: String

  public init(groupId: String, environment: Environment) {
    self.groupId = groupId
    self.environment = environment
  }

  public var endpointUrl: String {
    return environment.apiUrl + "/carouselgroup/" + groupId
  }

}

extension FetchCarouselList {
  /// `FetchCarouselList` request is specified as a `.get`
  ///
  /// - returns: `ExposureRequest` with request specific data
  public func request() -> ExposureRequest {
    return request(.get)
  }
}

