//
//  ParentalRatingSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class ParentalRatingSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = ParentalRatingJSON.valid()
                let result = json.decode(ParentalRating.self)
                
                expect(result).toNot(beNil())
                expect(result?.country).toNot(beNil())
                expect(result?.scheme).toNot(beNil())
                expect(result?.rating).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let json = ParentalRatingJSON.missingKeys()
                let result = json.decode(ParentalRating.self)
                
                expect(result).toNot(beNil())
                expect(result?.country).to(beNil())
                expect(result?.scheme).to(beNil())
                expect(result?.rating).toNot(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = ParentalRatingJSON.empty()
                let result = json.decode(ParentalRating.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension ParentalRatingSpec {
    enum ParentalRatingJSON {
        static let country = "ZA"
        static let scheme = "age"
        static let rating = "10"
        static func valid() -> [String: Codable] {
            return [
                "country": ParentalRatingJSON.country,
                "scheme": ParentalRatingJSON.scheme,
                "rating": ParentalRatingJSON.rating
            ]
        }
        
        static func missingKeys() -> [String: Codable] {
            return [
                "rating": ParentalRatingJSON.rating
            ]
        }
        
        static func empty() -> [String: Codable] {
            return [:]
        }
    }
}
