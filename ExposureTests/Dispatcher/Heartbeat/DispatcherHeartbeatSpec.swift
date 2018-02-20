//
//  DispatcherSpec.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import Exposure

class DispatcherHeartbeatSpec: QuickSpec {
    let environment = Environment(baseUrl: "url", customer: "DispatcherCustomer", businessUnit: "DispatcherBusinessUnit")
    let sessionToken = SessionToken(value: "crmToken|DispatcherAccountId1|userId|anotherField|1000|2000|false|field|finalField")
    
    override func spec() {
        describe("Heartbeats") {
            let event = Started(timestamp: 1000)
            
            /// Heartbeats should be disabled by default
            it("Should have heartbeats disabled by default") {
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                expect(dispatcher.heartbeatsEnabled).to(beFalse())
            }
            
            /// Heartbeats delivery should not start before the first event is sent.
            ///
            /// Enabling heartbeats should not trigger continuous delivery if we havent started a session yet. Heartbeats are meant to indicate ongoing playback, not active `Dispatcher`s.
            it("Should not start delivering heartbeats before first event is sent") {
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                
                expect(dispatcher.heartbeatsEnabled).to(beFalse())
                
                let handler = HeartbeatNetworkHandler()
                dispatcher.networkHandler = handler
                dispatcher.flushInterval = 0.1
                dispatcher.heartbeat(enabled: true)
                
                expect(dispatcher.heartbeatsEnabled).to(beTrue())
                
                expect(handler.payloadDelivered.count).toEventually(equal(0), timeout: 6)
                expect(handler.heartbeatsDelivered.count).toEventually(equal(0), timeout: 6)
            }
            
            /// Once the first event is delivered, continuous heartbeats should be sent.
            it("Should deliver continuous heartbeats if enabled") {
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                
                expect(dispatcher.heartbeatsEnabled).to(beFalse())
                
                let handler = HeartbeatNetworkHandler()
                dispatcher.networkHandler = handler
                dispatcher.flushInterval = 0.1
                dispatcher.heartbeat(enabled: true)
                
                expect(dispatcher.heartbeatsEnabled).to(beTrue())
                expect(dispatcher.flushTriggerEnabled).to(beTrue())
                
                dispatcher.enqueue(event: event)
                
                expect(handler.payloadDelivered.count).toEventually(equal(3), timeout: 6)
                expect(handler.heartbeatsDelivered.count).toEventually(equal(2), timeout: 2)
            }
            
            /// Heartbeats should not be sent unless turned on by *client applications*
            ///
            /// Enquing a payload event should not trigger heartbeats unless heartbeats are activated
            it("Should not deliver heartbeats unless enabled") {
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                let handler = HeartbeatNetworkHandler()
                dispatcher.networkHandler = handler
                dispatcher.flushTrigger(enabled: true)
                dispatcher.flushInterval = 1
                dispatcher.enqueue(event: event)
                
                expect(dispatcher.heartbeatsEnabled).to(beFalse())
                expect(dispatcher.flushTriggerEnabled).to(beTrue())
                
                expect(handler.payloadDelivered.count).toEventually(equal(1), timeout: 6)
                expect(handler.heartbeatsDelivered.count).toEventually(equal(0), timeout: 6)
            }
            
            /// Delivering heartbeats without the flushTrigger enabled makes no sense.
            ///
            /// The flishTrigger is what actually governs the continuous delivery of events.
            /// Disabling the flush trigger thus disables heartbeats.
            it("Should not deliver heartbeats if flush trigger is disabled") {
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                let handler = HeartbeatNetworkHandler()
                dispatcher.networkHandler = handler
                dispatcher.flushInterval = 0.1
                dispatcher.heartbeat(enabled: true)
                
                expect(dispatcher.heartbeatsEnabled).to(beTrue())
                
                dispatcher.enqueue(event: event)
                dispatcher.flushTrigger(enabled: false)
                
                expect(dispatcher.heartbeatsEnabled).to(beFalse())
                expect(handler.payloadDelivered.count).toEventually(equal(1), timeout: 6)
                expect(handler.heartbeatsDelivered.count).toEventually(equal(0), timeout: 6)
            }
        }
        
        // Delivering Realtime Analytics
        //      * onError
        //          - reset state to .idle
        //          - track undelivered payload
        //              - merged with previously undelivered payload (if any)
        //          - if error is (401 - INVALID_SESSION_TOKEN), trigger lockdown
        //      * onSuccess
        //          - reset state to .idle
        //          - update configuration with new reporting interval
        //          - update configuration with lastDispatchTimestamp
        
        describe("Persistence") {
            
            it("Should persist simple batch") {
                
            }
        }
    }
}
