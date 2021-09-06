//
//  MarkerPointsSpec.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2021-09-06.
//  Copyright © 2021 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class MarkerPointsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = MarkerPointsJSON.valid()
                let result = json.decode(Marker.self)
                
                expect(result).toNot(beNil())
                expect(result?.type).toNot(beNil())
                expect(result?.offset).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let json = MarkerPointsJSON.missingKeys()
                let result = json.decode(Marker.self)
                
                expect(result).toNot(beNil())
                expect(result?.type).toNot(beNil())
                expect(result?.offset).to(beNil())
            }
            
            it("should init with empty or non matching response") {
                let json = MarkerPointsJSON.empty()
                let result = json.decode(Marker.self)
                
                expect(result).toNot(beNil())
                expect(result?.type).to(beNil())
                expect(result?.offset).to(beNil())
                expect(result?.endOffset).to(beNil())
                expect(result?.localized).to(beNil())
            }
        }
    }
}

extension MarkerPointsSpec {
    enum MarkerPointsJSON {
        static let type = "POINT"
        static let offset = 41007
        static let endOffset = 41007
        static let localized = [LocalizedData(locale: "sv", title: "Test Title")]
        
        static func valid() -> [String: Any] {
            return [
                "type" : MarkerPointsJSON.type,
                "offset": MarkerPointsJSON.offset,
                "endOffset": MarkerPointsJSON.endOffset,
                "localized": MarkerPointsJSON.localized,
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "endOffset": MarkerPointsJSON.endOffset,
                "localized": MarkerPointsJSON.localized
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
