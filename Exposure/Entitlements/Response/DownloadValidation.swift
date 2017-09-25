//
//  DownloadValidation.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-25.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Response detailing the result of an `DownloadValidation` request.
///
/// Will return 200 even if user is not entitled with the result being in the `status` message.
public struct DownloadValidation: ExposureConvertible {
    public typealias Status = PlaybackEntitlement.Status
    
    public struct Bitrate {
        /// The bitrate to give as the max bitrate to the player given as kb/s
        public let bitrate: Int64?
        
        /// The size of the asset in this bitrate given in bytes
        public let size: Int64?
        
        public init?(json: Any){
            let actualJSON = SwiftyJSON.JSON(json)
            
            bitrate = actualJSON[JSONKeys.bitrate.rawValue].int64
            size = actualJSON[JSONKeys.size.rawValue].int64
            
            if bitrate == nil && size == nil { return nil }
        }
        
        internal enum JSONKeys: String {
            case bitrate = "bitrate"
            case size = "size"
        }
        
    }
    
    /// The status of the entitlement
    public let status: Status?
    
    /// The status of the payment
    public let paymentDone: Bool?
    
    /// The available bitrates
    public let bitrates: [Bitrate]
    
    /// The number of seconds after first play that the video must be deleted from the storage
    public let downloadMaxSecondsAfterPlay: Int64?
    
    /// The number of seconds after the download is completed that the video must be deleted from the storage
    public let downloadMaxSecondsAfterDownload: Int64?
    
    public init?(json: Any){
        let actualJSON = SwiftyJSON.JSON(json)
        
        status = Status(string: actualJSON[JSONKeys.status.rawValue].string)
        paymentDone = actualJSON[JSONKeys.paymentDone.rawValue].bool
        
        bitrates = actualJSON[JSONKeys.bitrates.rawValue].arrayObject?.flatMap{ Bitrate(json: $0) } ?? []
        downloadMaxSecondsAfterPlay = actualJSON[JSONKeys.downloadMaxSecondsAfterPlay.rawValue].int64
        downloadMaxSecondsAfterDownload = actualJSON[JSONKeys.downloadMaxSecondsAfterDownload.rawValue].int64
        
        if status == nil && paymentDone == nil && bitrates.count == 0 && downloadMaxSecondsAfterPlay == nil && downloadMaxSecondsAfterDownload == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case status = "status"
        case paymentDone = "paymentDone"
        case bitrates = "bitrates"
        case downloadMaxSecondsAfterPlay = "downloadMaxSecondsAfterPlay"
        case downloadMaxSecondsAfterDownload = "downloadMaxSecondsAfterDownload"
    }
}
