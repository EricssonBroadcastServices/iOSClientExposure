//
//  FetchCarouselList.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct FetchCarouselList: Exposure {
  public typealias Response = CarouselList

  public var parameters: [String: Any] {
    return [:] //queryParams
  }

  public var headers: [String: String]? {
    return nil //userDataFilter.sessionToken?.authorizationHeader
  }

  public let environment: Environment
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
  public func request() -> ExposureRequest {
    return request(.get)
  }
}
