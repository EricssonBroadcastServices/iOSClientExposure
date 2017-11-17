//
//  CustomerConfigFileRequest.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

/// *Exposure* endpoint integration for *CustomerConfig.File*.
public struct CustomerConfigFileRequest: ExposureType {
  public typealias Response = CustomerConfig.File

  /// Environment to use
  public let environment: Environment

  /// File to fetch
  public let fileName: String

  public init(fileName: String, environment: Environment) {
    self.fileName = fileName
    self.environment = environment
  }

  public var endpointUrl: String {
    return environment.apiUrl + "/config/" + fileName
  }

  public var parameters: [String: Any]? {
    return nil
  }

  public var headers: [String: String]? {
    return nil
  }
}

extension CustomerConfigFileRequest {
  /// `CustomerConfigFile` request is specified as a `.get`
  ///
  /// - returns: `ExposureRequest` with request specific data
  public func request() -> ExposureRequest<Response> {
    return request(.get)
  }
}
