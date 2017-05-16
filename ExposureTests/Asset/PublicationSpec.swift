//
//  PublicationSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class PublicationSpec: QuickSpec {
    
    typealias Publication = Asset.Publication
    
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let value = Publication(json: PublicationJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.publicationDate).toNot(beNil())
                expect(value!.fromDate).toNot(beNil())
                expect(value!.toDate).toNot(beNil())
                expect(value!.countries).toNot(beNil())
                expect(value!.services).toNot(beNil())
                expect(value!.products).toNot(beNil())
                expect(value!.publicationId).toNot(beNil())
                expect(value!.customData).toNot(beNil())
                expect(value!.rights).toNot(beNil())
                expect(value!.devices).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = Publication(json: PublicationJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.publicationDate).toNot(beNil())
                expect(value!.fromDate).to(beNil())
                expect(value!.toDate).to(beNil())
                expect(value!.countries).to(beNil())
                expect(value!.services).to(beNil())
                expect(value!.products).to(beNil())
                expect(value!.publicationId).to(beNil())
                expect(value!.customData).to(beNil())
                expect(value!.rights).to(beNil())
                expect(value!.devices).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = Publication(json: PublicationJSON.empty())
                
                expect(value).to(beNil())
            }
        }
    }
}

extension PublicationSpec {
    enum PublicationJSON {
        static let publicationDate = "2016-10-28T12:00:58Z"
        static let fromDate = "2016-10-28T12:00:58Z"
        static let toDate = "2026-11-04T13:00:58Z"
        
        static let countries =  ["ALL"]
        static let services = ["web"]
        static let products = ["SVOD002_qwerty"]
        static let publicationId = "publication_161028120058_players_test_asset_ADS_Ocean_009_qwerty"
        
        static let customData = ["Custom":10]
        static let rights = AssetRightsSpec.AssetRightsJSON.valid()
        static let devices = [DeviceRightsSpec.DeviceRightsJSON.valid()]
        static func valid() -> Any {
            return [
                "publicationDate": PublicationJSON.publicationDate,
                "fromDate": PublicationJSON.fromDate,
                "toDate": PublicationJSON.toDate,
                "countries": PublicationJSON.countries,
                "services": PublicationJSON.services,
                "products": PublicationJSON.products,
                "publicationId": PublicationJSON.publicationId,
                "customData": PublicationJSON.customData,
                "rights": PublicationJSON.rights,
                "devices": PublicationJSON.devices
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "publicationDate": PublicationJSON.publicationDate,
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
