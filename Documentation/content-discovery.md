## Content Discovery

#### Generic Exposure endpoints
`ExposureApi` is designed as an integration point for querying a generic *Exposure* endpoint. Users can specify a generic `ResponseType` (any data structure that conforms to `Decodable`) which will be materialized from the server response. In the event the server responds with an error, this will be handled by error validation and promotion of the related `ExposureError`. 

Queries can be specified in *freeform*.

```Swift
let sessionToken: SessionToken?
let query = "onlyPublished=true&includeUserData=\(sessionToken != nil)&fieldSet=ALL&assetType=MOVIE&sort=originalTitle"
ExposureApi<AssetList>(environment: environment, endpoint: "content/asset", query: query, sessionToken: sessionToken)
    .request()
    .validate()
    .response{
        if let success = $0 {
            // Present or manage the response
        }
        
        if let error = $0.error {
            // Present or manage the error
        }
    }
```

#### Fetching EPG
*EPG*, or the *electronic programming guide*, details previous, current and upcomming programs on a specific channel. Client applications may request *EPG* data through the `FetchEpg` endpoint.

`Exposure` supports fetching *EPG* for a set of channels, either all channels or filtered on `channelId`s.

The example below fetches *EPG* for 3 specified channels from yesterday to tomorrow, limiting the result to 100 entries and sorting the returned `[ChannelEpg]` on *channelId* in a *descending order*.

```Swift
FetchEpg(environment: environment)
    .channels(ids: ["channel_1_news", "some_sports", "great_series")
    .filter(starting: yesterdaysDate, ending: tomorrowsDate)
    .sort(on: ["-channelId"])
    .show(page: 1, spanning: 100)
    .request()
    .response{
        // Handle response
    }
```

It is also possible to fetch *EPG* data for a specific program on a channel.

```Swift
FetchEpg(environment: environment)
    .channel(id: "great_series", programId: "amazing_show_s01_e01")
    .request()
    .response{
        // Handle response
    }
```

#### Fetching Assets
Client applications can fetch and filter assets on a variety of properties.

It is possible to specify what data fields should be included in the response. The following request fetches `.all` fields in the `FieldSet`, excluding `publications.rights` and `tags`.

```Swift
let sortedListRequest = FetchAsset(environment: environment)
    .list()
    .use(fieldSet: .all)
    .exclude(fields: ["publications.rights", "tags"])
```

Just as with *EPG*, it is possible to sort the response and limit it to a set number of entries

```Swift
let pagedSortedRequest = sortedListRequest
    .sort(on: ["-publications.publicationDate","assetId"])
    .show(page: 1, spanning: 100)
```

In addition, it is possible to filter on `DeviceType` and *assetIds*

```Swift
let deviceFilteredRequest = pagedSortedRequest
    .filter(onlyAssetIds: ["amazing_show_s01_e01", "channel_1_news"]
    .filter(on: .tablet)
```

Finally, advanced queries can be performed using *elastic search* on related properties. For example, a filter for finding only assets with *HLS* and *Fairplay* media can be expressed as follows

```Swift
let elasticSearchRequest = deviceFilteredRequest
    .elasticSearch(query: "medias.drm:FAIRPLAY AND medias.format:HLS")
    .request()
    .response{
        // Handle response
    }
```
For more information on how to construct queries, please see [Elastic Search](https://www.elastic.co/guide/en/elasticsearch/reference/1.7/query-dsl-query-string-query.html) documentation.

It is also possible to fetch an asset by Id

```Swift
FetchAsset(environment: environment)
    .filter(assetId: "amazing_show_s01_e01")
    .request()
    .response{
        // Handle response
    }
```

#### Content Search
Client applications can do content search with autocompletion by querying *Exposure*.

```Swift
Search(environment: environment)
    .autocomplete(for: "The Amazing TV sh")
    .filter(locale: "en")
    .request()
    .response{
        // Matches "The Amazing TV show"
    }
```

When doing querys on assets, many of the `FetchAssetList` filters are applicable.

```Swift
Search(environment: environment)
    .query(for: "The Amazing TV sh")
    .filter(locale: "en")
    .use(fieldSet: .all)
    .exclude(fields: ["publications.rights", "tags"])
    .sort(on: ["-publications.publicationDate","assetId"])
    .show(page: 1, spanning: 100)
    .request()
    .response{
        // Handle the response
    }
```

