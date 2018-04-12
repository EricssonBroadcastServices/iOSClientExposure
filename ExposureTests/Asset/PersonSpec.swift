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
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = PersonJSON.valid()
                let result = json.decode(Person.self)
                
                expect(result).toNot(beNil())
                expect(result?.personId).toNot(beNil())
                expect(result?.name).toNot(beNil())
                expect(result?.function).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = PersonJSON.missingKeys()
                let result = json.decode(Person.self)
                
                expect(result).toNot(beNil())
                expect(result?.personId).toNot(beNil())
                expect(result?.name).to(beNil())
                expect(result?.function).to(beNil())
            }
            
            it("should init with empty response") {
                let json = PersonJSON.empty()
                let result = json.decode(Person.self)
                
                expect(result).toNot(beNil())
            }
        }
    }
}

extension PersonSpec {
    enum PersonJSON {
        static let personId = "susan_jr_sarandon"
        static let name = "Susan Jr. Sarandon"
        static let function = "Stuntman"
        static func valid() -> [String: Any] {
            return [
                "personId": PersonJSON.personId,
                "name": PersonJSON.name,
                "function": PersonJSON.function
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "personId": PersonJSON.personId
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
