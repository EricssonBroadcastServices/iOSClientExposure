//
//  FetchLastViewedOffsetList.swift
//  Exposure
//
//  Created by Johnny Sundblom on 2020-02-20.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import iOSClientExposure

class FetchLastViewedOffsetListSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let sessionToken = SessionToken(value: "token")
        
        let fetchLastViewedOffset = FetchLastViewedOffset(environment: env, sessionToken: sessionToken)
        let fetchLastViewedOffsetList = fetchLastViewedOffset.list(assetIds: [])
        
        describe("Basics") {
            
            it("should have no headers") {
                expect(fetchLastViewedOffsetList.headers).toNot(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/userplayhistory/lastviewedoffset"
                expect(fetchLastViewedOffsetList.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate parameters") {
                let params = fetchLastViewedOffsetList
                    .sort(on: "test")
                    .parameters

                expect(params.count).to(equal(2))
                expect(params["assetIds"]).toNot(beNil())
                expect(params["sort"]).toNot(beNil())
            }
        }
        
        describe("SortedResponse") {
            it("should store sort params") {
                let sorted = fetchLastViewedOffsetList
                    .sort(on: "first")
                    .thenSort(on: "second", ascending: false)
                    .thenSort(on: SortDescriptor(key: "third"))
                
                expect(sorted.sortDescriptors).toNot(beNil())
                expect(sorted.sortDescriptors!.count).to(equal(3))
                
                let reset = sorted
                    .thenSort(on: [SortDescriptor(key: "fourth")])
                    .sort(on: "fifth")
                
                expect(reset.sortDescriptors).toNot(beNil())
                expect(reset.sortDescriptors!.count).to(equal(1))
                
                let regex = fetchLastViewedOffsetList
                    .sort(on: ["first","-second","-third"])
                    .thenSort(on: ["fourth"])
                expect(regex.sortDescriptors).toNot(beNil())
                expect(regex.sortDescriptors!.count).to(equal(4))
                
                let startEmpty = fetchLastViewedOffsetList
                    .thenSort(on: SortDescriptor(key: "first"))
                expect(startEmpty.sortDescriptors).toNot(beNil())
                expect(startEmpty.sortDescriptors!.count).to(equal(1))
                
                let faultyRegex = fetchLastViewedOffsetList
                    .sort(on: SortDescriptor(key: "first"))
                    .thenSort(on: ["-","","-correct"])
                expect(faultyRegex.sortDescriptors).toNot(beNil())
                expect(faultyRegex.sortDescriptors!.count).to(equal(2))
            }
        }
    }
}
