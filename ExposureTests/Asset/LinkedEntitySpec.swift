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
                let json = LinkedEntityJSON.valid()
                let result = json.decode(LinkedEntity.self)
                
                expect(result).toNot(beNil())
                expect(result?.entityId).toNot(beNil())
                expect(result?.linkType).toNot(beNil())
                expect(result?.entityType).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = LinkedEntityJSON.missingKeys()
                let result = json.decode(LinkedEntity.self)
                
                expect(result).toNot(beNil())
                expect(result?.entityId).to(beNil())
                expect(result?.linkType).to(beNil())
                expect(result?.entityType).toNot(beNil())
            }
            
            it("should init with empty response") {
                let json = LinkedEntityJSON.empty()
                let result = json.decode(LinkedEntity.self)
                
                expect(result).toNot(beNil())
            }
        }
    }
}

extension LinkedEntitySpec {
    enum LinkedEntityJSON {
        static let entityId = "anEntityId"
        static let linkType = "aLinkType"
        static let entityType = "anEnitityType"
        static func valid() -> [String: Any] {
            return [
                "entityId": LinkedEntityJSON.entityId,
                "linkType": LinkedEntityJSON.linkType,
                "entityType": LinkedEntityJSON.entityType
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "entityType": LinkedEntityJSON.entityType
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
