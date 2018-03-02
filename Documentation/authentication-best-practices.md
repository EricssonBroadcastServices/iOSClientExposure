## Authentication Best Practices
Retrieving, persisting, validating and destroying user `SessionToken`s lays a the heart of the *EMP Exposure layer*.

Authentication requests return a valid `SessionToken` (or an encapsulating `Credentials`) if the request is successful. This `sessionToken` should be persisted and used in subsequent calls when an authenticated user is required.

```Swift
Authenticate(environment: exposureEnv)
    .login(username: someUser,
           password: somePassword)
    .request()
    .validate()
    .response{
        if let error = $0.error {
            // Handle Error
        }

        if let credentials = $0.value {
            let sessionToken: SessionToken = credentials.sessionToken

            // Store/pass along the returned SessionToken
        }
    }
```

A `sessionToken` by itself is not guaranteed to be valid. `Exposure` supports validation of existing `sessionToken`s by calling `Authenticate.validate(sessionToken:)` and will return `401` `INVALID_SESSION_TOKEN` if the supplied token is no longer valid.

```Swift
Authenticate(environment: exposureEnv)
    .validate(sessionToken: someToken)
    .request()
    .response{
        if let case .exposureResponse(reason: reason) = $0.error, (reason.httpCode == 401 && reason.message == "INVALID_SESSION_TOKEN") {
            // Session is no longer valid.
        }

        if let stillValid = $0.value {
            // Optionally handle the data returned by Exposure in the form of a SessionResponse
        }
    }
```

Destroying an authenticated user session is accomplished by calling `Authenticate.logout(sessionToken:)`
