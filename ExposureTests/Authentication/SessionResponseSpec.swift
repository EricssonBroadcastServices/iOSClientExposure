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
            
            it("should succeed with partial response") {
                let json = SessionResponseJSON.missingKeys()
                let result = json.decode(SessionResponse.self)
                
                expect(result).toNot(beNil())
                expect(result?.crmToken).toNot(beNil())
                expect(result?.accountId).to(beNil())
                expect(result?.userId).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = SessionResponseJSON.empty()
                let result = json.decode(SessionResponse.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension SessionResponseSpec {
    enum SessionResponseJSON {
        static let crmToken = "someToken"
        static let accountId = "accountId"
        static let userId = "userId"
        
        static func valid() -> [String: Any] {
            return [
                "crmToken": SessionResponseJSON.crmToken,
                "accountId": SessionResponseJSON.accountId,
                "userId": SessionResponseJSON.userId
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "crmToken": SessionResponseJSON.crmToken
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
