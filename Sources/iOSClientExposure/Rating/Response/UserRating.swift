//
//  UserRating.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// User content rating
public struct UserRating: Decodable {
    /// Rating between [0...1]
    public let rating: Float
    
    /// Date this rating was first created
    public let creationDate: String
    
    /// Date this rating was last modified
    public let lastModificationDate: String
}

