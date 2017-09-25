//
//  DownloadValidation.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-25.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Response detailing the result of an `DownloadValidation` request.
///
/// Will return 200 even if user is not entitled with the result being in the `status` message.
public struct DownloadValidation: Decodable {
    public typealias Status = PlaybackEntitlement.Status
    
    public struct Bitrate: Decodable {
        /// The bitrate to give as the max bitrate to the player given as kb/s
        public let bitrate: Int64?
        
        /// The size of the asset in this bitrate given in bytes
        public let size: Int64?
    }
    
    /// The status of the entitlement
    public let status: Status
    
    /// The status of the payment
    public let paymentDone: Bool?
    
    /// The available bitrates
    public let bitrates: [Bitrate]?
    
    /// The number of seconds after first play that the video must be deleted from the storage
    public let downloadMaxSecondsAfterPlay: Int64?
    
    /// The number of seconds after the download is completed that the video must be deleted from the storage
    public let downloadMaxSecondsAfterDownload: Int64?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = Status(string: try container.decode(String.self, forKey: .status))
        paymentDone = try container.decodeIfPresent(Bool.self, forKey: .paymentDone)
        bitrates = try container.decodeIfPresent([Bitrate].self, forKey: .bitrates)
        downloadMaxSecondsAfterPlay = try container.decodeIfPresent(Int64.self, forKey: .downloadMaxSecondsAfterPlay)
        downloadMaxSecondsAfterDownload = try container.decodeIfPresent(Int64.self, forKey: .downloadMaxSecondsAfterDownload)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case status
        case paymentDone
        case bitrates
        case downloadMaxSecondsAfterPlay
        case downloadMaxSecondsAfterDownload
    }
}
