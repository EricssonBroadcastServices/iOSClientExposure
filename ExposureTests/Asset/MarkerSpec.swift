//
//  MarkerSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation


import Quick
import Nimble

@testable import Exposure

class MarkerSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = MarkerJSON.valid()
                let result = json.decode(Marker.self)
                
                expect(result).toNot(beNil())
                expect(result?.offset).toNot(beNil())
                expect(result?.url).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let json = MarkerJSON.missingKeys()
                let result = json.decode(Marker.self)
                
                expect(result).toNot(beNil())
                expect(result?.offset).toNot(beNil())
                expect(result?.url).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = MarkerJSON.empty()
                let result = json.decode(Marker.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension MarkerSpec {
    enum MarkerJSON {
        static let offset = 100
        static let url = "someUrl"
        
        static func valid() -> [String: Any] {
            return [
                "offset": MarkerJSON.offset,
                "url": MarkerJSON.url,
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "offset": MarkerJSON.offset
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
