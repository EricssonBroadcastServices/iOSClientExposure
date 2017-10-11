//
//  EDRMConfiguration.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Ericsson* `DRM` configuration.
public struct EDRMConfiguration: Codable {
    /// The id of the owner of the media.
    public let ownerId: String?
    
    /// The user token.
    public let userToken: String?
    
    /// The url of the server to use.
    public let requestUrl: String?
    
    ///The ad parameter to use.
    public let adParameter: String?
}

