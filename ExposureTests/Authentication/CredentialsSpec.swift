//
//  CredentialsSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure


class CredentialsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("Credentials") {
            it("should not set a date if json is missing the datestring field") {
                let json = [
                    "sessionToken":"token",
                    "invalidDateKey":"SomeDateString"
                ]
                let credentials = Credentials(json: json)
                
                expect(credentials).toNot(beNil())
                expect(credentials!.sessionToken.value).to(equal("token"))
                expect(credentials!.expiration).to(beNil())
            }
        }
    }
}
