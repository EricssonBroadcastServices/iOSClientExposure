//
//  URLEncoding.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-16.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

/// Paramenter encoding for query strings compatible with Exposure.
internal struct URLEncoding: ParameterEncoding {
    public func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {
        var urlRequest = urlRequest
        guard let parameters = parameters else { return urlRequest }
        
        guard let url = urlRequest.url else {
            throw Request.Networking.parameterEncodingFailedMissingUrl
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            urlRequest.url = urlComponents.url
        }
        
        return urlRequest
    }
    
    /// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "true" : "false"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "true" : "false"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
