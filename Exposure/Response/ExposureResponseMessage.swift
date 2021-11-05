//
//  ExposureResponseMessage.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* may signal errors by transmitting a response message with a related `http` status code. Validating the related `ExposureRequest` is therefore good practice.
///
/// ```swift
/// Entitlement(environment: myEnv,
///             sessionToken: aToken)
///     .vod(assetId)
///     .request()
///     .validate(statusCode: 200..<399) // Will throw ExposureError on code 400
///     .response{
///         if case let .exposureResponse(reason: reason) = $0.error {
///             // Handle Exposure related error message
///         }
///     }
/// ```
///
/// * 400 `INVALID_JSON` If JSON received is not valid JSON.
/// * 401 `NO_SESSION_TOKEN` If the session token is missing.
/// * 403 `FORBIDDEN` If this business unit has been configured to require server to server authentication, but it is not valid.
public struct ExposureResponseMessage: Decodable {
    /// `http` code returned by *Exposure*
    public let httpCode: Int
    
    /// Related error message returned by *Exposure*
    public let message: String
    
    public let actions: [EntitlementErrorAction]?
    
    public init(httpCode: Int, message: String, actions:[EntitlementErrorAction]? ) {
        self.httpCode = httpCode
        self.message = message
        self.actions = actions
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        httpCode = try container.decode(Int.self, forKey: .httpCode)
        actions = try container.decodeIfPresent([EntitlementErrorAction].self, forKey: .actions)
        if let errorMessage = try container.decodeIfPresent(String.self, forKey: .message) {
            message = errorMessage
        }
        else {
            /// HACK: Exposure sometimes returns
            ///
            /// ```json
            /// {
            ///     httpCode: 500
            /// }
            /// ````
            ///
            /// Ie with a missing `message` key:value. This will account for the scenario and internally
            /// map all 500 without a message to "INTERNAL_ERROR". If `httpCode` != 500`, throws a decoding error.
            if httpCode == 500 { message = "INTERNAL_ERROR" }
            else { message = try container.decode(String.self, forKey: .message) }
        }
    }
    
    internal enum CodingKeys: CodingKey {
        case httpCode
        case message
        case actions
    }
}



/// Entitlement end point `/entitle` may return different error actions
public struct EntitlementErrorAction: Decodable {
    public let type: String?
    public let publication: EntitlementErrorActionPublication?
    public let offerings: [EntitlementErrorActionOfferings]?
    
    public init(type: String?, publication: EntitlementErrorActionPublication?, offerings:  [EntitlementErrorActionOfferings]? ) {
        self.type = type
        self.publication = publication
        self.offerings = offerings
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        publication = try container.decodeIfPresent(EntitlementErrorActionPublication.self, forKey: .publication)
        offerings = try container.decodeIfPresent([EntitlementErrorActionOfferings].self, forKey: .offerings)
    }
    
    internal enum CodingKeys: CodingKey {
        case type
        case publication
        case offerings
    }
    
}

public struct EntitlementErrorActionPublication: Decodable {
    public let availableAt: String?
    public let publicationId: String?
    
    public init(availableAt: String?, publicationId: String? ) {
        self.availableAt = availableAt
        self.publicationId = publicationId
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        availableAt = try container.decodeIfPresent(String.self, forKey: .availableAt)
        publicationId = try container.decodeIfPresent(String.self, forKey: .publicationId)
    }
    
    internal enum CodingKeys: CodingKey {
        case availableAt
        case publicationId
    }
    
}

public struct EntitlementErrorActionOfferings: Decodable {
    public let offeringId: String?
    public let publications:[EntitlementErrorActionPublication]?
    
    public init(offeringId: String?, publications: [EntitlementErrorActionPublication]? ) {
        self.offeringId = offeringId
        self.publications = publications
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        offeringId = try container.decodeIfPresent(String.self, forKey: .offeringId)
        publications = try container.decodeIfPresent([EntitlementErrorActionPublication].self, forKey: .publications)
    }
    
    internal enum CodingKeys: CodingKey {
        case offeringId
        case publications
    }
}
