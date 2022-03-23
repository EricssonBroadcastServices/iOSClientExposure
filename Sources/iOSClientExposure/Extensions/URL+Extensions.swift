//
//  URL+Extensions.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-01-10.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

extension URL {
    /// Modifies the query parameter specified by `key`
    ///
    /// * adds `key:value` if not present
    /// * modifies `value` if `key` is present
    /// * removdes `key:value` if `value` is `nil`
    ///
    /// - parameter key: they key which defines the query parameter
    /// - parameter value: the value to set
    /// - returns: an updated `URL`
    public func queryParam(key: String, value: String?) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        
        if let _: String = queryParam(for: key) {
            // Update the current value for key
            let updated = urlComponents.queryItems?.flatMap{ item -> URLQueryItem? in
                if item.name == key {
                    if let value = value { return URLQueryItem(name: key, value: value) }
                    else { return nil }
                }
                else { return item }
            }
            urlComponents.queryItems = updated
            return urlComponents.url
        }
        else {
            // Add the value for key
            let itemToAdd = URLQueryItem(name: key, value: value)
            guard var queryItems = urlComponents.queryItems else {
                urlComponents.queryItems = [itemToAdd]
                return urlComponents.url
            }
            queryItems.append(itemToAdd)
            urlComponents.queryItems = queryItems
            return urlComponents.url
        }
    }
    
    /// Returns the query parameter associated with `key` as a `String`
    ///
    /// - parameter key: they key which defines the query parameter
    /// - returns: `value` if `key` is present, `nil` otherwise
    public func queryParam(for key: String) -> String? {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first{ $0.name == key }?
            .value
    }
    
    /// Returns the query parameter associated with `key` as an `Int64` if parsable
    ///
    /// - parameter key: they key which defines the query parameter
    /// - returns: `value` if `key` is present, `nil` otherwise
    public func queryParam(for key: String) -> Int64? {
        guard let value: String = queryParam(for: key) else { return  nil }
        return Int64(value)
    }
}
