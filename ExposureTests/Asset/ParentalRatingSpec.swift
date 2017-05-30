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
                let value = ParentalRating(json: ParentalRatingJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.country).toNot(beNil())
                expect(value!.scheme).toNot(beNil())
                expect(value!.rating).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = ParentalRating(json: ParentalRatingJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.country).to(beNil())
                expect(value!.scheme).to(beNil())
                expect(value!.rating).toNot(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = ParentalRating(json: ParentalRatingJSON.empty())
                
                expect(value).to(beNil())
            }
        }
    }
}

extension ParentalRatingSpec {
    enum ParentalRatingJSON {
        static let country = "ZA"
        static let scheme = "age"
        static let rating = "10"
        static func valid() -> Any {
            return [
                "country": ParentalRatingJSON.country,
                "scheme": ParentalRatingJSON.scheme,
                "rating": ParentalRatingJSON.rating
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "rating": ParentalRatingJSON.rating
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
