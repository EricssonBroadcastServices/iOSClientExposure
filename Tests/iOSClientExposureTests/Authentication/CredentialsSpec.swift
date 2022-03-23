//
//  CredentialsSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import iOSClientExposure


class CredentialsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("Credentials") {
            it("should not set a date if json is missing the datestring field") {
                let json: [String: Any] = [
                    "sessionToken":"token",
                    "invalidDateKey":"SomeDateString"
                ]
                
                let result = json.decode(Credentials.self)
                
                expect(result).toNot(beNil())
                expect(result?.sessionToken.value).to(equal("token"))
                expect(result?.expiration).to(beNil())
            }
        }
    }
}
