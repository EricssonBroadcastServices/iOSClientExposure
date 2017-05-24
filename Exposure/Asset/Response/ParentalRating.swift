//
//  ParentalRating.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ParentalRating {
    public let country: String? // The two letter country code this rating is for.,
    public let scheme: String? // The rating scheme, for instance MPAA.,
    public let rating: String? // The rating, allowed values depends on the scheme.
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        country = actualJson[JSONKeys.country.rawValue].string
        scheme = actualJson[JSONKeys.scheme.rawValue].string
        rating = actualJson[JSONKeys.rating.rawValue].string
        
        if country == nil && scheme == nil && rating == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case country = "country"
        case scheme = "scheme"
        case rating = "rating"
    }
}
