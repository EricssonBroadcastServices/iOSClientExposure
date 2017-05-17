//
//  FetchAsset.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct FetchAsset {
    public let environment: Environment
}

extension FetchAsset {
    public func filter(assetId: String) -> FetchAssetById {
        return FetchAssetById(environment: environment,
                              assetId: assetId)
    }
    
    //    public func list() -> FetchAssetList {
    //
    //    }
}



public protocol FilteredFields {
    typealias FieldSet = FieldsFilter.FieldSet
    var fieldsFilter: FieldsFilter { get set }
}

extension FilteredFields {
    public var fieldSet: FieldSet {
        return fieldsFilter.fieldSet
    }
    
    public func use(fieldSet: FieldSet) -> Self {
        var old = self
        old.fieldsFilter = FieldsFilter(with: self.fieldsFilter, fieldSet: fieldSet)
        return old
    }
    
    
    public var fieldsIncluded: [String] {
        return fieldsFilter.includedFields
    }
    // The set of fields to include by default.
    public func include(fields: [String]) -> Self {
        var old = self
        old.fieldsFilter = FieldsFilter(with: self.fieldsFilter, includedFields: fields)
        return old
    }
    
    public var fieldsExcluded: [String] {
        return fieldsFilter.excludedFields
    }
    // List of fields to remove from the response.
    public func exclude(fields: [String]) -> Self {
        var old = self
        old.fieldsFilter = FieldsFilter(with: self.fieldsFilter, excludedFields: fields)
        return old
    }
}


public struct FieldsFilter {
    public enum FieldSet: String {
        case empty = "NONE"
        case partial = "PARTIAL"
        case all = "ALL"
    }
    
    internal let fieldSet: FieldSet
    internal let includedFields: [String]
    internal let excludedFields: [String]
    
    init(fieldSet: FieldSet = .all, includedFields: [String] = [], excludedFields: [String] = []) {
        self.fieldSet = fieldSet
        self.includedFields = includedFields
        self.excludedFields = excludedFields
    }
    
    init(with filter: FieldsFilter, fieldSet: FieldSet? = nil, includedFields: [String]? = nil, excludedFields: [String]? = nil) {
        self.fieldSet = fieldSet ?? filter.fieldSet
        self.includedFields = includedFields ?? filter.includedFields
        self.excludedFields = excludedFields ?? filter.excludedFields
    }
}


public protocol FilteredPublish {
    var publishFilter: PublishFilter { get set }
}

extension FilteredPublish {
    // MARK: Published
    public var onlyPublished: Bool {
        return publishFilter.onlyPublished
    }
    public func filter(onlyPublished: Bool) -> Self {
        var old = self
        old.publishFilter = PublishFilter(onlyPublished: onlyPublished)
        return old
    }
}

public struct PublishFilter {
    internal let onlyPublished: Bool
    
    internal init(onlyPublished: Bool = true) {
        self.onlyPublished = onlyPublished
    }
}

public protocol PageableResponse {
    var pageFilter: PageFilter { get set }
}

extension PageableResponse {
    public var pageSize: Int {
        return pageFilter.size
    }
    
    public var pageNumber: Int {
        return pageFilter.page
    }
    
    public func show(page: Int, spanning items: Int = 50) -> Self {
        var old = self
        old.pageFilter = PageFilter(page: page, size: items)
        return old
    }
}

public struct PageFilter {
    internal let page: Int
    internal let size: Int
    
    internal init(page: Int = 1, size: Int = 50) {
        self.page = page
        self.size = size
    }
}
