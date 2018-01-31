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
@testable import Exposure

struct PersistenceTestData {
    let sessionToken: SessionToken
    let environment: Environment
    let playToken: String
    let events: [AnalyticsEvent]
}


class AnalyticsPersisterSpec: QuickSpec {
    override func spec() {
        let validToken = SessionToken(value: "crmToken|accountId1|userId|anotherField|1000|2000|false|field|finalField")
        let anotherValidToken = SessionToken(value: "crmToken|accountId1|userId|anotherField|1000|2000|false|field|finalField")
        let validButDifferentAccountToken = SessionToken(value: "crmToken|accountId2|userId|anotherField|1000|2000|false|field|finalField")
        let malformatedShortToken = SessionToken(value: "crmToken|accountId|userId|anotherField|1000|2000|false|field")
        let malformatedMissingAccountIdToken = SessionToken(value: "someLongButHardlyCorrectSessionToken")
        
        let firstEnvironment = Environment(baseUrl: "firstUrl", customer: "FirstCustomer", businessUnit: "BusinessUnit1")
        let secondEnvironment = Environment(baseUrl: "firstUrl", customer: "FirstCustomer", businessUnit: "BusinessUnit2")
        
        let thirdEnvironment = Environment(baseUrl: "firstUrl", customer: "SecondCustomer", businessUnit: "BusinessUnit1")
        
        let persister = AnalyticsPersister()
        
        describe("Persistence") {
            let batch = self.firstSession(for: validToken, environment: firstEnvironment)
            it("Should persist simple batch") {
                expect{ try persister.persist(analytics: batch) }.toNot(throwError())
            }
            
            it("Should not persist batches with malformatted sessionTokens") {
                let malformattedTokenBatch = self.firstSession(for: malformatedShortToken, environment: firstEnvironment)
                expect{ try persister.persist(analytics: malformattedTokenBatch) }.to(throwError(PersisterError.failedToPersistWithMalformattedSessionToken))
            }
            
            it("Should not persist batches with sessionTokens without accountIds") {
                let invalidAccountIdBatch = self.secondSession(for: malformatedMissingAccountIdToken, environment: firstEnvironment)
                expect{ try persister.persist(analytics: invalidAccountIdBatch) }.to(throwError(PersisterError.failedToPersistMissingAccountId))
            }
            
            it("Should retrieve and remove simple pesisted batch") {
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
        
        describe("Multiple Customers and BusinessUnits") {
            /// batch-x-y-z-w where
            /// x: accountId
            /// y: customer
            /// z: businessUnit
            /// w: playSession
            let batch1111 = self.firstSession(for: validToken, environment: firstEnvironment)
            let batch1112 = self.secondSession(for: validToken, environment: firstEnvironment)
            let batch1113 = self.thirdSession(for: validToken, environment: firstEnvironment)
            
            let batch1121 = self.firstSession(for: validToken, environment: secondEnvironment)
            let batch1114 = self.firstSession(for: anotherValidToken, environment: firstEnvironment)
            let batch1122 = self.firstSession(for: anotherValidToken, environment: secondEnvironment)
            
            let batch2111 = self.firstSession(for: validButDifferentAccountToken, environment: firstEnvironment)
            let batch2121 = self.firstSession(for: validButDifferentAccountToken, environment: secondEnvironment)
            let batch1231 = self.thirdSession(for: anotherValidToken, environment: thirdEnvironment)
            let batch2231 = self.thirdSession(for: validButDifferentAccountToken, environment: thirdEnvironment)
            
            it("Should persist and return multiple sessions") {
                let accountId1 = validToken.accountId
                expect(accountId1).toNot(beNil())
                
                let accountId2 = validButDifferentAccountToken.accountId
                expect(accountId2).toNot(beNil())
                
                expect{ try persister.persist(analytics:  batch1111) }.toNot(throwError())
                expect{ try persister.persist(analytics:  batch1112) }.toNot(throwError())
                expect{ try persister.persist(analytics:  batch1113) }.toNot(throwError())
                
                expect{ try persister.persist(analytics:  batch1121) }.toNot(throwError())
                expect{ try persister.persist(analytics:  batch1114) }.toNot(throwError())
                expect{ try persister.persist(analytics:  batch1122) }.toNot(throwError())
                
                expect{ try persister.persist(analytics:  batch2111) }.toNot(throwError())
                expect{ try persister.persist(analytics:  batch2121) }.toNot(throwError())
                expect{ try persister.persist(analytics:  batch1231) }.toNot(throwError())
                expect{ try persister.persist(analytics:  batch2231) }.toNot(throwError())
                
                /// Fetch all batches for
                /// 1. accountId: accountId1 (ie validToken && anotherValidToken)
                /// 2. customer: FirstCustomer
                /// 3. businessUnit: BusinessUnit1
                expect{ try persister.analytics(accountId: accountId1!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)}.toNot(throwError())
                let retrieved111 = try! persister.analytics(accountId: accountId1!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)
                expect(retrieved111.count).to(equal(4))
                
                /// Fetch all batches for
                /// 1. accountId: accountId1 (ie validToken && anotherValidToken)
                /// 2. customer: FirstCustomer
                /// 3. businessUnit: BusinessUnit2
                expect{ try persister.analytics(accountId: accountId1!, businessUnit: secondEnvironment.businessUnit, customer: secondEnvironment.customer)}.toNot(throwError())
                let retrieved112 = try! persister.analytics(accountId: accountId1!, businessUnit: secondEnvironment.businessUnit, customer: secondEnvironment.customer)
                expect(retrieved112.count).to(equal(2))
                
                /// Fetch all batches for
                /// 1. accountId: accountId1 (ie validToken && anotherValidToken)
                /// 2. customer: SecondCustomer
                /// 3. businessUnit: BusinessUnit1
                expect{ try persister.analytics(accountId: accountId1!, businessUnit: thirdEnvironment.businessUnit, customer: thirdEnvironment.customer)}.toNot(throwError())
                let retrieved123 = try! persister.analytics(accountId: accountId1!, businessUnit: thirdEnvironment.businessUnit, customer: thirdEnvironment.customer)
                expect(retrieved123.count).to(equal(1))
                
                /// Fetch all batches for
                /// 1. accountId: accountId2 (ie validButDifferentAccountToken)
                /// 2. customer: FirstCustomer
                /// 3. businessUnit: BusinessUnit1
                expect{ try persister.analytics(accountId: accountId2!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)}.toNot(throwError())
                let retrieved211 = try! persister.analytics(accountId: accountId2!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)
                expect(retrieved211.count).to(equal(1))
                
                /// Fetch all batches for
                /// 1. accountId: accountId2 (ie validButDifferentAccountToken)
                /// 2. customer: FirstCustomer
                /// 3. businessUnit: BusinessUnit2
                expect{ try persister.analytics(accountId: accountId2!, businessUnit: secondEnvironment.businessUnit, customer: secondEnvironment.customer)}.toNot(throwError())
                let retrieved212 = try! persister.analytics(accountId: accountId2!, businessUnit: secondEnvironment.businessUnit, customer: secondEnvironment.customer)
                expect(retrieved212.count).to(equal(1))
                
                /// Fetch all batches for
                /// 1. accountId: accountId2 (ie validButDifferentAccountToken)
                /// 2. customer: SecondCustomer
                /// 3. businessUnit: BusinessUnit1
                expect{ try persister.analytics(accountId: accountId2!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)}.toNot(throwError())
                let retrieved222 = try! persister.analytics(accountId: accountId2!, businessUnit: thirdEnvironment.businessUnit, customer: thirdEnvironment.customer)
                expect(retrieved222.count).to(equal(1))
            }
            
            it("Should clear all analytics older than specified timestamp") {
                let accountId1 = validToken.accountId
                expect(accountId1).toNot(beNil())
                
                let accountId2 = validButDifferentAccountToken.accountId
                expect(accountId2).toNot(beNil())
                
                expect{ try persister.clearAll(olderThan: Date().millisecondsSince1970) }.toNot(throwError())
                
                /// Fetch all batches for
                /// 1. accountId: accountId1 (ie validToken && anotherValidToken)
                /// 2. customer: FirstCustomer
                /// 3. businessUnit: BusinessUnit1
                expect{ try persister.analytics(accountId: accountId1!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)}.toNot(throwError())
                let retrieved111 = try! persister.analytics(accountId: accountId1!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)
                expect(retrieved111.count).to(equal(0))
                
                /// Fetch all batches for
                /// 1. accountId: accountId1 (ie validToken && anotherValidToken)
                /// 2. customer: FirstCustomer
                /// 3. businessUnit: BusinessUnit2
                expect{ try persister.analytics(accountId: accountId1!, businessUnit: secondEnvironment.businessUnit, customer: secondEnvironment.customer)}.toNot(throwError())
                let retrieved112 = try! persister.analytics(accountId: accountId1!, businessUnit: secondEnvironment.businessUnit, customer: secondEnvironment.customer)
                expect(retrieved112.count).to(equal(0))
                
                /// Fetch all batches for
                /// 1. accountId: accountId1 (ie validToken && anotherValidToken)
                /// 2. customer: SecondCustomer
                /// 3. businessUnit: BusinessUnit1
                expect{ try persister.analytics(accountId: accountId1!, businessUnit: thirdEnvironment.businessUnit, customer: thirdEnvironment.customer)}.toNot(throwError())
                let retrieved123 = try! persister.analytics(accountId: accountId1!, businessUnit: thirdEnvironment.businessUnit, customer: thirdEnvironment.customer)
                expect(retrieved123.count).to(equal(0))
                
                /// Fetch all batches for
                /// 1. accountId: accountId2 (ie validButDifferentAccountToken)
                /// 2. customer: FirstCustomer
                /// 3. businessUnit: BusinessUnit1
                expect{ try persister.analytics(accountId: accountId2!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)}.toNot(throwError())
                let retrieved211 = try! persister.analytics(accountId: accountId2!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)
                expect(retrieved211.count).to(equal(0))
                
                /// Fetch all batches for
                /// 1. accountId: accountId2 (ie validButDifferentAccountToken)
                /// 2. customer: FirstCustomer
                /// 3. businessUnit: BusinessUnit2
                expect{ try persister.analytics(accountId: accountId2!, businessUnit: secondEnvironment.businessUnit, customer: secondEnvironment.customer)}.toNot(throwError())
                let retrieved212 = try! persister.analytics(accountId: accountId2!, businessUnit: secondEnvironment.businessUnit, customer: secondEnvironment.customer)
                expect(retrieved212.count).to(equal(0))
                
                /// Fetch all batches for
                /// 1. accountId: accountId2 (ie validButDifferentAccountToken)
                /// 2. customer: SecondCustomer
                /// 3. businessUnit: BusinessUnit1
                expect{ try persister.analytics(accountId: accountId2!, businessUnit: firstEnvironment.businessUnit, customer: firstEnvironment.customer)}.toNot(throwError())
                let retrieved222 = try! persister.analytics(accountId: accountId2!, businessUnit: thirdEnvironment.businessUnit, customer: thirdEnvironment.customer)
                expect(retrieved222.count).to(equal(0))
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
