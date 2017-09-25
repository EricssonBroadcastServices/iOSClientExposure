//
//  SeasonSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-17.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class SeasonSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = SeasonJSON.valid()
                let result = json.decode(Season.self)
                
                expect(result).toNot(beNil())
                expect(result?.created).toNot(beNil())
                expect(result?.changed).toNot(beNil())
                expect(result?.season).toNot(beNil())
                expect(result?.tags).toNot(beNil())
                expect(result?.localized).toNot(beNil())
                expect(result?.tvShowId).toNot(beNil())
                expect(result?.seasonId).toNot(beNil())
                expect(result?.episodeCount).toNot(beNil())
                expect(result?.episodes).toNot(beNil())
                expect(result?.publishedDate).toNot(beNil())
                expect(result?.availableDate).toNot(beNil())
                expect(result?.startYear).toNot(beNil())
                expect(result?.endYear).toNot(beNil())
                expect(result?.linkedEntities).toNot(beNil())
                expect(result?.externalReferences).toNot(beNil())
                expect(result?.customData).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = SeasonJSON.valid()
                let result = json.decode(Season.self)
                
                expect(result).toNot(beNil())
                expect(result?.created).toNot(beNil())
                expect(result?.changed).to(beNil())
                expect(result?.season).to(beNil())
                expect(result?.tags).to(beNil())
                expect(result?.localized).to(beNil())
                expect(result?.tvShowId).to(beNil())
                expect(result?.seasonId).to(beNil())
                expect(result?.episodeCount).to(beNil())
                expect(result?.episodes).to(beNil())
                expect(result?.publishedDate).to(beNil())
                expect(result?.availableDate).to(beNil())
                expect(result?.startYear).to(beNil())
                expect(result?.endYear).to(beNil())
                expect(result?.linkedEntities).to(beNil())
                expect(result?.externalReferences).to(beNil())
                expect(result?.customData).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = SeasonJSON.valid()
                let result = json.decode(Season.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension SeasonSpec {
    enum SeasonJSON {
        static let created = "2017-05-17T07:36:06Z"
        static let changed = "2017-05-17T07:36:06Z"
        static let season = "3"
        static let tags = [TagsSpec.TagsJSON.valid()]
        static let localized = [LocalizedDataSpec.LocalizedDataJSON.valid()]
        static let tvShowId = "QASeriesId_972aa354-428b-45bf-9cd8-04912abdb13a_qwerty"
        static let seasonId = "QASeasonId_43863db1-6c2d-4c44-9872-1c069a94e27a_qwerty"
        static let episodeCount = 3
        static let episodes = [AssetSpec.AssetJSON.missingKeys()]
        static let publishedDate = "2017-05-17T07:36:06Z"
        static let availableDate = "2017-05-17T07:36:06Z"
        static let startYear = 2012
        static let endYear = 2013
        static let linkedEntities = [LinkedEntitySpec.LinkedEntityJSON.valid()]
        static let externalReferences = [ExternalReferenceSpec.ExternalReferenceJSON.valid()]
        static let customData:[String:Any] = [:]
        static func valid() -> [String: Any] {
            return [
                "created": SeasonJSON.created,
                "changed": SeasonJSON.changed,
                "season": SeasonJSON.season,
                "tags": SeasonJSON.tags,
                "localized": SeasonJSON.localized,
                "tvShowId": SeasonJSON.tvShowId,
                "seasonId": SeasonJSON.seasonId,
                "episodeCount": SeasonJSON.episodeCount,
                "episodes": SeasonJSON.episodes,
                "publishedDate": SeasonJSON.publishedDate,
                "availableDate": SeasonJSON.availableDate,
                "startYear": SeasonJSON.startYear,
                "endYear": SeasonJSON.endYear,
                "linkedEntities": SeasonJSON.linkedEntities,
                "externalReferences": SeasonJSON.externalReferences,
                "customData": SeasonJSON.customData
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "created": SeasonJSON.created
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
