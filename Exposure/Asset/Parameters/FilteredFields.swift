//
//  FilteredFields.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-18.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

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
    
    
    public var fieldsIncluded: [String]? {
        return fieldsFilter.includedFields
    }
    // The set of fields to include by default.
    public func include(fields: [String]?) -> Self {
        var old = self
        old.fieldsFilter = FieldsFilter(with: self.fieldsFilter, includedFields: fields)
        return old
    }
    
    public var fieldsExcluded: [String]? {
        return fieldsFilter.excludedFields
    }
    // List of fields to remove from the response.
    public func exclude(fields: [String]?) -> Self {
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
    internal let includedFields: [String]?
    internal let excludedFields: [String]?
    
    internal init(fieldSet: FieldSet = .all, includedFields: [String]? = nil, excludedFields: [String]? = nil) {
        self.fieldSet = fieldSet
        self.includedFields = includedFields
        self.excludedFields = excludedFields
    }
    
    internal init(with filter: FieldsFilter, fieldSet: FieldSet? = nil, includedFields: [String]? = nil, excludedFields: [String]? = nil) {
        self.fieldSet = fieldSet ?? filter.fieldSet
        self.includedFields = includedFields ?? filter.includedFields
        self.excludedFields = excludedFields ?? filter.excludedFields
    }
}
