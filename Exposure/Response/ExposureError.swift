//
//  ExposureError.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public enum ExposureError: Error {
    case generalError(error: Error)
    case serialization(reason: SerializationFailureReason)
    case exposureResponse(reason: ExposureResponseMessage)
    
    public enum SerializationFailureReason {
        case jsonSerialization(error: Error)
        case objectSerialization(reason: String, json: Any)
    }

    public var localizedDescription: String {
        switch self {
        case .generalError(error: let error): return error.localizedDescription
        case .serialization(reason: let reason): return reason.localizedDescription
        case .exposureResponse(reason: let reason): return reason.localizedDescription
        }
    }
}

extension ExposureError.SerializationFailureReason {
    public var localizedDescription: String {
        switch self {
        case .jsonSerialization(error: let error): return "JSON Serialization error: \(error.localizedDescription)"
        case .objectSerialization(reason: let reason, json: let json): return "Object Serialization error: \(reason) for json: \(json)"
        }
    }
}
