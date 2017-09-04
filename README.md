[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Exposure

* [Features](#features)
* [License]()
* [Requirements](#requirements)
* [Installation](#installation)
* Usage
    - [Getting Started](#getting-started)
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
