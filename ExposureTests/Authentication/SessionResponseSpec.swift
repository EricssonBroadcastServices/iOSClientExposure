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
                let value = SessionResponse(json: SessionResponseJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.crmToken).toNot(beNil())
                expect(value!.accountId).toNot(beNil())
                expect(value!.userId).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = SessionResponse(json: SessionResponseJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.crmToken).toNot(beNil())
                expect(value!.accountId).to(beNil())
                expect(value!.userId).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = SessionResponse(json: SessionResponseJSON.empty())
                
                expect(value).to(beNil())
            }
        }
    }
}

extension SessionResponseSpec {
    enum SessionResponseJSON {
        static let crmToken = "someToken"
        static let accountId = "accountId"
        static let userId = "userId"
        
        static func valid() -> Any {
            return [
                "crmToken": SessionResponseJSON.crmToken,
                "accountId": SessionResponseJSON.accountId,
                "userId": SessionResponseJSON.userId
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "crmToken": SessionResponseJSON.crmToken
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
