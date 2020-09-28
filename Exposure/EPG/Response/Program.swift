//
//  Program.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Program: Decodable {
    /// The date the program was created.
    public var created: String?
    
    /// The date the program was changed.
    public var changed: String?
    
    /// The id of the program.
    public let programId: String
    
    /// The id of the asset this program is for.
    public let assetId: String
    
    /// The id of the channel this program is on.
    public let channelId: String
    
    /// Start time for the program
    public let startTime: String?
    
    /// End time for the program
    public let endTime: String?
    
    /// If this asset is currently available as VOD.
    public var vodAvailable: Bool?
    
    /// If this asset is currently available as rough cut that is not expired.
    public var catchup: Bool?
    
    /// If this asset is currently blocked for catchup.
    public var catchupBlocked: Bool?
    
    /// The asset metadata
    public var asset: Asset?
    
    // If this program is currently published as blackout. This means any publication contains blackout, not global blackout
    public var blackout: Bool?
    
    public init(programId: String, assetId: String, channelId: String, startTime: String?, endTime: String?) {
        self.programId = programId
        self.assetId = assetId
        self.channelId = channelId
        self.startTime = startTime
        self.endTime = endTime
    }
}

extension Program {
    internal static var exposureDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    
    public var startDate: Date? {
        return exposureFormattedDate(string: startTime)
    }
    
    public var endDate: Date? {
        return exposureFormattedDate(string: endTime)
    }
    
    internal func exposureFormattedDate(string: String?) -> Date? {
        guard let dateString = string else { return nil }
        
        let formatter = Program.exposureDateFormatter
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter.date(from: dateString)
    }
}
