[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Exposure

* [Features](#features)
* [License]()
* [Requirements](#requirements)
* [Installation](#installation)
* Usage
    - [Getting Started](#getting-started)
    - [Authentication: Best practices](#authentication-best-practices)
    - [Entitlement Requests and Streaming through  `Player`](#entitlement-requests-and-streaming-through-player)
    - [Fetching EPG](#fetching-epg)
    - [Fetching Assets](#fetching-assets)
    - [Analytics Delivery](#analytics-delivery)
    - [Fairplay Integration](#fairplay-integration)
    - [Error Handling](#error-handling)
* [Release Notes](#release-notes)
* [Upgrade Guides](#upgrade-guides)
* [Roadmap](#roadmap)
* [Contributing](#contributing)

## Features
- [x] Asset search
- [x] Authentication
- [x] Playback Entitlement requests
- [x] EPG discovery
- [x] Analytics drop-off
- [x] Server time sync

## Requirements

* `iOS` 9.0+
* `Swift` 3.0+
* `Xcode` 8.2.1+
* Framework dependencies
    - [`Player`](https://github.com/EricssonBroadcastServices/iOSClientExposure)
    - [`Alamofire`](https://github.com/Alamofire/Alamofire)
    - [`SwiftyJSON`](https://github.com/SwiftyJSON/SwiftyJSON)
    - Exact versions described in [Cartfile](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/Cartfile)

## Installation

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

## Usage
`Exposure` conveys seamless integration with the *EMP Exposure Layer* and enables client applications quick access to functionality such as *authentication*, *entitlement requests* and *EPG*.

### Getting Started
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
    .twoFactor(username: someUser,
               password: somePassword,
              twoFactor: mfaCode)

Authenticate(environment: exposureEnv)
    .anonymous()
```

Finally, *Asset Id* refers to unique media assets and may represent items such as *tv shows*, *movies*, *tv channels* or *clips*. Client applications should use this id when refering to media in the *EMP system*.

### Authentication: Best Practices
Retrieving, persisting, validating and destroying user `SessionToken`s lays a the heart of the *EMP Exposure layer*.

Authentication requests return a valid `SessionToken` (or an encapsulating `Credentials`) if the request is successful. This `sessionToken` should be persisted and used in subsequent calls when an authenticated user is required.

```Swift
Authenticate(environment: exposureEnv)
    .login(username: someUser,
           password: somePassword)
    .request()
    .validate()
    .response{ (response: ExposureResponse<Credentials>) in
        if let error = response.error {
           // Handle Error
        }
           
        if let credentials = response.value {
           let sessionToken: SessionToken = credentials.sessionToken
           
           // Store/pass along the returned SessionToken
        }
    }
```

A `sessionToken` by itself is not guaranteed to be valid. `Exposure` supports validation of existing `sessionToken`s by calling `Authenticate.validate(sessionToken:)`. Please note that `Exposure` will return `401` `INVALID_SESSION_TOKEN` if the supplied token is no longer valid. It is thus a good idea to use the `validate()` method on `ExposureRequest`s. For more information about validation and `ExposureResponse`, please see [Error Handling](#error-handling)

```Swift
Authenticate(environment: exposureEnv)
    .validate(sessionToken: someToken)
    .request()
    .validate()
    .response{ (response: ExposureResponse<SessionResponse>) in
        if let case .exposureResponse(reason: reason) = error, (reason.httpCode == 401 && reason.message == "INVALID_SESSION_TOKEN") {
            // Session is no longer valid.
        }
        
        if let stillValid = response.value {
            // Optionally handle the data returned by Exposure in the form of a SessionResponse
        }
    }
```

Destroying an authenticated user session is accomplished by calling `Authenticate.logout(sessionToken:)`

### Entitlement Requests and Streaming through Player
Requesting entitlements is part of the core functionality delivered by the `Exposure` module. A `PlaybackEntitlement` contains all information required to create and start a playback session.

Requests are made on *assetId* and return results based on the user associated with the supplied `SessionToken`. Three endpoints exist depending on the type of entitlement that is requested.

```Swift
let request = Entitlement(environment: environment, sessionToken: sessionToken)

let vodRequest = request.vod(assetId: someAsset)
let liveRequest = request.live(channelId: someChannel)
let catchupRequest = request.catchup(channelId: someChannel, programId: someProgram)
```

Optionally, client applications can request a `DRM` other than the default  `.fairplay`. Please note that the `iOS` platform might not support the requested `DRM`. As for *Fairplay* `DRM`, `Exposure` supplies an out of the box implementation of `FairplayRequester` to handle rights management on the *EMP* platform. For more information, please see [Fairplay Integration](#fairplay-integration).

```Swift
Entitlement(environment: environment,
           sessionToken: sessionToken)
    .catchup(channelId: someChannel,
             programId: someProgram)
    .use(drm: .unencrypted)
    .request()
    .validate()
    .response{ (response: ExposureResponse<PlaybackEntitlement>) in
        if let error = response.error {
            // Handle error
        }
        
        if let entitlement = response.value {
            // Forward entitlement to playback view
        }
    }
```

`Exposure` module is designed to integrate seamlessly with `Player` enabling a smooth transition between the request phase and the playback phase.

```Swift
do {
    player.stream(playback: anEntitlement)
}
catch {
    // Handle errors
}
```

Using the `Player.stream(playback:)` method ensures playback will be configured with `Exposure` related functionality. This includes *Fairplay* configuration and *Session Shift* management.

### Fetching EPG

### Fetching Assets

### Analytics Delivery

### Fairplay Integration

### Error Handling

## Release Notes
Release specific changes can be found in the [CHANGELOG](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/CHANGELOG.md).

## Upgrade Guides
The procedure to apply when upgrading from one version to another depends on what solution your client application has chosen to integrate `Exposure`.

Major changes between releases will be documented with special [Upgrade Guides](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/UPGRADE_GUIDE.md).

### Carthage
Updating your dependencies is done by running  `carthage update` with the relevant *options*, such as `--use-submodules`, depending on your project setup. For more information regarding dependency management with `Carthage` please consult their [documentation](https://github.com/Carthage/Carthage/blob/master/README.md) or run `carthage help`.

## Roadmap
No formalised roadmap has yet been established but an extensive backlog of possible items exist. The following represent an unordered *wish list* and is subject to change.

- [ ] Carousel integration
- [ ] Content search
- [ ] User playback history
- [ ] User preferences
- [ ] Device management

## Contributing
