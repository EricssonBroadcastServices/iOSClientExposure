//
//  FairplayConfiguration.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

/// *Fairplay* protected content is the primary means of delivering secure streaming and offline media to devices in the Apple echosystem.
///
/// `FairplayConfiguration` encapsulates all information required by client applications to initiate playback. For more information regarding *Fairplay* streaming, please see [Apple's documentation](https://developer.apple.com/streaming/fps/)
public struct FairplayConfiguration {
    /// *MRR* identifier for the *Fairplay* media.
    public let secondaryMediaLocator: String?
    
    /// URL to the *Application Certificate*
    public let certificateUrl:String?
    
    /// URL to where *Content Key Context* requests will be made
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
