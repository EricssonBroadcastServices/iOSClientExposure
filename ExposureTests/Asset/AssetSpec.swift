//
//  AssetSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-17.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class AssetSpec: QuickSpec {
    
    typealias AssetType = Asset.AssetType
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let value = Asset(json: AssetJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.created).toNot(beNil())
                expect(value!.changed).toNot(beNil())
                expect(value!.assetId).toNot(beNil())
                expect(value!.type).toNot(beNil())
                expect(value!.localized).toNot(beNil())
                expect(value!.tags).toNot(beNil())
                expect(value!.publications).toNot(beNil())
                expect(value!.episode).toNot(beNil())
                expect(value!.season).toNot(beNil())
                expect(value!.seasonId).toNot(beNil())
                expect(value!.seasons).toNot(beNil())
                expect(value!.participants).toNot(beNil())
                expect(value!.productionYear).toNot(beNil())
                expect(value!.popularityScores).toNot(beNil())
                expect(value!.releaseDate).toNot(beNil())
                expect(value!.originalTitle).toNot(beNil())
                expect(value!.live).toNot(beNil())
                expect(value!.productionCountries).toNot(beNil())
                expect(value!.subtitles).toNot(beNil())
                expect(value!.audioTracks).toNot(beNil())
                expect(value!.spokenLanguages).toNot(beNil())
                expect(value!.medias).toNot(beNil())
                expect(value!.parentalRatings).toNot(beNil())
                expect(value!.linkedEntities).toNot(beNil())
                expect(value!.runtime).toNot(beNil())
                expect(value!.tvShowId).toNot(beNil())
                expect(value!.expires).toNot(beNil())
                expect(value!.customData).toNot(beNil())
                expect(value!.externalReferences).toNot(beNil())
                expect(value!.rating).toNot(beNil())
                expect(value!.markers).toNot(beNil())
                expect(value!.lastViewedTime).toNot(beNil())
                expect(value!.lastViewedOffset).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = Asset(json: AssetJSON.missingKeys())
                
                expect(value).toNot(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = Asset(json: AssetJSON.empty())
                
                expect(value).to(beNil())
            }
        }
        
        describe("AssetType") {
            it("should init correctly") {
                let movie = AssetType(string: "MOVIE")
                let tvShow = AssetType(string: "TV_SHOW")
                let episode = AssetType(string: "EPISODE")
                let clip = AssetType(string: "CLIP")
                let tvChannel = AssetType(string: "TV_CHANNEL")
                let ad = AssetType(string: "AD")
                let liveEvent = AssetType(string: "LIVE_EVENT")
                let other = AssetType(string: "OTHER")
                let otherText = AssetType(string: "otherText")
                
                expect(movie.queryParam).to(equal("MOVIE"))
                expect(tvShow.queryParam).to(equal("TV_SHOW"))
                expect(episode.queryParam).to(equal("EPISODE"))
                expect(clip.queryParam).to(equal("CLIP"))
                expect(tvChannel.queryParam).to(equal("TV_CHANNEL"))
                expect(ad.queryParam).to(equal("AD"))
                expect(liveEvent.queryParam).to(equal("LIVE_EVENT"))
                expect(other.queryParam).to(equal("OTHER"))
                expect(otherText.queryParam).to(equal("OTHER"))
            }
        }
    }
}

extension AssetSpec {
    enum AssetJSON {
        static let created = "2017-02-14T10:17:41Z"
        static let changed = "2017-03-29T07:00:41Z"
        static let assetId = "VU-21702_qwerty"
        static let type = "TV_SHOW"
        static let localized = [LocalizedDataSpec.LocalizedDataJSON.valid()]
        static let tags = [TagsSpec.TagsJSON.valid()]
        static let publications = [PublicationSpec.PublicationJSON.valid()]
        
        static let episode = "1"
        static let season = "1"
        static let seasonId = "VU-000089291_qwerty"
        static let seasons = [SeasonSpec.SeasonJSON.valid()]
        static let participants = [PersonSpec.PersonJSON.valid()]
        static let productionYear = 2002
        static let popularityScores:[String: Any] = [:]
        static let releaseDate = "2017-03-29T07:00:41Z"
        static let originalTitle = "Rubys Piano Practice/Maxs Bath/Maxs Bedtime"
        
        static let live = false
        static let productionCountries = ["CA"]
        static let subtitles = ["swe", "en"]
        static let audioTracks = ["fr", "de"]
        static let spokenLanguages = ["fr", "swe"]
        static let medias = [MediaSpec.MediaJSON.valid()]
        static let parentalRatings = [ParentalRatingSpec.ParentalRatingJSON.valid()]
        
        static let linkedEntities = [LinkedEntitySpec.LinkedEntityJSON.valid()]
        static let runtime = 1354
        static let tvShowId = "VU-21701_qwerty"
        static let expires = "2017-03-29T07:00:41Z"
        static let customData:[String: Any] = [
            "Provider_Content_Tier": "SD 2.0",
            "Studio_Code": "NLV",
            "Suggested_Price": "0.00",
            "Maximum_Viewing_Length": "01:00:00",
            "Provider": "VU",
            "ProviderID": "vubiquity.co.uk",
            "Billing_ID": "0001203031",
            "PAID": "PAID0000000001203031",
            "Rights": "",
            "Verb": "null",
            "ADICategory": [
                "category/for/customData1",
                "category/for/customData2"
            ],
            "Parental_Advisory": [
                ""
            ]
        ]
        static let externalReferences = [ExternalReferenceSpec.ExternalReferenceJSON.valid()]
        static let rating = 0.5
        static let markers = [MarkerSpec.MarkerJSON.valid()]
        static let lastViewedTime = 10
        static let lastViewedOffset = 100
        
        static func valid() -> Any {
            return [
                "created": AssetJSON.created,
                "changed": AssetJSON.changed,
                "assetId": AssetJSON.assetId,
                "type": AssetJSON.type,
                "localized": AssetJSON.localized,
                "tags": AssetJSON.tags,
                "publications": AssetJSON.publications,
                "episode": AssetJSON.episode,
                "season": AssetJSON.season,
                "seasonId": AssetJSON.seasonId,
                "seasons": AssetJSON.seasons,
                "participants": AssetJSON.participants,
                "productionYear": AssetJSON.productionYear,
                "popularityScores": AssetJSON.popularityScores,
                "releaseDate": AssetJSON.releaseDate,
                "originalTitle": AssetJSON.originalTitle,
                "live": AssetJSON.live,
                "productionCountries": AssetJSON.productionCountries,
                "subtitles": AssetJSON.subtitles,
                "audioTracks": AssetJSON.audioTracks,
                "spokenLanguages": AssetJSON.spokenLanguages,
                "medias": AssetJSON.medias,
                "parentalRatings": AssetJSON.parentalRatings,
                "linkedEntities": AssetJSON.linkedEntities,
                "runtime": AssetJSON.runtime,
                "tvShowId": AssetJSON.tvShowId,
                "expires": AssetJSON.expires,
                "customData": AssetJSON.customData,
                "externalReferences": AssetJSON.externalReferences,
                "rating": AssetJSON.rating,
                "markers": AssetJSON.markers,
                "lastViewedTime": AssetJSON.lastViewedTime,
                "lastViewedOffset": AssetJSON.lastViewedOffset
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "created": AssetJSON.created
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
