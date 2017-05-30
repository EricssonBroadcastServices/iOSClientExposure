//
//  LinkedEntitySpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class LinkedEntitySpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let value = LinkedEntity(json: LinkedEntityJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.entityId).toNot(beNil())
                expect(value!.linkType).toNot(beNil())
                expect(value!.entityType).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = LinkedEntity(json: LinkedEntityJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.entityId).to(beNil())
                expect(value!.linkType).to(beNil())
                expect(value!.entityType).toNot(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = LinkedEntity(json: LinkedEntityJSON.empty())
                
                expect(value).to(beNil())
            }
        }
    }
}

extension LinkedEntitySpec {
    enum LinkedEntityJSON {
        static let entityId = "anEntityId"
        static let linkType = "aLinkType"
        static let entityType = "anEnitityType"
        static func valid() -> Any {
            return [
                "entityId": LinkedEntityJSON.entityId,
                "linkType": LinkedEntityJSON.linkType,
                "entityType": LinkedEntityJSON.entityType
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "entityType": LinkedEntityJSON.entityType
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
