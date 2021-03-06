//
//  DeleteDownload.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-10-19.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

public struct DeleteDownload: ExposureType {
        
        public typealias Response = DeleteDownloadCompleted
        
        /// Id of the asset to delete
        public let assetId: String
        
        /// `Environment` to use
        public let environment: Environment
        
        /// `SessionToken` identifying the user making the request
        public let sessionToken: SessionToken
        
        public init(assetId: String, environment: Environment, sessionToken: SessionToken) {
            self.assetId = assetId
            self.environment = environment
            self.sessionToken = sessionToken
        }
        
        public var endpointUrl: String {
            var newEnvironment = environment
            newEnvironment.version = "v2"
            return newEnvironment.apiUrl + "/entitlement/" + assetId + "/downloads"
        }
        
        
        public var parameters: [String: Any] {
            return [:]
        }
        
        public var headers: [String: String]? {
            return sessionToken.authorizationHeader
        }
    }

    extension DeleteDownload {
        
        /// Unregister all downloads for an asset done by an account
        /// - Returns: `ExposureRequest` with request specific data
        public func request() -> ExposureRequest<Response> {
            return request(.delete)
        }
    }

