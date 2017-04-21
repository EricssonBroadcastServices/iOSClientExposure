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
        guard let secondaryMediaLocator = actualJSON[JSONKeys.secondaryMediaLocator.rawValue].string,
            let certificateUrl = actualJSON[JSONKeys.certificateUrl.rawValue].string,
            let licenseAcquisitionUrl = actualJSON[JSONKeys.licenseAcquisitionUrl.rawValue].string else { return nil }
        self.secondaryMediaLocator = secondaryMediaLocator
        self.certificateUrl = certificateUrl
        self.licenseAcquisitionUrl = licenseAcquisitionUrl
    }
    
    internal enum JSONKeys: String {
        case secondaryMediaLocator = "secondaryMediaLocator"
        case certificateUrl = "certificateUrl"
        case licenseAcquisitionUrl = "licenseAcquisitionUrl"
    }
}
