//
//  DispatcherFlushTriggerSpec.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-18.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import Exposure

class DispatcherFlushTriggerSpec: QuickSpec {
    let environment = Environment(baseUrl: "url", customer: "DispatcherCustomer", businessUnit: "DispatcherBusinessUnit")
    let sessionToken = SessionToken(value: "crmToken|DispatcherAccountId1|userId|anotherField|1000|2000|false|field|finalField")
    
    override func spec() {
        describe("Flush Trigger") {
            //
            // Enqueue events should
            //      * update current batch with new playload
            //      * trigger flush(forced: false)
            //
            
            let event = Started(timestamp: 1000)
            
            /// Flush trigger should be disabled by default
            it("Should have flush trigger disabled by default") {
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                expect(dispatcher.flushTriggerEnabled).to(beFalse())
            }
            
            it("Should enable flush trigger when instructed") {
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                dispatcher.flushTrigger(enabled: true)
                expect(dispatcher.flushTriggerEnabled).to(beTrue())
            }
            
            it("Should disable heartbeast when flush trigger is disabled") {
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                dispatcher.flushTrigger(enabled: true)
                dispatcher.heartbeat(enabled: true)
                
                expect(dispatcher.flushTriggerEnabled).to(beTrue())
                expect(dispatcher.heartbeatsEnabled).to(beTrue())
                
                dispatcher.flushTrigger(enabled: false)
                
                expect(dispatcher.flushTriggerEnabled).to(beFalse())
                expect(dispatcher.heartbeatsEnabled).to(beFalse())
            }
            
            it("Should force flush payload when flush trigger is disabled") {
                let events = [Started(timestamp: 1000)]
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: events) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                let networkHandler = FlushTriggerNetworkHandler()
                dispatcher.networkHandler = networkHandler
                dispatcher.flushTrigger(enabled: false)
                
                expect(networkHandler.payloadDelivered.count).toEventually(equal(1), timeout: .seconds(6))
            }
        }
    }
}
