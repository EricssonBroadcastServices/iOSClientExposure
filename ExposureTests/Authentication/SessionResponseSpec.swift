//
//  SessionResponseSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-09-04.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class SessionResponseSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = SessionResponseJSON.valid()
                let result = json.decode(SessionResponse.self)
                
                expect(result).toNot(beNil())
                expect(result?.crmToken).toNot(beNil())
                expect(result?.accountId).toNot(beNil())
                expect(result?.userId).toNot(beNil())
            }
            
            it("should not init without required properties") {
                let json = SessionResponseJSON.missingKeys()
                expect{ try json.throwingDecode(SessionResponse.self) }
                    .to(throwError(errorType: DecodingError.self))
            }
        }
    }
}

extension SessionResponseSpec {
    enum SessionResponseJSON {
        static let crmToken = "someToken"
        static let accountId = "accountId"
        static let userId = "userId"
        
        static func valid() -> [String: Codable] {
            return [
                "crmToken": SessionResponseJSON.crmToken,
                "accountId": SessionResponseJSON.accountId,
                "userId": SessionResponseJSON.userId
            ]
        }
        
        static func missingKeys() -> [String: Codable] {
            return [
                "crmToken": SessionResponseJSON.crmToken
            ]
        }
    }
}
