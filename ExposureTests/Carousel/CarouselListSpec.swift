//
//  CarouselListSpec.swift
//  ExposureTests
//
//  Created by Viktor Gardart on 2017-10-05.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Exposure

class CarouselListSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("JSON") {
            it("should succeed with valid response") {
                guard let data = try? JSONSerialization.data(withJSONObject: CarouselListJSON.valid(),
                                                             options: .prettyPrinted) else { return fail("Could not decode CarouselListJSON") }
                let result = try? JSONDecoder().decode(CarouselList.self,
                                                       from: data)

                expect(result).toNot(beNil())
                expect(result?.items).toNot(beNil())
                expect(result?.items?.count).to(equal(2))
            }

            it("should init with empty response") {
                guard let data = try? JSONSerialization.data(withJSONObject: CarouselListJSON.empty(),
                                                             options: .prettyPrinted) else { return fail("Could not decode CarouselListJSON") }
                let result = try? JSONDecoder().decode(CarouselList.self,
                                                       from: data)
                expect(result).toNot(beNil())
                expect(result?.items).to(beEmpty())
            }
        }
    }
}

extension CarouselListSpec {
    enum CarouselListJSON {
        static let items = [
            CarouselItemSpec.CarouselItemJSON.valid(),
            CarouselItemSpec.CarouselItemJSON.valid(),
        ]
        static func valid() -> [[String: Any]] {
            return CarouselListJSON.items
        }

        static func empty() -> [[String: Any]] {
            return []
        }
    }
}



