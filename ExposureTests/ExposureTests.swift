//
//  ExposureTests.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-04-19.
//  Copyright © 2017 emp. All rights reserved.
//

import XCTest
@testable import Exposure

import Quick
import Nimble


class HTTPMethodTests: QuickSpec {
    override func spec() {
        describe("SessionToken") {
            it("should return Authorization header") {
                let token = SessionToken(value: "Token")
                expect(token).toNot(beNil())
                
                
            }
        }
    }
}
