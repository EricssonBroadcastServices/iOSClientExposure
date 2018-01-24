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
                let json = AssetJSON.valid()
                let result = json.decode(Asset.self)
                
                expect(result).toNot(beNil())
                expect(result?.created).toNot(beNil())
                expect(result?.changed).toNot(beNil())
                expect(result?.assetId).toNot(beNil())
                expect(result?.type).toNot(beNil())
                expect(result?.localized).toNot(beNil())
                expect(result?.tags).toNot(beNil())
                expect(result?.publications).toNot(beNil())
                expect(result?.episode).toNot(beNil())
                expect(result?.season).toNot(beNil())
                expect(result?.seasonId).toNot(beNil())
                expect(result?.seasons).toNot(beNil())
                expect(result?.participants).toNot(beNil())
                expect(result?.productionYear).toNot(beNil())
                expect(result?.popularityScores).toNot(beNil())
                expect(result?.releaseDate).toNot(beNil())
                expect(result?.originalTitle).toNot(beNil())
                expect(result?.live).toNot(beNil())
                expect(result?.productionCountries).toNot(beNil())
                expect(result?.subtitles).toNot(beNil())
                expect(result?.audioTracks).toNot(beNil())
                expect(result?.spokenLanguages).toNot(beNil())
                expect(result?.medias).toNot(beNil())
                expect(result?.parentalRatings).toNot(beNil())
                expect(result?.linkedEntities).toNot(beNil())
                expect(result?.runtime).toNot(beNil())
                expect(result?.tvShowId).toNot(beNil())
                expect(result?.expires).toNot(beNil())
                expect(result?.customData).toNot(beNil())
                expect(result?.externalReferences).toNot(beNil())
                expect(result?.rating).toNot(beNil())
                expect(result?.markers).toNot(beNil())
                expect(result?.userData).toNot(beNil())
            }
            
            it("should init with required keys") {
                let json = AssetJSON.requiredKeys()
                let result = json.decode(Asset.self)
                
                expect(result).toNot(beNil())
            }
            
            it("should not init with missing keys response") {
                let json = AssetJSON.missingKeys()
                let result = json.decode(Asset.self)
                
                expect(result).to(beNil())
            }
            
            it("should not init with empty response") {
                let json = AssetJSON.empty()
                let result = json.decode(Asset.self)
                
                expect(result).to(beNil())
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
        static let userData = AssetUserDataSpec.AssetUserDataJSON.valid()
        
        static func valid() -> [String: Codable] {
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
                "userData": AssetJSON.userData
            ]
        }
        
        static func requiredKeys() -> [String: Codable] {
            return [
                "assetId": AssetJSON.assetId
            ]
        }
        
        static func missingKeys() -> [String: Codable] {
            return [
                "created": AssetJSON.created
            ]
        }
        
        static func empty() -> [String: Codable] {
            return [:]
        }
    }
}
