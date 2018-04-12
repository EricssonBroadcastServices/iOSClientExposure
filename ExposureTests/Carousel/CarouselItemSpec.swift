//
//  CarouselItemSpec.swift
//  ExposureTests
//
//  Created by Viktor Gardart on 2017-10-05.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay

@testable import Exposure

class CarouselItemSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("JSON") {
            it("should succeed with valid response") {
                let json = CarouselItemJSON.valid()
                let result = json.decode(CarouselItem.self)

                expect(result).toNot(beNil())
                expect(result?.titles).toNot(beNil())
                expect(result?.items).toNot(beNil())
                expect(result?.sortOrder).toNot(beNil())
                expect(result?.carouselId).toNot(beNil())
            }

            it("should init with partial response") {
                let json = CarouselItemJSON.missingKeys()
                let result = json.decode(CarouselItem.self)

                expect(result).toNot(beNil())
                expect(result?.carouselId).toNot(beNil())
                expect(result?.items).to(beNil())
                expect(result?.sortOrder).to(beNil())
                expect(result?.titles).to(beNil())
            }

            it("should init with empty response") {
                let json = CarouselItemJSON.empty()
                let result = json.decode(CarouselItem.self)
                expect(result).toNot(beNil())
            }
        }
    }
}

extension CarouselItemSpec {
    enum CarouselItemJSON {
        static let id = "abc123"
        static let sortOrder = 10
        static let items = AssetListSpec.AssetListJSON.valid()
        static let titles = [LocalizedDataSpec.LocalizedDataJSON.valid()]
        static func valid() -> [String: Any] {
            return [
                "carouselId": CarouselItemJSON.id,
                "sortOrder": CarouselItemJSON.sortOrder,
                "titles": CarouselItemJSON.titles,
                "items": CarouselItemJSON.items
            ]
        }

        static func missingKeys() -> [String: Any] {
            return [
                "carouselId": CarouselItemJSON.id
            ]
        }

        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
