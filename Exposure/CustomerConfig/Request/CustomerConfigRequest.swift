//
//  CustomerConfigRequest.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for *CustomerConfig*.
public struct CustomerConfigRequest: ExposureType {
  public typealias Response = CustomerConfig

  /// Environment to use
  public let environment: Environment

  public init(environment: Environment) {
    self.environment = environment
  }

  public var endpointUrl: String {
    return environment.apiUrl + "/config"
  }

  public var parameters: [String: Any]? {
    return nil
  }

  public var headers: [String: String]? {
    return nil
  }
}

extension CustomerConfigRequest {
  /// `CustomerConfig` request is specified as a `.get`
  ///
  /// - returns: `ExposureRequest` with request specific data
  public func request() -> ExposureRequest<Response> {
    return request(.get)
  }

  public func fetchFile(withName name: String) -> CustomerConfigFileRequest {
    return CustomerConfigFileRequest(fileName: name,
                                     environment: environment)
  }
}
