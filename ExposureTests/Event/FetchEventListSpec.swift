//
//  FetchEventListSpec.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2019-09-17.
//  Copyright © 2019 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class FetchEventSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let date = "2019-09-17"
        
        env.version = "v2"
        
        let fetchAsset = FetchEvent(environment: env)
        let fetchList = fetchAsset.list(date: date)
        
        describe("Basics") {
            
            it("should pass with no headers") {
                expect(fetchList.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/event/date/" + date
                expect(fetchList.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = fetchList
                    .filter(daysBackward: 2, daysForward: 2)
                    .show(page: 1, spanning: 10)
                    .sort(on: "test")
                    .parameters
                
                expect(params["daysBackward"]).toNot(beNil())
                expect(params["daysForward"]).toNot(beNil())
                expect(params["pageSize"]).toNot(beNil())
                expect(params["pageNumber"]).toNot(beNil())
                expect(params["sort"]).toNot(beNil())
                
            }
        }
        
        describe("PageableResponse") {
            it("should have values for days backward & days forward") {
                let filter = fetchList.filter(daysBackward: 2, daysForward: 2)
                
                expect(filter.eventDateFilter.daysBackward).toNot(beNil())
                expect(filter.eventDateFilter.daysForward).toNot(beNil())
            }
        }
        
        describe("PageableResponse") {
            it("should record page size and number") {
                let size = fetchList.show(page: 1)
                
                expect(size.pageNumber).to(equal(1))
                expect(size.pageSize).to(equal(50))
                
                let modified = size.show(page: 2, spanning: 10)
                
                expect(modified.pageNumber).to(equal(2))
                expect(modified.pageSize).to(equal(10))
            }
        }
        
        describe("SortedResponse") {
            it("should store sort params") {
                let sorted = fetchList
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
                
                let regex = fetchList
                    .sort(on: ["first","-second","-third"])
                    .thenSort(on: ["fourth"])
                expect(regex.sortDescriptors).toNot(beNil())
                expect(regex.sortDescriptors!.count).to(equal(4))
                
                let startEmpty = fetchList
                    .thenSort(on: SortDescriptor(key: "first"))
                expect(startEmpty.sortDescriptors).toNot(beNil())
                expect(startEmpty.sortDescriptors!.count).to(equal(1))
                
                let faultyRegex = fetchList
                    .sort(on: SortDescriptor(key: "first"))
                    .thenSort(on: ["-","","-correct"])
                expect(faultyRegex.sortDescriptors).toNot(beNil())
                expect(faultyRegex.sortDescriptors!.count).to(equal(2))
            }
        }
    }
}
