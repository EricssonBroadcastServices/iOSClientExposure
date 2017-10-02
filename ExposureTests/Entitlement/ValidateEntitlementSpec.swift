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
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let assetId = "assetId1_qwerty"
        let sessionToken = SessionToken(value: "token")
        
        let request = Entitlement(environment: env,
                                  sessionToken: sessionToken)
            .validate(assetId: assetId)
            .use(drm: .unencrypted)
            .use(format: .hls)
        
        describe("ValidateEntitlement") {
            it("should have headers") {
                expect(request.headers).toNot(beNil())
                expect(request.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/entitlement/" + assetId
                expect(request.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let json = PlayRequest().toJSON()
                expect(request.parameters.count).to(equal(json.count))
            }
            
            it("should record DRM and format") {
                let drm = request.drm
                let format = request.format
                
                expect(drm.rawValue).to(equal(PlayRequest.DRM.unencrypted.rawValue))
                expect(format.rawValue).to(equal(PlayRequest.Format.hls.rawValue))
            }
        }
        
        describe("EntitlementValidation") {
            it("should process with valid json") {
                let json: [String : Codable] = [
                    "status":"SUCCESS",
                    "paymentDone":false
                    ]
                
                let result = json.decode(EntitlementValidation.self)
                
                expect(result).toNot(beNil())
                
                expect(result?.status).to(equal(.success))
                
                expect(result?.paymentDone).to(equal(false))
            }
            
            it("should fail with invalid json") {
                let json: [String: Codable] = [
                    "WRONG_KEY":"SUCCESS",
                    "OTHER_MISTAKE":false
                ]
                
                expect{ try json.throwingDecode(EntitlementValidation.self) }
                    .to(throwError(errorType: DecodingError.self))
            }
        }
    }
}

extension Dictionary where Key == String, Value == Codable {
    func decode<T>(_ type: T.Type) -> T? where T : Decodable {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension Dictionary where Key == String, Value == Codable {
    func throwingDecode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
