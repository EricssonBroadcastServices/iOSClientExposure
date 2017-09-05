//
//  ExposureResponseMessage.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

/// *Exposure* may signal errors by transmitting a response message with a related `http` status code. Validating the related `ExposureRequest` is therefore good practice.
///
/// ```swift
/// Entitlement(environment: myEnv,
///             sessionToken: aToken)
///     .vod(assetId)
///     .request()
///     .validate(statusCode: 200..<399) // Will throw ExposureError on code 400
///     .response{ (exposureResponse: ExposureResponse<PlaybackEntitlement>) in
///         if case let .exposureResponse(reason: reason) = exposureResponse.error {
///             // Handle Exposure related error message
///         }
///     }
/// ```
///
/// * 400 `INVALID_JSON` If JSON received is not valid JSON.
/// * 401 `NO_SESSION_TOKEN` If the session token is missing.
/// * 403 `FORBIDDEN` If this business unit has been configured to require server to server authentication, but it is not valid.
public struct ExposureResponseMessage: ExposureConvertible {
    /// `http` code returned by *Exposure*
    public let httpCode: Int
    
    /// Related error message returned by *Exposure*
    public let message: String
    
    public init?(json: Any) {
        let actualJSON = SwiftyJSON.JSON(json)
        guard let httpCode = actualJSON["httpCode"].int,
            let message = actualJSON["message"].string else { return nil }
        self.httpCode = httpCode
        self.message = message
    }
}

extension ExposureResponseMessage {
    public var localizedDescription: String {
        return "Exposure response returned httpCode: [\(httpCode)] with message: \(message)"
    }
}
