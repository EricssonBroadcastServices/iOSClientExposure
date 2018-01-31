//
//  AnalyticsBatchSpec.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import Exposure

class AnalyticsBatchSpec: QuickSpec {
    override func spec() {
        
        describe("Buffertime") {
            it("Should sort and return the shortest buffertime") {
                let payload: [AnalyticsEvent] = [
                    Started(timestamp: 1000),
                    Aborted(timestamp: 2000, offsetTime: 1000)
                ]
                
                let token = SessionToken(value: "someToken")
                let environment = Environment(baseUrl: "firstUrl", customer: "FirstCustomer", businessUnit: "Aunit")
                let batch = AnalyticsBatch(sessionToken: token, environment: environment, playToken: "PlayToken", payload: payload)
                
                let buffertime = batch.bufferLimit()
                expect(buffertime).toNot(beNil())
                expect(buffertime).to(equal(4000))
            }
            
            it("Should return no buffertime without payload") {
                let token = SessionToken(value: "someToken")
                let environment = Environment(baseUrl: "firstUrl", customer: "FirstCustomer", businessUnit: "Aunit")
                let batch = AnalyticsBatch(sessionToken: token, environment: environment, playToken: "PlayToken", payload: [])
                
                let buffertime = batch.bufferLimit()
                expect(buffertime).to(beNil())
            }
        }
    }
}
