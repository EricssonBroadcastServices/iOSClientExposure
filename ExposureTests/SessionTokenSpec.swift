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
        }
    }
}
