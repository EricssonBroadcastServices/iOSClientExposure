//
//  CustomerConfigFileSpec.swift
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

class CustomerConfigFileSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("JSON") {
            it("should succeed with valid response") {
                let json = FileJSON.valid()
                let result = json.decode(CustomerConfig.File.self)

                expect(result).toNot(beNil())
                expect(result?.customer).toNot(beNil())
                expect(result?.businessUnit).toNot(beNil())
                expect(result?.fileName).toNot(beNil())
                expect(result?.config).toNot(beNil())
            }

            it("should init with partial response") {
                let json = FileJSON.missingKeys()
                let result = json.decode(CustomerConfig.File.self)
                expect(result).to(beNil())
            }

            it("should init with empty response") {
                let json = FileJSON.empty()
                let result = json.decode(CustomerConfig.File.self)
                expect(result).to(beNil())
            }
        }
    }
}

extension CustomerConfigFileSpec {
    enum FileJSON {
        static let customer = "BlixtGroup"
        static let businessUnit = "Blixt"
        static let fileName = "main.json"
        static let config = [
            "hello": "world",
            "this": "works"
        ]

        static func valid() -> [String: Any] {
            return [
                "customer": FileJSON.customer,
                "businessUnit": FileJSON.businessUnit,
                "fileName": FileJSON.fileName,
                "config": FileJSON.config
            ]
        }

        static func missingKeys() -> [String: Any] {
            return [
                "customer": FileJSON.customer
            ]
        }

        static func empty() -> [String: Any] {
            return [:]
        }
    }
}

