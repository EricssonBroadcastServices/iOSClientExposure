//
//  AnyJSONType.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-09-21.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public protocol JSONType: Codable {
    var jsonValue: Any { get }
}

extension Int: JSONType {
    public var jsonValue: Any { return self }
}
extension Int64: JSONType {
    public var jsonValue: Any { return self }
}
extension String: JSONType {
    public var jsonValue: Any { return self }
}
extension Double: JSONType {
    public var jsonValue: Any { return self }
}
extension Bool: JSONType {
    public var jsonValue: Any { return self }
}

public struct AnyJSONType: JSONType {
    public let jsonValue: Any
    public init(_ value: Any) {
        jsonValue = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        if let value = jsonValue as? Int {
            try container.encode(value)
        }
        else if let value = jsonValue as? Int64 {
            try container.encode(value)
        }
        else if let string = jsonValue as? String {
            try container.encode(string)
        }
        else if let boolValue = jsonValue as? Bool {
            try container.encode(boolValue)
        }
        else if let arrayValue = jsonValue as? [AnyJSONType] {
            try container.encode(arrayValue)
        }
        else if let dictValue = jsonValue as? [String: AnyJSONType] {
            try container.encode(dictValue)
        }
        else {
            throw DecodingError.typeMismatch(JSONType.self, DecodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported JSON type"))
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            jsonValue = intValue
        } else if let intValue = try? container.decode(Int64.self) {
            jsonValue = intValue
        } else if let stringValue = try? container.decode(String.self) {
            jsonValue = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            jsonValue = boolValue
        } else if let doubleValue = try? container.decode(Double.self) {
            jsonValue = doubleValue
        } else if let arrayValue = try? container.decode(Array<AnyJSONType>.self) {
            jsonValue = arrayValue
        } else if let dictValue = try? container.decode(Dictionary<String, AnyJSONType>.self) {
            jsonValue = dictValue
        } else {
            throw DecodingError.typeMismatch(JSONType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported JSON type"))
        }
    }
}
