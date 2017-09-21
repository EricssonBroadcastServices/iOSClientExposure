//
//  ParentalRating.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct ParentalRating: Decodable {
    /// The two letter country code this rating is for.
    public let country: String?
    
    /// The rating scheme, for instance MPAA.
    public let scheme: String?
    
    /// The rating, allowed values depends on the scheme.
    public let rating: String?
}
