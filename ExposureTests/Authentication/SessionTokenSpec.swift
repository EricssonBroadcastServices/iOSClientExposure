//
//  SessionTokenSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure


class SessionTokenSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("AuthorizationHeaders") {
            it("should produce authorization headers") {
                let token = SessionToken(value: "TOKEN")
                let header = token.authorizationHeader
                let value:String? = header["Authorization"]
                
                expect(value).toNot(beNil())
                expect(value!).to(equal("Bearer "+"TOKEN"))
            }
            
            it("Should not init with nil value") {
                expect(SessionToken(value: nil)).to(beNil())
                let optionalValue: String? = "TEST"
                expect(SessionToken(value: optionalValue)).toNot(beNil())
            }
            
            it("Should be equatable with matching tokens") {
                expect(SessionToken(value: "TEST") == SessionToken(value: "TEST")).to(beTrue())
            }
            
            context("Components") {
                let validFormat = SessionToken(value: "crm|accountId|userId|hello|1000|2000|false|something|other")
                it("Should contain 9 components") {
                    expect(validFormat.hasValidFormat).to(beTrue())
                }
                
                it("should parse components") {
                    expect(validFormat.crmToken).to(equal("crm"))
                    expect(validFormat.accountId).to(equal("accountId"))
                    expect(validFormat.userId).to(equal("userId"))
                    
                    let aquired: TimeInterval = 1000
                    let expiration: TimeInterval = 2000
                    expect(validFormat.acquired).to(equal(aquired))
                    expect(validFormat.expiration).to(equal(expiration))
                    expect(validFormat.isAnonymous).to(equal(false))
                }
            }
        }
    }
}
