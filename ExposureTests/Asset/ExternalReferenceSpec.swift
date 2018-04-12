//
//  ExternalReferenceSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class ExternalReferenceSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = ExternalReferenceJSON.valid()
                let result = json.decode(ExternalReference.self)
                
                expect(result).toNot(beNil())
                expect(result?.locator).toNot(beNil())
                expect(result?.type).toNot(beNil())
                expect(result?.value).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = ExternalReferenceJSON.missingKeys()
                let result = json.decode(ExternalReference.self)
                
                expect(result).toNot(beNil())
                expect(result?.locator).toNot(beNil())
                expect(result?.type).to(beNil())
                expect(result?.value).to(beNil())
            }
            
            it("should init with empty response") {
                let json = ExternalReferenceJSON.empty()
                let result = json.decode(ExternalReference.self)
                
                expect(result).toNot(beNil())
            }
        }
    }
}

extension ExternalReferenceSpec {
    enum ExternalReferenceJSON {
        static let locator = "http://someUrl.com/references/ref1"
        static let type = "QAProvider"
        static let value = "QAExternalRef_3da09434-6193-450b-8fd1-aa283c14eb8d"
        static func valid() -> [String: Any] {
            return [
                "locator": ExternalReferenceJSON.locator,
                "type": ExternalReferenceJSON.type,
                "value": ExternalReferenceJSON.value
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "locator": ExternalReferenceJSON.locator
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
