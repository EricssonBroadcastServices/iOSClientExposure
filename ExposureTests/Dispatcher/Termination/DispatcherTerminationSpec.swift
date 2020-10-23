//
//  DispatcherTerminationSpec.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import Exposure

class DispatcherTerminationSpec: QuickSpec {
    let environment = Environment(baseUrl: "url", customer: "DispatcherCustomer", businessUnit: "DispatcherBusinessUnit")
    let sessionToken = SessionToken(value: "crmToken|DispatcherAccountId1|userId|anotherField|1000|2000|false|field|finalField")
    
    let deliverUndelivered = TerminationNetworkHandler()
    let persistUndelivered = TerminationNetworkHandler()
    override func spec() {
        describe("Termination") {
            //
            // Termination
            //      * disables
            //          - flushTrigger
            //          - heartbeats
            //      * deliver current batch (if ready)
            //          - onError
            //              - persist undelivered batch
            //
            
            let event = Started(timestamp: 1000)
            
            it("Should disable flush trigger and heartbeats on termination") {
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                dispatcher.heartbeat(enabled: true)
                dispatcher.flushTrigger(enabled: true)
                dispatcher.terminate()
                expect(dispatcher.heartbeatsEnabled).to(beFalse())
                expect(dispatcher.flushTriggerEnabled).to(beFalse())
            }
            
            it("Should dispatch undelivered payload on termination") {
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: [event]) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                dispatcher.networkHandler = self.deliverUndelivered
                dispatcher.terminate()
                expect(self.deliverUndelivered.payloadDelivered.count).toEventually(equal(1), timeout: .seconds(6))
            }
            
//            it("Should persist underlivered analytics that failed to dispatch on termination") {
//                let persister = AnalyticsPersister()
//                expect{ try persister.analytics(accountId: self.sessionToken.accountId!, businessUnit: self.environment.businessUnit, customer: self.environment.customer).count }.toEventually(equal(0))
//
//                let dispatcher = Dispatcher(environment: self.environment,
//                                            sessionToken: self.sessionToken,
//                                            playSessionId: "Termination-dispatch-persistence-id",
//                                            startupEvents: [event]) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
//                self.persistUndelivered.failsToDispatch = true
//                dispatcher.networkHandler = self.persistUndelivered
//                dispatcher.terminate()
//
//                expect(self.persistUndelivered.payloadDelivered.count).toEventually(equal(0), timeout: 6)
//                expect(self.sessionToken.accountId).toNot(beNil())
//                expect{ try persister.analytics(accountId: self.sessionToken.accountId!, businessUnit: self.environment.businessUnit, customer: self.environment.customer)}.toNot(throwError())
//                expect{ try persister.analytics(accountId: self.sessionToken.accountId!, businessUnit: self.environment.businessUnit, customer: self.environment.customer).count }.toEventually(equal(1))
//            }
        }
    }
}
