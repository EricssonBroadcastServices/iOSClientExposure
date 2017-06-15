//
//  FetchEpgChannelListSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay

@testable import Exposure

class FetchEpgSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let channelIds = ["first","second"]
        let fetch = FetchEpg(environment: env)
        
        describe("Single Channel") {
            let channel = fetch.channel(id: channelIds.first!)
            
            it("should have no headers") {
                expect(channel.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/epg/\(channelIds.first!)"
                expect(channel.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = channel
                    .filter(onlyPublished: true)
                    .show(page: 1, spanning: 10)
                    .sort(on: "test")
                    .filter(ending: Date())
                    .parameters
                
                expect(params.count).to(equal(6))
                expect(params["onlyPublished"]).toNot(beNil())
                expect(params["pageSize"]).toNot(beNil())
                expect(params["pageNumber"]).toNot(beNil())
                expect(params["sort"]).toNot(beNil())
                expect(params["from"]).toNot(beNil())
                expect(params["to"]).toNot(beNil())
            }
        }
        
        describe("Multi Channel") {
            let allChannels = fetch.channels()
            
            it("should have no headers") {
                expect(allChannels.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url with no filter on channelId") {
                let endpoint = "/epg"
                expect(allChannels.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            let channels = allChannels.filter(onlyAssetIds: channelIds)
            it("should generate a correct endpoint url with filter on channelId") {
                let endpoint = "/epg" + "/" + channelIds.joined(separator: ",")
                expect(channels.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = allChannels
                    .filter(onlyPublished: true)
                    .show(page: 1, spanning: 10)
                    .sort(on: "test")
                    .filter(starting: 0, ending: 10)
                    .parameters
                
                expect(params.count).to(equal(6))
                expect(params["onlyPublished"]).toNot(beNil())
                expect(params["pageSize"]).toNot(beNil())
                expect(params["pageNumber"]).toNot(beNil())
                expect(params["sort"]).toNot(beNil())
                expect(params["from"]).toNot(beNil())
                expect(params["to"]).toNot(beNil())
            }
        }
        /*
        describe("PageableResponse") {
            it("should record page size and number") {
                let size = fetchList.show(page: 1)
                
                expect(size.pageNumber).to(equal(1))
                expect(size.pageSize).to(equal(50))
                
                let modified = size.show(page: 2, spanning: 10)
                
                expect(modified.pageNumber).to(equal(2))
                expect(modified.pageSize).to(equal(10))
            }
        }*/
        /*
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
        }*/
    }
}
