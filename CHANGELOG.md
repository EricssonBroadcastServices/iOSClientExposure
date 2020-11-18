# CHANGELOG

* `2.2.30` Release - [2.2.30](#2230)
* `2.2.20` Release - [2.2.20](#2220)
* `2.2.10` Release - [2.2.10](#2210)
* `2.2.00` Release - [2.2.00](#2200)
* `2.1.00` Release - [2.1.00](#2100)
* `2.0.98` Release - [2.0.98](#2098)
* `2.0.92` Release - [2.0.92](#2092)
* `2.0.91` Release - [2.0.91](#2091)
* `2.0.89` Release - [2.0.89](#2089)
* `2.0.86` Release - [2.0.86](#2086)
* `2.0.85` Release - [2.0.85](#2085)
* `2.0.81` Release - [2.0.81](#2081)
* `2.0.80` Release - [2.0.80](#2080)
* `2.0.79` Release - [2.0.79](#2079)
* `2.0.78` Release - [2.0.78](#2078)
* `0.77.x` Releases - [0.77.0](#0770)
* `0.73.x` Releases - [0.73.0](#0730)
* `0.72.x` Releases - [0.72.0](#0720)
* `0.2.x` Releases - [0.2.0](#020) | [0.2.1](#021) | [0.2.2](#022)
* `0.1.x` Releases - [0.1.0](#010) | [0.1.1](#011) | [0.1.2](#012) | [0.1.3](#013) | [0.1.4](#014) | [0.1.5](#015) | [0.1.6](#016) | [0.1.7](#017) | [0.1.8](#018) | [0.1.9](#019)


## 2.2.300
#### Features
* `EMP-15242` Add support to pass adsOptions when creating a `AssetPlayable` 


## 2.2.200
#### Features
* `EMP-15078` Notify DownloadBookKeeper when a download is complete or a when the DRM license is refreshed.
* `EMP-15078` Update project to Swift 5 

## 2.2.100
#### Changes
* `EMP-14806` Update `DownloadInfo` to match the response from the exposure

## 2.2.000
#### Features
* `EMP-14376` Add support for downloads 

## 2.1.131
#### Features
* `EMP-14376` App Developers can now check if an Asset is available to download.
* `EMP-14376` App Developers can now fetch the userAvailabilityKeys related to the logged in user.

## 2.1.130
#### Changes
* `EMP-14239` Exposure now has enum for different AssetTypes.

## 2.1.126

#### Features
* `EMP-14085` Exposure now supports fetching continue watching tv show details.

#### Changes
* `EMP-14128` Update anonymous login to use V2. 


## 2.1.00
Released 31 Jan 2020

## 2.0.114

#### Features
* `EMP-13308` Exposure now supports Event request endpoint.

## 2.0.108

#### Features
* `EMP-12614` Expanded support for next and previous programs.

## 2.0.98

#### Features
* `EMP-12351` Expanded support for custom environment.

## 2.0.92

#### Changes
* `EMP-11795` Included `adMediaLocator` in `PlaybackEntitlement`.

## 2.0.91

#### Features
* Custom `RequestId`  on  `Dispatcher` used when making network requests.
* `EMP-11766` Expanded and clarified error logging through analytics dispatch.

## 2.0.89

#### Changes
* `Dispatcher` resilience improvements.

#### Bug Fixes
* `EMP-11523` Fixed issue where `Device.type` would be incorrectly set while logging in.
* Fixed an issue where persisted analytics would be delivered multiple times.
* `ExposureResponseMessage.info` now returns `nil` instead of _message_. 

## 2.0.86

#### Bug Fixes
* `queryParam(key:value:)` now creates a new array of query params if none are present

## 2.0.85

#### Bug Fixes
* `Dispatcher` event queue is now flushed when the application enters background mode.

## 2.0.81

#### Features
* `EMP-11171` `Exposure` now supports *tvOS*.
* Added `resonseData` returning raw `Data` to `ExposureRequest`
* Added `ExposureApi` integration point for querying a generic *Exposure* endpoint.
* Added `LastViewedList` struct to represent *userPlayHistory* endpoint.

## 2.0.80

#### Changes
* `EMP-11156` Standardized error messages and introduced an `info` variable

## 2.0.79

#### Changes
* `EMP-11077` Dispatcher console log made optional

#### Bug Fixes
* `EMP-11102` Failure to serialize response on analytics dispatch no longer retrys already delivered batches.

## 2.0.78

#### Features
* `EMP-11047` `ExposureError` now exposes an error `Domain`

#### Changes
* Removed `HeartbeatsProvider` protocol in favour of a closure
* `EMP-11065` `Dispatcher` synchronization on a regular interval

#### Bug Fixes
* `EMP-11029` Forced locale to en_GB for framework dependantn date calculations

## 0.77.0

#### Changes
* Extracted *playback* and *download* functionality. `Exposure` now deals exclusivley with metadata from the *Exposure Layer*.
* `SessionShift` protocol has been reamed to `StartTime`

## 0.73.0

#### Bug fixes
* Search strings now properly *escaped*

#### Changes
* `AnalyticsBatch` no longer conforms to `Codable`. Persistence now handled the *old fashioned way*.

## 0.72.0

#### Features
* `Rating` integration added.
* `EMP-10650` Context sensitive playback using `ExposureContext`
* `Carousel` fetch now supports filtering on *fields*, *publication* and *pagination*

#### Bug fixes
* Changed `Response` for `Logout` to `AnyJSONType`.

## 0.2.2
Released 11 Nov 2017

#### Features
*`EMP-10601` Added fetch of specific carousels by id through `FetchCarouselItem`
*`EMP-10609` Analytics dispatch for download events.

#### Changes
*`EMP-10242` AnalyticsProvider now supplied through a generator to accomodate association with `Player.MediaAsset`.
* Removed `TwoFactorLogin` as a separate endpoint. Functionality migrated to `Login` which now accepts a `twoFactor` token.

## 0.2.1
Released 26 Oct 2017

#### Features
* `EMP-9822` Content search with autocompletion
* `EMP-9697` Carousel integration `FetchCarouselList`
* `EMP-10419` *Exposure* specific `DownloadFairplayRequester`
* `EMP-10445` *Downloading* assets now require a unique identifier
* Added `CustomerConfig` model
* `EMP-10474` Several response structs made `Codable` to enable easy persistence on disk.
* Added `SessionToken.acquired` and `SessionToken.expiration`
* `EMP-10486` Adds `ExposureDownloadTask` which handles asset downloads by `assetId`

#### Changes
* Moved `FairplayError` from `Player` to `Exposure`.
* Requirements for `Xcode` set to `9.0+` and `Swift` to `4.0+`
* Removed `SwiftyJSON` in favor of `Decodable` from `Swift` `4.0+`
* `EMP-10270` `Airing` is now distinct from fetching `Program`
* `EMP-10322` `Image.Orientation` made `Equatable`.
* Integrated `Download` entitlement requests and validation.
* Renamed `Exposure` protocol to `ExposureType`
* `ExposureDownloadTask` adopts `DownloadTaskType` instead of wrapping `DownloadTask`
* `EMP-10550` Streaming extensions on `Player` in  `Analytics` module moved to `Exposure`.

#### Bug fixes
* `EMP-10269` `FetchEPG` now respects the *onlyPublished* parameter. Fixed url encoding.
* `EMP-10298` `ExposureRequest.validate()` should now correctly validate on statusCodes and content type.
* `EMP-10299` `PlaybackEntitlement` should not be created with empty or competely invalid `json`.
* `EMP-10468` Decoding *Exposure* response no longer fails if `AssetUserPlayHistory` returns an empty dictionary.
* `ExposureDownloadTask`s restored from a completed state with error now forwards that error.


## 0.2.0
Released 5 Sep 2017

#### Features
* `EMP-10037` Logout endpoint integration.
* `EMP-10051` AnalyticsProvider protocol.
* `EMP-10057` Event Sink endpoint integration.
* `EMP-10095` Multi Device Session Shift
* `EMP-10209` API documentation
* `EMP-10213` General documentation

#### Changes
* `EMP-9801` Reset specialized streaming methods.
* `EMP-10061` Event Sink dispatch includes `clockOffset`.
* `EMP-10066` `SessionToken` properties made public.

## 0.1.9
Released 11 Jul 2017

#### Features
* `EMP-9381` Exposure URL encoding.
* `EMP-9595` Automatic pipe line control over dependencies.
* `EMP-9698` EPG request endpoint.
* `EMP-9772` Fairplay for *Live* and *Catchup*.
* `EMP-9798` Entitlement requests for *Live* playback.
* `EMP-9800` Entitlement validation endpoint.
* `EMP-9951` Restructured dependency graph.

## 0.1.8
Released 30 May 2017

#### Features
* `EMP-9596` Fetch Asset endpoint integration.
* `EMP-9677` Implemented Two-Factor authentication.
* `EMP-9688` Elastic search query parameters for Asset Fetch.
* `EMP-9722` Improved error handling and error propagation.

## 0.1.7
Released 12 May 2017

#### Features
* `EMP-9380` Implemented Anonymous authentication.

## 0.1.6
Released 8 May 2017

#### Features
* `EMP-9396` Fastlane integration for *build pipeline*.

## 0.1.5
Released 25 Apr 2017

#### Features
* `EMP-9392` Unit testing solution.

#### Bug fixes
* `EMP-9426` Raw instead of transformed device model data sent in device info.

## 0.1.4
Released 21 Apr 2017

Unit tests

## 0.1.3
Released 20 Apr 2017

No major changes

## 0.1.2
Released 20 Apr 2017

#### Features
* `EMP-9391`  Separation of `PoC` into module based repositories.

## 0.1.1
Released 19 Apr 2017

Carthage setup

## 0.1.0
Released 19 Apr 2017

Project setup
