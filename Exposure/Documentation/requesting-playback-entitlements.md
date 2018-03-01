## Requesting Playback Entitlements

Requesting entitlements is part of the core functionality delivered by the `Exposure` module. A `PlaybackEntitlement` contains all information required to create and start a playback session.

Requests are made on *assetId* and return results based on the user associated with the supplied `SessionToken`. Three endpoints exist depending on the type of entitlement that is requested.

```Swift
let request = Entitlement(environment: environment, sessionToken: sessionToken)

let vodRequest = request.vod(assetId: someAsset)
let liveRequest = request.live(channelId: someChannel)
let catchupRequest = request.program(programId: someProgram, channelId: someChannel)
let downloadRequest = request.download(assetId: someOfflineAsset)
```

Optionally, client applications can request a `DRM` other than the default  `.fairplay`. Please note that the `iOS` platform might not support the requested `DRM`. As for *Fairplay* `DRM`, [`ExposurePlayback`](https://github.com/EricssonBroadcastServices/iOSClientExposurePlayback) supplies an out of the box implementation of `FairplayRequester` to handle rights management on the *EMP* platform.

For more information about *Fairplay* debugging, please see Apple's [documentation](https://developer.apple.com/library/content/technotes/tn2454).

```Swift
Entitlement(environment: environment,
            sessionToken: sessionToken)
    .program(programId: someProgram,
             channelId: someChannel)
    .use(drm: "UNENCRYPTED")
    .request()
    .validate()
    .response{
        if let error = $0.error {
            // Handle error
        }
    
        if let entitlement = $0.value {
            // Forward entitlement to playback view
        }
    }
```

A failed entitlement request where the user is not entitled to play an asset will manifest as an `ExposureResponse` encapsulated in an `ExposureError`. For more information, please see [Error Handling](#error-handling).
