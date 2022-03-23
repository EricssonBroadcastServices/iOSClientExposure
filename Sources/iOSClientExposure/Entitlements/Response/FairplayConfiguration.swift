//
//  FairplayConfiguration.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Fairplay* protected content is the primary means of delivering secure streaming and offline media to devices in the Apple echosystem.
///
/// `FairplayConfiguration` encapsulates all information required by client applications to initiate playback. For more information regarding *Fairplay* streaming, please see [Apple's documentation](https://developer.apple.com/streaming/fps/)
public struct FairplayConfiguration: Codable {
    /// *MRR* identifier for the *Fairplay* media.
    public let secondaryMediaLocator: String?
    
    /// URL to the *Application Certificate*
    public let certificateUrl:String?
    
    /// URL to where *Content Key Context* requests will be made
    public let licenseAcquisitionUrl: String?
    
    public let licenseServerUrl: String?
    
    public init(secondaryMediaLocator: String?, certificateUrl: String?, licenseAcquisitionUrl: String?, licenseServerUrl: String? ) {
        self.secondaryMediaLocator = secondaryMediaLocator
        self.certificateUrl = certificateUrl
        self.licenseAcquisitionUrl = licenseAcquisitionUrl
        self.licenseServerUrl = licenseServerUrl
    }
}

