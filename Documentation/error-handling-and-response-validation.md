## Error Handling

Effective error handling when using `Exposure` revolves around responding to three major categories of errors.

The first category consists of errors related to the underlying *frameworks*, forwarded as `ExposureError.generalError(error:)`. Examples include networking errors and on occation purely general errors. Please consult *framework* related documentation to manage these.

A second category contains `serialization(reason:)` errors. These occur on response serialization and indicate a missmatch between the expected data format and the server provided response.

```Swift
someFunc(callback: (ExposureError?) -> Void) { error in
    if case let .serialization(reason: .jsonSerialization(error: jsonError)) = error {
        // The underlying error occured due to json serialization issues
    }
}
```

`jsonSerialization(error:)` related errors mean the provided response data failed to generate a valid `json` structure. This normally indicates data transfer corruption or an invalid or malformated server response.

`objectSerialization(reason: json:)` indicate a missmatch between the provided `json` object and the specifications from which `Object` is initialized. Possible causes can be changes in server response. As such, client applications are encouraged to make sure they run on the latest version of the `Exposure` framework.

#### Exposure Response Validation
`Exposure` endpoints will return specialized response messages, `ExposureResponseMessage`s, that convey server intentions through an `httpCode`. As such, it is important to *validate* responses generated from an `ExposureRequest`. For example, `Entitlement` requests will return `403` `NOT_ENTITLED` when asking for a `PlaybackEntitlement` the user is not entitled to play.

```Swift
Entitlement(environment: environment,
            sessionToken: sessionToken)
    .vod(assetId: someAsset)
    .use(drm: .unencrypted)
    .request()
    .validate(statusCode: 200..<299)
    .response{ [weak self] in
    if case let .exposureResponse(reason: reason) = $0.error, (reason.httpCode == 401) {
        // Handle error
        self?.notifyUser(errorCode: reason.httpCode, withReason: reason.message)
    }
...
}
```

Errors delivered as an `ExposureResponseMessage` convey server intent. Some may hinder client applications from proceeding with the intended *navigation flow*. For example, `ExposureResponseMessage` received when using `Authenticate` results in the user failing to log in. This in turn will block entitlement requests and thus make playback initialization impossible.

It is up to the client application to decide how to best handle `ExposureResponseMessage`s. Each endpoint may return a slightly different set of response messages. For more in depth information, please consult the documentation related to each individual request.
