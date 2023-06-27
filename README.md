[![Swift](https://img.shields.io/badge/Swift-5.x-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.3_5.4_5.5-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS_tvOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux_Windows-Green?style=flat-square)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Alamofire.svg?style=flat-square)](https://img.shields.io/cocoapods/v/Alamofire.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

# Exposure
* [Features](#features)
* [License](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/LICENSE)
* [Requirements](#requirements)
* [Installation](#installation)
* [Getting Started](#getting-started)
* Documentation
    - [Authentication Best practices](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/Documentation/authentication-best-practices.md)
    - [Requesting Playback Entitlements](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/Documentation/requesting-playback-entitlements.md)
    - [Content Discovery](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/Documentation/content-discovery.md)
    - [Analytics Delivery](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/Documentation/analytics-delivery.md)
    - [Error Handling and Response Validation](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/Documentation/error-handling-and-response-validation.md)
* [Release Notes](#release-notes)
* [Upgrade Guides](#upgrade-guides)

## Features
- [x] Asset search
- [x] Authentication
- [x] Playback Entitlement requests
- [x] Download Entitlement requests
- [x] EPG discovery
- [x] Analytics drop-off
- [x] Server time sync
- [x] Carousel integration
- [x] Dynamic customer configuration
- [x] Content search with autocompletion

## Requirements

* `iOS` 9.0+
* `tvOS` 10.0+
* `Swift` 4.0+
* `Xcode` 9.0+

* Framework dependencies

## Installation

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.
Once you have your Swift package set up, adding `iOSClientExposure` as a dependency is as easy as adding it to the dependencies value of your Package.swift.
```sh
dependencies: [
    .package(url: "https://github.com/EricssonBroadcastServices/iOSClientExposure", from: "3.2.1")
]
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependency graph without interfering with your `Xcode` project setup. `CI` integration through [fastlane](https://github.com/fastlane/fastlane) is also available.

Install *Carthage* through [Homebrew](https://brew.sh) by performing the following commands:

```sh
$ brew update
$ brew install carthage
```

Once *Carthage* has been installed, you need to create a `Cartfile` which specifies your dependencies. Please consult the [artifacts](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md) documentation for in-depth information about `Cartfile`s and the other artifacts created by *Carthage*.

```sh
github "EricssonBroadcastServices/iOSClientExposure"
```

Running `carthage update` will fetch your dependencies and place them in `/Carthage/Checkouts`. You either build the `.framework`s and drag them in your `Xcode` or attach the fetched projects to your `Xcode workspace`.

Finally, make sure you add the `.framework`s to your targets *General -> Embedded Binaries* section.

### CocoaPods
CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate `iOSClientExposure` into your Xcode project using CocoaPods, specify it in your Podfile:

```sh
pod 'iOSClientExposure', '~>  3.2.1'
```

## Getting Started
`Exposure` conveys seamless integration with the *EMP Exposure Layer* and enables client applications quick access to functionality such as *authentication*, *entitlement requests* and *EPG*.

*EMP Exposure Layer* has three central concepts of special importance.

* `Environment` Describes the customer specific *Exposure* environment
* `SessionToken` Represents an authenticated user session
* *Asset Id* A unique identifier for a media asset in the system.

The basic building block of any interaction with the *EMP Exposure layer* is `Environment`. This `struct` details the customer specific information required to make requests.

Besides an `Environment`, a valid `SessionToken` is required for accessing most of the functionality. This token is returned upon succesful authentication through the `Authenticate` endpoint. Several methods exist for dealing with user authentication, listed below.

```Swift
Authenticate(environment: exposureEnv)
    .login(username: someUser,
           password: somePassword)
           
Authenticate(environment: exposureEnv)
    .anonymous()
```

Finally, *Asset Id* refers to unique media assets and may represent items such as *tv shows*, *movies*, *tv channels* or *clips*. Client applications should use this id when refering to media in the *EMP system*.

## Release Notes
Release specific changes can be found in the [CHANGELOG](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/CHANGELOG.md).

## Upgrade Guides
The procedure to apply when upgrading from one version to another depends on what solution your client application has chosen to integrate `Exposure`.

Major changes between releases will be documented with special [Upgrade Guides](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/UPGRADE_GUIDE.md).

### Carthage
Updating your dependencies is done by running  `carthage update` with the relevant *options*, such as `--use-submodules`, depending on your project setup. For more information regarding dependency management with `Carthage` please consult their [documentation](https://github.com/Carthage/Carthage/blob/master/README.md) or run `carthage help`.
