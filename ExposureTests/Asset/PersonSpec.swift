//
//  PersonSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class PersonSpec: QuickSpec {
    
    typealias Person = Asset.Person
    
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let value = Person(json: PersonJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.personId).toNot(beNil())
                expect(value!.name).toNot(beNil())
                expect(value!.function).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = Person(json: PersonJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.personId).toNot(beNil())
                expect(value!.name).to(beNil())
                expect(value!.function).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = Person(json: PersonJSON.empty())
                
                expect(value).to(beNil())
            }
        }
    }
}

extension PersonSpec {
    enum PersonJSON {
        static let personId = "susan_jr_sarandon"
        static let name = "Susan Jr. Sarandon"
        static let function = "Stuntman"
        static func valid() -> Any {
            return [
                "personId": PersonJSON.personId,
                "name": PersonJSON.name,
                "function": PersonJSON.function
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "personId": PersonJSON.personId
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
