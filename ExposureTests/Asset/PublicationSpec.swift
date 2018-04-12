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
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = PublicationJSON.valid()
                let result = json.decode(Publication.self)
                
                expect(result).toNot(beNil())
                expect(result?.publicationDate).toNot(beNil())
                expect(result?.fromDate).toNot(beNil())
                expect(result?.toDate).toNot(beNil())
                expect(result?.countries).toNot(beNil())
                expect(result?.services).toNot(beNil())
                expect(result?.products).toNot(beNil())
                expect(result?.publicationId).toNot(beNil())
                expect(result?.customData).toNot(beNil())
                expect(result?.rights).toNot(beNil())
                expect(result?.devices).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = PublicationJSON.missingKeys()
                let result = json.decode(Publication.self)
                
                expect(result).toNot(beNil())
                expect(result?.publicationDate).toNot(beNil())
                expect(result?.fromDate).to(beNil())
                expect(result?.toDate).to(beNil())
                expect(result?.countries).to(beNil())
                expect(result?.services).to(beNil())
                expect(result?.products).to(beNil())
                expect(result?.publicationId).to(beNil())
                expect(result?.customData).to(beNil())
                expect(result?.rights).to(beNil())
                expect(result?.devices).to(beNil())
            }
            
            it("should init with empty response") {
                let json = PublicationJSON.empty()
                let result = json.decode(Publication.self)
                
                expect(result).toNot(beNil())
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
        static func valid() -> [String: Any] {
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
        
        static func missingKeys() -> [String: Any] {
            return [
                "publicationDate": PublicationJSON.publicationDate,
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
