//
//  EDRMConfiguration.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct EDRMConfiguration {
    public let ownerId: String? // The id of the owner of the media.
    public let userToken: String? // The user token.
    public let requestUrl: String? // The url of the server to use.
    public let adParameter: String? //The ad parameter to use.
}

extension EDRMConfiguration: ExposureConvertible {
    public init?(json: Any) {
        let actualJSON = SwiftyJSON.JSON(json)
        ownerId = actualJSON[JSONKeys.ownerId.rawValue].string
        userToken = actualJSON[JSONKeys.userToken.rawValue].string
        requestUrl = actualJSON[JSONKeys.requestUrl.rawValue].string
        adParameter = actualJSON[JSONKeys.adParameter.rawValue].string
    }
    
    internal enum JSONKeys: String {
        case ownerId = "ownerId"
        case userToken = "userToken"
        case requestUrl = "requestUrl"
        case adParameter = "adParameter"
    }
}
