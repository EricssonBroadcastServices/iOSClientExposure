## Analytics Delivery

`EventSink` analytics endpoints expose drop-of functionality where client applications can deliver *Analytics Payload*. This payload consists of a `json` object wrapped by an `AnalyticsBatch` envelope. Each batch is self-contained and encapsulates all information required for dispatch.

Initializing analytics returns a response with the configuration parameters detailing how the server wishes contact to proceed.

```Swift
EventSink()
    .initialize(using: myEnvironment)
    .request()
    .response{
        // Handle response
    }
```

`AnalyticsPayload` drop-of is handled in a *per-batch* basis. The response contains an updated analytics configuration.

```Swift
EventSink()
    .send(analytics: batch, clockOffset: unixEpochOffset)
    .request()
    .response{
        // Handle response
    }
```

*EMP* provides an out of the box [Analytics module](https://github.com/EricssonBroadcastServices/iOSClientExposurePlayback) which integrates seamlessly with the rest of the platform.
