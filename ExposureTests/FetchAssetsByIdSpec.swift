//
//  FetchAssetsByIdSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class FetchAssetByIdSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let assetId = "players_test_asset_ADS_Ocean_009_qwerty"//"VU-21702_qwerty"
        /*
        let t = FetchAsset(environment: env)
            .filter(assetId: assetId)
            .filter(seasons: true)
            .request()
            .response { (data: ExposureResponse<Asset>) in
                if let value = data.value {
                    
                    print(value)
                    
                }
                else {
                    print(data.error)
                }
        }*/
        
        describe("FetchAssetById") {
            it("should init with complete json") {
                
            }
        }
    }
    
    /*
    func mockImageResponse() -> Any {
        return [
            [
                "url": "https://azukifilesprestage.blob.core.windows.net/img/VU-21702_qwerty-b4fead6f454a4fe2ba1d6b391fb9f5ab_other.jpg",
                "height": 700,
                "width": 500,
                "orientation": "PORTRAIT",
                "type": "other"
            ],
            [
                "url": "https://azukifilesprestage.blob.core.windows.net/img/VU-21702_qwerty-a77a7ed0f7bd0754187a3b2397da61e3_other.jpg",
                "height": 1080,
                "width": 1920,
                "orientation": "LANDSCAPE",
                "type": "other"
            ]
        ]
    }
    
    func mockLocalizedResponse(withImages images: Bool) -> Any {
        return [
            [
                "locale": "en",
                "title": "The_Ocean_Maker",
                "sortingTitle": "The_Ocean_Maker",
                "shortDescription": "Nice CGI",
                "images": images ? mockImageResponse() : []
            ]
        ]
    }
    
    func mockPublicationsResponse(complete: Bool) -> Any {
        [
            [
                "publicationDate": "2016-10-28T12:00:58Z",
                "fromDate": "2016-10-28T12:00:58Z",
                "toDate": "2026-11-04T13:00:58Z",
                "countries": complete ? ["ALL"] : [],
                "services": complete ? ["web"] : [],
                "products": complete ? ["SVOD002_qwerty"] : [],
                "publicationId": "publication_161028120058_players_test_asset_ADS_Ocean_009_qwerty",
                "customData": [:],
                "devices": []
            ]
        ]
    }
    
    func mockAssetResponse() -> Any {
        return [
            "created": "2016-10-28T11:52:41Z",
            "changed": "2016-10-28T12:01:20Z",
            "assetId": "players_test_asset_ADS_Ocean_009_qwerty",
            "type": "MOVIE",
            "localized": mockLocalizedResponse(withImages: true),
            "tags": mockTagsResponse(withValues: true),
            "publications": mockPublicationsResponse(complete: true),
            "participants": [],
            "originalTitle": "The_Ocean_Maker",
            "live": false,
            "productionCountries": [],
            "subtitles": [],
            "audioTracks": [],
            "spokenLanguages": [],
            "medias": [
                [
                    "mediaId": "players_test_asset_ADS_Ocean_009_qwerty",
                    "drm": "EDRM",
                    "format": "HLS",
                    "durationMillis": 607640,
                    "status": "enabled"
                ],
                [
                    "mediaId": "players_test_asset_ADS_Ocean_009-cen-das_qwerty",
                    "drm": "CENC",
                    "format": "DASH",
                    "durationMillis": 607640,
                    "status": "enabled"
                ],
                [
                    "mediaId": "players_test_asset_ADS_Ocean_009-pla-das_qwerty",
                    "drm": "PLAYREADY",
                    "format": "DASH",
                    "durationMillis": 607640,
                    "status": "enabled"
                ]
            ],
            "parentalRatings": [],
            "linkedEntities": [],
            "runtime": 0,
            "customData": [],
            "externalReferences": []
        ]
    }*/
}



