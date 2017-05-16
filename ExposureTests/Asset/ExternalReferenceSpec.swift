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
    
    typealias ExternalReference = Asset.ExternalReference
    
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let value = ExternalReference(json: ExternalReferenceJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.locator).toNot(beNil())
                expect(value!.type).toNot(beNil())
                expect(value!.value).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = ExternalReference(json: ExternalReferenceJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.locator).toNot(beNil())
                expect(value!.type).to(beNil())
                expect(value!.value).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = ExternalReference(json: ExternalReferenceJSON.empty())
                
                expect(value).to(beNil())
            }
        }
    }
}

extension ExternalReferenceSpec {
    enum ExternalReferenceJSON {
        static let locator = "http://someUrl.com/references/ref1"
        static let type = "QAProvider"
        static let value = "QAExternalRef_3da09434-6193-450b-8fd1-aa283c14eb8d"
        static func valid() -> Any {
            return [
                "locator": ExternalReferenceJSON.locator,
                "type": ExternalReferenceJSON.type,
                "value": ExternalReferenceJSON.value
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "locator": ExternalReferenceJSON.locator
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
