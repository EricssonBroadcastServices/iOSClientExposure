//
//  SearchResponseAutocomplete.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct SearchResponseAutocomplete: Decodable {
    /// The autocompleted search query
    public let text: String
    
    /// Related assetId
    public let assetId: String
}
