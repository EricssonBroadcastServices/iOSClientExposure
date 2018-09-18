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
        case .generalError(error: _): return "GENERAL_ERROR"
        case .serialization(reason: let reason): return reason.message
        case .exposureResponse(reason: let reason): return reason.message
        }
    }
}

extension ExposureError {
    /// Returns detailed information about the error
    public var info: String? {
        switch self {
        case .generalError(error: let error): return error.debugInfoString
        case .serialization(reason: let reason): return reason.info
        case .exposureResponse(reason: _): return nil
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

extension ExposureError {
    public var underlyingError: Error? {
        switch self {
        case .generalError(error: let error): return error
        case .serialization(reason: let reason): return reason.underlyingError
        case .exposureResponse(reason: _): return nil
        }
    }
}

extension ExposureError {
    public var domain: String { return String(describing: type(of: self))+"Domain" }
}

extension ExposureError.SerializationFailureReason {
    public var message: String {
        switch self {
        case .jsonSerialization(error: _): return "JSON_SERIALIZATION_ERROR"
        case .objectSerialization(reason: _, json: _): return "OBJECT_SERIALIZATION_ERROR"
        }
    }
}

extension ExposureError.SerializationFailureReason {
    /// Returns detailed information about the error
    public var info: String? {
        switch self {
        case .jsonSerialization(error: let error): return error.debugInfoString
        case .objectSerialization(reason: let reason, json: let json): return "Object Serialization error: \(reason) for json: \(json)"
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

extension ExposureError.SerializationFailureReason {
    public var underlyingError: Error? {
        switch self {
        case .jsonSerialization(error: let error): return error
        case .objectSerialization(reason: _, json: _): return nil
        }
    }
}
