//
//  ExposureError.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// `ExposureError` is the error type returned by the *Exposure Framework*. It can manifest as both *native errors* to the framework and *nested errors* specific to underlying frameworks or concepts such as `ExposureResponseMessage`.
/// Effective error handling thus requires a deeper undestanding of the overall architecture.
///
/// - important: Nested errors have *error codes* specific to the related *domain*. A domain is defined as the `representing type` *(for example* `ExposureResponseMessage`*)* and may contain subtypes. This means different errors may share error codes. When this occurs, it is important to keep track of the underlying domain.
public enum ExposureError: Error {
    /// General Errors
    case generalError(error: Error)
    
    /// Serialization failed for some reason.
    case serialization(reason: SerializationFailureReason)
    
    /// *Exposure* responded with an error message
    case exposureResponse(reason: ExposureResponseMessage)
    
}

extension ExposureError {
    /// Raw data serializaiton failure.
    public enum SerializationFailureReason {
        /// Failed to serilize json payload from response data.
        case jsonSerialization(error: Error)
        
        /// Failed to serialize object from json payload.
        case objectSerialization(reason: String, json: Any)
    }
}

extension ExposureError {
    public var message: String {
        switch self {
        case .generalError(error: let error): return "Exposure: " + error.localizedDescription
        case .serialization(reason: let reason): return "Exposure: " + reason.message
        case .exposureResponse(reason: let reason): return "Exposure: " + reason.message
        }
    }
}

extension ExposureError.SerializationFailureReason {
    public var message: String {
        switch self {
        case .jsonSerialization(error: let error): return "JSON Serialization error: \(error.localizedDescription)"
        case .objectSerialization(reason: let reason, json: let json): return "Object Serialization error: \(reason) for json: \(json)"
        }
    }
}

extension ExposureError {
    /// Defines the `domain` specific code for the underlying error.
    public var code: Int {
        switch self {
        case .generalError(error: _): return 101
        case .serialization(reason: let error): return error.code
        case .exposureResponse(reason: let reason): return reason.httpCode
        }
    }
}

extension ExposureError.SerializationFailureReason {
    /// Defines the `domain` specific code for the underlying error.
    public var code: Int {
        switch self {
        case .jsonSerialization(error: _): return 201
        case .objectSerialization(reason: _, json: _): return 202
        }
    }
}

