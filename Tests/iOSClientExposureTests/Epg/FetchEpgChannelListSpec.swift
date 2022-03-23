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

@testable import iOSClientExposure

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
                let endpoint = "/epg/"
                expect(allChannels.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            let channels = allChannels.filter(onlyAssetIds: channelIds)
            it("should generate a correct endpoint url with filter on channelId") {
                let escaped = URLEncoding().escape(channelIds.joined(separator: ","))
                
                let endpoint = "/epg" + "/" + escaped
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
        
        describe("FilteredAssetIds") {
            it("should record filter on assetIds") {
                let filtered = fetch
                    .channels()
                    .filter(onlyAssetIds: channelIds)
                
                expect(filtered.assetIds).toNot(beNil())
                expect(filtered.assetIds!.count).to(equal(2))
                
                let changed = filtered.filter(onlyAssetIds: ["other"])
                expect(changed.assetIds).toNot(beNil())
                expect(changed.assetIds!.count).to(equal(1))
                
                let modified = changed.filter(onlyAssetIds: nil)
                expect(modified.assetIds).to(beNil())
                
                
            }
        }
    }
}
