//
//  EDRMConfigurationSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure


class EDRMConfigurationSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("EDRMConfiguration") {
            it("should init correctly from json") {
                let json: [String: Any] = [
                    "ownerId":"id",
                    "userToken":"token",
                    "requestUrl":"requestUrl",
                    "adParameter":"ad"
                ]
                
                let result = try? json.decode(EDRMConfiguration.self)
                
                expect(result).toNot(beNil())
                expect(result?.ownerId).toNot(beNil())
                expect(result?.userToken).toNot(beNil())
                expect(result?.requestUrl).toNot(beNil())
                expect(result?.adParameter).toNot(beNil())
                
                expect(result?.ownerId).to(equal("id"))
                expect(result?.userToken).to(equal("token"))
                expect(result?.requestUrl).to(equal("requestUrl"))
                expect(result?.adParameter).to(equal("ad"))
            }
            
            it("should fail on incomplete json") {
                let json = [
                    "ownerId":"id",
                    "userToken":"token",
                    "requestUrl":nil,
                    "adParameter":"ad"
                ]
                
                let edrm = EDRMConfiguration(json: json)
                
                expect(edrm).to(beNil())
            }
        }
    }
}
