//
//  ValidateEntitlementSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class ValidateEntitlementSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let assetId = "assetId1_qwerty"
        let sessionToken = SessionToken(value: "token")
        
        env.version = "v2"
        
        let request = Entitlement(environment: env,sessionToken: sessionToken)
                        .validate(assetId: assetId)
        
        describe("ValidateEntitlement") {
            it("should have headers") {
                expect(request.headers).toNot(beNil())
                expect(request.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/entitlement/" + assetId + "/entitle"
                expect(request.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
        
        describe("EntitlementValidation") {
            
            let streamInfo: [String: Any] = [
                "live" : false,
                "static" : true,
                "event" : false,
                "start" : 1555329600,
                "channelId" : "channelId",
                "programId" : "programId",
                "end": 15555399
            ]
            
            let json: [String : Any] = [
                "accountId":"accountId",
                "requestId":"requestId",
                "productId":"productId",
                "publicationId":"publicationId",
                "streamInfo":streamInfo,
                "status":"SUCCESS",
                ]
            
            let requiredKeys: [String : Any] = [
                "status":"SUCCESS",
                ]
            
            
            it("should process with valid json") {
                let result = json.decode(EntitlementValidation.self)
                expect(result).toNot(beNil())
                expect(result?.status).to(equal("SUCCESS"))
            }
            
            it("should init with required keys") {
                let result = requiredKeys.decode(EntitlementValidation.self)
                expect(result).toNot(beNil())
            }
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    func decode<T>(_ type: T.Type) -> T? where T : Decodable {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension Dictionary where Key == String, Value == Any {
    func throwingDecode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
