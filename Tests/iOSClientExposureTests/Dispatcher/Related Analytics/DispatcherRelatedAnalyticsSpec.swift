//
//  DispatcherRelatedAnalyticsSpec.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import iOSClientExposure

class DispatcherRelatedAnalyticsSpec: QuickSpec {
    let environment = Environment(baseUrl: "url", customer: "RelatedDispatchCustomer", businessUnit: "RelatedDispatchBusinessUnit")
    let sessionToken = SessionToken(value: "crmToken|RelatedDispatchAccountId1|userId|anotherField|1000|2000|false|field|finalField")
    let oldButRelatedToken = SessionToken(value: "anotherCrmToken|RelatedDispatchAccountId1|userId|changedField|1111|2222|false|otherField|RealyFinalField")
    let unrelatedAccountId = SessionToken(value: "anotherCrmToken|CompletelyDifferentAccountId|userId|changedField|1111|2222|false|otherField|RealyFinalField")
    
    override func spec() {
        describe("Related Analytics") {
            // Process Related Analytics
            //      * fetch only accountRelated `PersistedAnalytics` and deliver them
            //      * onError
            //          - if (401 - INVALID_SESSION_TOKEN)
            //              - attempt to match against currentBatch's accountId and deliver on that sessionToken
            //          - let batch remain on disk
            //      * onSuccess
            //          - delete delivered batch from disk
            //
            
            let event = Started(timestamp: 1000)
            
            it("Should deliver previously persisted analytics before current batch") {
                let persistedBatch = AnalyticsBatch(sessionToken: self.sessionToken,
                                                    environment: self.environment,
                                                    playToken: UUID().uuidString,
                                                    payload: [event])
                let persister = AnalyticsPersister()
                expect{ try persister.persist(analytics: persistedBatch) }.toNot(throwError())
                expect{ try persister.analytics(accountId: self.sessionToken.accountId!, businessUnit: self.environment.businessUnit, customer: self.environment.customer
                    ).count }.to(equal(1))
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                
                let networkHandler = RelatedAnalyticsNetworkHandler()
                dispatcher.networkHandler = networkHandler
                
                let completed = Started(timestamp: 1000)
                dispatcher.enqueue(event: completed)
                dispatcher.flush(forced: true)
                
                expect{ try persister.analytics(accountId: self.sessionToken.accountId!, businessUnit: self.environment.businessUnit, customer: self.environment.customer
                    ).count }.toEventually(equal(0))
                
                expect(networkHandler.payloadDelivered.count).toEventually(equal(2), timeout: .seconds(10))
            }
            
            it("Should attempt redelivery of persistent payload using SessionToken with shared accountId") {
                let persistedBatch = AnalyticsBatch(sessionToken: self.oldButRelatedToken,
                                                    environment: self.environment,
                                                    playToken: "OldPlayTokenForSameAccountId",
                                                    payload: [event])
                let persister = AnalyticsPersister()
                expect(self.oldButRelatedToken.accountId).toNot(beNil())
                expect{ try persister.persist(analytics: persistedBatch) }.toNot(throwError())
                expect{ try persister.analytics(accountId: self.oldButRelatedToken.accountId!, businessUnit: self.environment.businessUnit, customer: self.environment.customer
                    ).count }.to(equal(1))
                
                
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }
                
                let networkHandler = RelatedAnalyticsNetworkHandler()
                networkHandler.deliveryResult = .failsWithInvalidSessionToken
                dispatcher.networkHandler = networkHandler
                
                let completed = Started(timestamp: 1000)
                dispatcher.enqueue(event: completed)
                dispatcher.flush(forced: true)
                
                expect{ try persister.analytics(accountId: self.oldButRelatedToken.accountId!, businessUnit: self.environment.businessUnit, customer: self.environment.customer
                    ).count }.toEventually(equal(0))
                
                expect(networkHandler.payloadDelivered.count).toEventually(equal(2), timeout: .seconds(10))
            }
            
            
            it("Should not attempt redelivery of persisted payload with unrelated accountId") {
                let persistedBatch = AnalyticsBatch(sessionToken: self.unrelatedAccountId,
                                                    environment: self.environment,
                                                    playToken: "UnrelatedAccountIdPlayToken",
                                                    payload: [event])
                let persister = AnalyticsPersister()
                expect(self.unrelatedAccountId.accountId).toNot(beNil())
                expect{ try persister.persist(analytics: persistedBatch) }.toNot(throwError())
                expect{ try persister.analytics(accountId: self.unrelatedAccountId.accountId!, businessUnit: self.environment.businessUnit, customer: self.environment.customer
                    ).count }.to(equal(1))
                
                
                let dispatcher = Dispatcher(environment: self.environment,
                                            sessionToken: self.sessionToken,
                                            playSessionId: UUID().uuidString,
                                            startupEvents: []) { return MockedHeartbeat(timestamp: Date().millisecondsSince1970, offsetTime: 1000) }

                let networkHandler = RelatedAnalyticsNetworkHandler()
                networkHandler.deliveryResult = .success
                dispatcher.networkHandler = networkHandler

                let completed = Started(timestamp: 1000)
                dispatcher.enqueue(event: completed)
                dispatcher.flush(forced: true)
                
                expect{ try persister.analytics(accountId: self.unrelatedAccountId.accountId!, businessUnit: self.environment.businessUnit, customer: self.environment.customer
                    ).count }.toEventually(equal(1))
                
                expect(networkHandler.payloadDelivered.count).toEventually(equal(1), timeout: .seconds(10))
                
                expect{ try persister.clearAll(olderThan: Date().millisecondsSince1970) }.toNot(throwError())
                expect{ try persister.analytics(accountId: self.sessionToken.accountId!, businessUnit: self.environment.businessUnit, customer: self.environment.customer
                    ).count }.toEventually(equal(0))
            }
        }
    }
}
