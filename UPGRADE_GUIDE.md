# Upgrade Guide

## 2.1.00
Project is updated to use Swift version 4.2

## 2.0.89

### API Changes

#### UIDevice

| reason | api |
| -------- | --- |
| deprecated | `UIDevice.deviceType()` |

#### SessionToken

| reason | api |
| -------- | --- |
| deprecated | `hasValidFormat` |

## 2.0.81

Release `2.0.81` adds `tvOS` support by introducing a new *target*, `Player-tvOS`. Client application developers working with the *tvOS* platform should embedd the product of this target in their *tvOS* applications.

## 0.72.0 to 0.77.0

#### Architecture
`Exposure` module has been refactored with the playback and download related functionality extracted into new modules, `ExposurePlayback` and `ExposureDownload`.

`Exposure` module now acts exclusively as an integration point for the *ExposureLayer*

#### API changes
Several API changes where introduced to streamline with *Android* and *HTML5* platforms.

## 0.2.0 to 0.72.0
Major changes introduced to modularize *Tech* and *Playback Context*.

#### Features as Components
Context sensitive playback with *Features as Components* introduces a clear, distinct per-tech playback experience. Typed error handling now takes place exclusively through the `onError` callback on `Player` and all *Exposure* integration has been moved to `ExposureContext`.

Constrained extensions on `Player` and the newly introduced `PlaybackTech` and `ExposureContext` protocol allows new features to be developed with strict tech targets in mind.

## Adopting 0.2.0
Please consult the [Installation](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/README.md#installation) and [Usage](https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/README.md#getting-started) guides for information about this initial release.
