//
//  AnalyticsPersisterSpec.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import iOSClientExposure

struct PersistenceTestData {
    let sessionToken: SessionToken
    let environment: Environment
    let playToken: String
    let events: [AnalyticsEvent]
}


class AnalyticsPersisterSpec: QuickSpec {
    override func spec() {
        describe("Persistence") {
            let validToken = SessionToken(value: "crmToken|simpleAccount|userId|anotherField|1000|2000|false|field|finalField")
            let malformatedShortToken = SessionToken(value: "crmToken|simpleAccount|userId|anotherField|1000|2000|false|field")
            let malformatedMissingAccountIdToken = SessionToken(value: "someLongButHardlyCorrectSessionToken")
            
            let firstEnvironment = Environment(baseUrl: "firstUrl", customer: "simpleFirstCustomer", businessUnit: "simpleFirstBusinessUnit")
            it("Should persist simple batch") {
                let persister = AnalyticsPersister()
                let batch = self.firstSession(for: validToken, environment: firstEnvironment)
                expect{ try persister.persist(analytics: batch) }.toNot(throwError())
                expect{ try persister.clearAll(olderThan: Date().millisecondsSince1970) }.toNot(throwError())
            }
            
            it("Should not persist batches with sessionTokens without accountIds") {
                let persister = AnalyticsPersister()
                let invalidAccountIdBatch = self.secondSession(for: malformatedMissingAccountIdToken, environment: firstEnvironment)
                expect{ try persister.persist(analytics: invalidAccountIdBatch) }.to(throwError(PersisterError.failedToPersistMissingAccountId))
            }
            
            it("Should retrieve and remove simple pesisted batch") {
                let persister = AnalyticsPersister()
                expect{ try persister.clearAll(olderThan: Date().millisecondsSince1970) }.toNot(throwError())
                let batch = self.firstSession(for: validToken, environment: firstEnvironment)
                expect{ try persister.persist(analytics: batch) }.toNot(throwError())
                
                let accountId = validToken.accountId
                expect(accountId).toNot(beNil())
                expect{ try persister.analytics(accountId: accountId!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)}.toNot(throwError())
                let retrievedBatches = try! persister.analytics(accountId: accountId!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)
                expect(retrievedBatches.count).to(equal(1))
                expect(retrievedBatches.first!.batch.sessionToken).to(equal(validToken))
                expect(retrievedBatches.first!.batch.environment).to(equal(firstEnvironment))
                expect(retrievedBatches.first!.batch.sessionId).to(equal(batch.sessionId))
                expect(retrievedBatches.first!.batch.payload.count).to(equal(batch.payload.count))
                
                expect{ try persister.delete(persistedAnalytics: retrievedBatches.first!) }.toNot(throwError())
                
                let nowEmptyBatches = try! persister.analytics(accountId: accountId!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)
                expect(nowEmptyBatches.count).to(equal(0))
            }
        }
    }
    
    func firstSession(for session: SessionToken, environment: Environment) -> AnalyticsBatch {
        let timestamp = Date().millisecondsSince1970
        let payload: [AnalyticsEvent] = [
            Created(timestamp: timestamp+1000, version: "1.0.0"),
            Started(timestamp: timestamp+2000),
            Error(timestamp: 2000, offsetTime: 1000, code: 101, message: "An error occured"),
            Aborted(timestamp: timestamp+3000, offsetTime: 1000)
        ]
        return AnalyticsBatch(sessionToken: session,
                              environment: environment,
                              playToken: UUID().uuidString,
                              payload: payload)
    }
    
    func secondSession(for session: SessionToken, environment: Environment) -> AnalyticsBatch {
        let timestamp = Date().millisecondsSince1970
        let payload: [AnalyticsEvent] = [
            Created(timestamp: timestamp+1000, version: "1.0.0"),
            Error(timestamp: 2000, offsetTime: 1000, code: 101, message: "An error occured")
        ]
        return AnalyticsBatch(sessionToken: session,
                              environment: environment,
                              playToken: UUID().uuidString,
                              payload: payload)
    }
    
    func thirdSession(for session: SessionToken, environment: Environment) -> AnalyticsBatch {
        let timestamp = Date().millisecondsSince1970
        let payload: [AnalyticsEvent] = [
            Created(timestamp: timestamp+1000, version: "1.0.0"),
            Started(timestamp: timestamp+2000),
            Aborted(timestamp: timestamp+3000, offsetTime: 1000)
        ]
        return AnalyticsBatch(sessionToken: session,
                              environment: environment,
                              playToken: UUID().uuidString,
                              payload: payload)
    }
}
