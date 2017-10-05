//
//  CustomerConfigSpec.swift
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

class CustomerConfigSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("JSON") {
            it("should succeed with valid response") {
                let json = CustomerConfigJSON.valid()
                let result = json.decode(CustomerConfig.self)

                expect(result).toNot(beNil())
                expect(result?.customer).toNot(beNil())
                expect(result?.businessUnit).toNot(beNil())
                expect(result?.fileNames).toNot(beNil())
                expect(result?.fileNames.count).to(equal(1))
            }

            it("should init with partial response") {
                let json = CustomerConfigJSON.missingKeys()
                let result = json.decode(CustomerConfig.self)
                expect(result).to(beNil())
            }

            it("should init with empty response") {
                let json = CustomerConfigJSON.empty()
                let result = json.decode(CustomerConfig.self)
                expect(result).to(beNil())
            }
        }
    }
}

extension CustomerConfigSpec {
    enum CustomerConfigJSON {
        static let customer = "BlixtGroup"
        static let businessUnit = "Blixt"
        static let fileNames = [
            "main.json"
        ]

        static func valid() -> [String: Codable] {
            return [
                "customer": CustomerConfigJSON.customer,
                "businessUnit": CustomerConfigJSON.businessUnit,
                "fileNames": CustomerConfigJSON.fileNames,
            ]
        }

        static func missingKeys() -> [String: Codable] {
            return [
                "customer": CustomerConfigJSON.customer
            ]
        }

        static func empty() -> [String: Codable] {
            return [:]
        }
    }
}

