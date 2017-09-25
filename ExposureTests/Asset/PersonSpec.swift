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
            
            it("should init with required properties") {
                let json = PersonJSON.requiredKeys()
                let result = json.decode(Person.self)
                
                expect(result).toNot(beNil())
                expect(result?.personId).toNot(beNil())
                expect(result?.name).to(beNil())
                expect(result?.function).to(beNil())
            }
            
            it("should not init without required properties") {
                let json = PersonJSON.missingKeys()
                expect{ try json.throwingDecode(Person.self) }
                    .to(throwError(errorType: DecodingError.self))
            }
        }
    }
}

extension PersonSpec {
    enum PersonJSON {
        static let personId = "susan_jr_sarandon"
        static let name = "Susan Jr. Sarandon"
        static let function = "Stuntman"
        static func valid() -> [String: Codable] {
            return [
                "personId": PersonJSON.personId,
                "name": PersonJSON.name,
                "function": PersonJSON.function
            ]
        }
        
        static func requiredKeys() -> [String: Codable] {
            return [
                "personId": PersonJSON.personId
            ]
        }
        
        static func missingKeys() -> [String: Codable] {
            return [:]
        }
    }
}
