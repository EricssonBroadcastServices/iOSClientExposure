//
//  CheckAssetRights.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-05-08.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

public struct CheckAssetRights {
    public let environment: Environment
    public let assetId: String
    
    public init(environment: Environment, assetId: String) {
        self.environment = environment
        self.assetId = assetId
    }
}

extension CheckAssetRights {
    
    /* If you find downloadBlocked = true it means that download is not allowed. If the value is "downloadBlocked": false or not present at all it means that download is allowed.
     */
    
    /// Check if the Asset is available to download
    /// - Parameters:
    ///   - enviornment: exposure enviornment
    ///   - assetId: asset id
    ///   - completionHandler: completion
    public func isAvailableToDownload(_ completionHandler: @escaping (Bool) -> Void) {
           FetchAssetById(environment: environment, assetId: assetId)
               .request()
               .validate()
               .response{
                   if let asset = $0.value {
                       if let downloadBlocked = asset.publications?.first?.rights?.downloadBlocked {
                           print("downloadBlocked Is available ", downloadBlocked )
                           completionHandler(downloadBlocked == true ? false : true)
                       } else {
                           print("Can't find downloadBlocked then it should be available to download " )
                           completionHandler(true)
                       }
                   } else {
                       print("Error ", $0.error)
                       completionHandler(false)
                   }
           }
       }
}
