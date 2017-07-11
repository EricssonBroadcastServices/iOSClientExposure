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
                let json = [
                    "ownerId":"id",
                    "userToken":"token",
                    "requestUrl":"requestUrl",
                    "adParameter":"ad"
                ]
                
                let edrm = EDRMConfiguration(json: json)
                
                expect(edrm).toNot(beNil())
                expect(edrm!.ownerId).toNot(beNil())
                expect(edrm!.userToken).toNot(beNil())
                expect(edrm!.requestUrl).toNot(beNil())
                expect(edrm!.adParameter).toNot(beNil())
                
                expect(edrm!.ownerId).to(equal("id"))
                expect(edrm!.userToken).to(equal("token"))
                expect(edrm!.requestUrl).to(equal("requestUrl"))
                expect(edrm!.adParameter).to(equal("ad"))
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
