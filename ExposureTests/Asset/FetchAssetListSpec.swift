//
//  FetchAssetListSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Exposure

class FetchAssetListSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let fetchAsset = FetchAsset(environment: env)
        let fetchList = fetchAsset.list()
        
        describe("Basics") {
            
            it("should have no headers") {
                expect(fetchList.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/content/asset"
                expect(fetchList.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = fetchList
                    .include(fields: ["first"])
                    .exclude(fields: ["notUsed"])
                    .filter(onlyPublished: true)
                    .show(page: 1, spanning: 10)
                    .filter(on: "EPISODE")
                    .filter(on: .mobile)
                    .sort(on: "test")
                    .elasticSearch(query: "type:(TV_CHANNEL MOVIE)")
                    .elasticSearch(deviceQuery: "publications.devices.os:IOS")
                    .elasticSearch(publicationQuery: "publications.countries:ALL")
                    .parameters
                
                expect(params.count).to(equal(13))
                
                expect(params["onlyPublished"]).toNot(beNil())
                expect(params["fieldSet"]).toNot(beNil())
                expect(params["excludeFields"]).toNot(beNil())
                expect(params["includeFields"]).toNot(beNil())
                expect(params["pageSize"]).toNot(beNil())
                expect(params["pageNumber"]).toNot(beNil())
                expect(params["assetType"]).toNot(beNil())
                expect(params["deviceType"]).toNot(beNil())
                expect(params["sort"]).toNot(beNil())
                expect(params["query"]).toNot(beNil())
                expect(params["deviceQuery"]).toNot(beNil())
                expect(params["publicationQuery"]).toNot(beNil())
                expect(params["includeUserData"]).toNot(beNil())
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
