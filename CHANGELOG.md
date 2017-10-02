# CHANGELOG

* `0.2.x` Releases - [0.2.0](#020) | [0.2.1](#021)
* `0.1.x` Releases - [0.1.0](#010) | [0.1.1](#011) | [0.1.2](#012) | [0.1.3](#013) | [0.1.4](#014) | [0.1.5](#015) | [0.1.6](#016) | [0.1.7](#017) | [0.1.8](#018) | [0.1.9](#019)

## 0.2.1
NO RELEASE DATE SET YET

#### Features
* `EMP-10419` *Exposure* specific `OfflineFairplayRequester`

#### Changes
* Moved `FairplayError` from `Player` to `Exposure`.
* Requirements for `Xcode` set to `9.0+` and `Swift` to `4.0+`
* Removed `SwiftyJSON` in favor of `Decodable` from `Swift` `4.0+`
* `EMP-10270` `Airing` is now distinct from fetching `Program`
* `EMP-10322` `Image.Orientation` made `Equatable`.
* Integrated `Download` entitlement requests and validation.

#### Bug fixes
* `EMP-10269` `FetchEPG` now respects the *onlyPublished* parameter. Fixed url encoding.
* `EMP-10298` `ExposureRequest.validate()` should now correctly validate on statusCodes and content type.
* `EMP-10299` `PlaybackEntitlement` should not be created with empty or competely invalid `json`.

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
