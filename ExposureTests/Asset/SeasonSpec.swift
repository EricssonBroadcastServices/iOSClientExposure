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
                let value = Season(json: SeasonJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.created).toNot(beNil())
                expect(value!.changed).toNot(beNil())
                expect(value!.season).toNot(beNil())
                expect(value!.tags).toNot(beNil())
                expect(value!.localized).toNot(beNil())
                expect(value!.tvShowId).toNot(beNil())
                expect(value!.seasonId).toNot(beNil())
                expect(value!.episodeCount).toNot(beNil())
                expect(value!.episodes).toNot(beNil())
                expect(value!.publishedDate).toNot(beNil())
                expect(value!.availableDate).toNot(beNil())
                expect(value!.startYear).toNot(beNil())
                expect(value!.endYear).toNot(beNil())
                expect(value!.linkedEntities).toNot(beNil())
                expect(value!.externalReferences).toNot(beNil())
                expect(value!.customData).toNot(beNil())
            }
            
            it("should init with partial response") {
                let value = Season(json: SeasonJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.created).toNot(beNil())
                expect(value!.changed).to(beNil())
                expect(value!.season).to(beNil())
                expect(value!.tags).to(beNil())
                expect(value!.localized).to(beNil())
                expect(value!.tvShowId).to(beNil())
                expect(value!.seasonId).to(beNil())
                expect(value!.episodeCount).to(beNil())
                expect(value!.episodes).to(beNil())
                expect(value!.publishedDate).to(beNil())
                expect(value!.availableDate).to(beNil())
                expect(value!.startYear).to(beNil())
                expect(value!.endYear).to(beNil())
                expect(value!.linkedEntities).to(beNil())
                expect(value!.externalReferences).to(beNil())
                expect(value!.customData).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = Season(json: SeasonJSON.empty())
                
                expect(value).to(beNil())
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
        static func valid() -> Any {
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
        
        static func missingKeys() -> Any {
            return [
                "created": SeasonJSON.created
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
