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
                let json
                let value = Marker(json: MarkerJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.offset).toNot(beNil())
                expect(value!.url).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = Marker(json: MarkerJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.offset).toNot(beNil())
                expect(value!.url).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = Marker(json: MarkerJSON.empty())
                
                expect(value).to(beNil())
            }
        }
    }
}

extension MarkerSpec {
    enum MarkerJSON {
        static let offset = 100
        static let url = "someUrl"
        
        static func valid() -> Any {
            return [
                "offset": MarkerJSON.offset,
                "url": MarkerJSON.url,
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "offset": MarkerJSON.offset
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
