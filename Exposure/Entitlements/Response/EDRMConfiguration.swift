//
//  EDRMConfiguration.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

/// *Ericsson* `DRM` configuration.
public struct EDRMConfiguration {
    /// The id of the owner of the media.
    public let ownerId: String?
    
    /// The user token.
    public let userToken: String?
    
    /// The url of the server to use.
    public let requestUrl: String?
    
    ///The ad parameter to use.
    public let adParameter: String?
}

extension EDRMConfiguration: ExposureConvertible {
    public init?(json: Any) {
        let actualJSON = SwiftyJSON.JSON(json)
        guard let ownerId = actualJSON[JSONKeys.ownerId.rawValue].string, let userToken = actualJSON[JSONKeys.userToken.rawValue].string, let requestUrl = actualJSON[JSONKeys.requestUrl.rawValue].string, let adParameter = actualJSON[JSONKeys.adParameter.rawValue].string else { return nil }
        self.ownerId = ownerId
        self.userToken = userToken
        self.requestUrl = requestUrl
        self.adParameter = adParameter
    }
    
    internal enum JSONKeys: String {
        case ownerId = "ownerId"
        case userToken = "userToken"
        case requestUrl = "requestUrl"
        case adParameter = "adParameter"
    }
}
