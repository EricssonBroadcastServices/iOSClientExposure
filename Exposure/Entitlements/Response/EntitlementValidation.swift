//
//  EntitlementValidation.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Response detailing the result of an `EntitlementValidation` request.
///
/// Will return 200 even if user is not entitled with the result being in the `status` message.
public struct EntitlementValidation: Decodable {
    public typealias Status = PlaybackEntitlement.Status
    
    /// The status of the entitlement
    public let status: Status?
    
    /// The status of the payment
    public let paymentDone: Bool?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = Status(string: try container.decodeIfPresent(String.self, forKey: .status))
        paymentDone = try container.decodeIfPresent(Bool.self, forKey: .paymentDone)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case status = "status"
        case paymentDone = "paymentDone"
    }
}
