//
//  FairplayConfiguration.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct FairplayConfiguration {
    public let secondaryMediaLocator: String?
    public let certificateUrl:String?
    public let licenseAcquisitionUrl: String?
}

extension FairplayConfiguration: ExposureConvertible {
    public init?(json: Any) {
        let actualJSON = SwiftyJSON.JSON(json)
        secondaryMediaLocator = actualJSON[JSONKeys.secondaryMediaLocator.rawValue].string
        certificateUrl = actualJSON[JSONKeys.certificateUrl.rawValue].string
        licenseAcquisitionUrl = actualJSON[JSONKeys.licenseAcquisitionUrl.rawValue].string
    }
    
    internal enum JSONKeys: String {
        case secondaryMediaLocator = "secondaryMediaLocator"
        case certificateUrl = "certificateUrl"
        case licenseAcquisitionUrl = "licenseAcquisitionUrl"
    }
}
