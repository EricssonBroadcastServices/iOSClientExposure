//
//  FilteredFields.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-18.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines an *Exposure request* filter on included response fields.
public protocol FilteredFields {
    typealias FieldSet = FieldsFilter.FieldSet
    
    /// Filter to apply
    var fieldsFilter: FieldsFilter { get set }
}

extension FilteredFields {
    /// Retruns the `FieldSet` specified by the request.
    public var fieldSet: FieldSet {
        return fieldsFilter.fieldSet
    }
    
    /// Specify the `FieldSet` wanted in the response.
    ///
    /// FieldSets are designed to allow granularity in response data, for example by avoiding large amounts unwanted data. Using any of these *pre-sets* will include a baseline of fields in the response.
    public func use(fieldSet: FieldSet) -> Self {
        var old = self
        old.fieldsFilter = FieldsFilter(with: self.fieldsFilter, fieldSet: fieldSet)
        return old
    }
    
    /// Return the fields specifically specified to be included. Optional
    public var fieldsIncluded: [String]? {
        return fieldsFilter.includedFields
    }
    
    /// Specify the set of fields to include in the response.
    ///
    /// - parameter fields: the fields to include
    /// - returns: `Self`
    public func include(fields: [String]?) -> Self {
        var old = self
        old.fieldsFilter = FieldsFilter(with: self.fieldsFilter, includedFields: fields)
        return old
    }
    
    /// Return the fields specifically specified to be excluded. Optional
    public var fieldsExcluded: [String]? {
        return fieldsFilter.excludedFields
    }
    
    /// Specify the set of fields to exclude in the response.
    ///
    /// - parameter fields: the fields to exclude
    /// - returns: `Self`
    public func exclude(fields: [String]?) -> Self {
        var old = self
        old.fieldsFilter = FieldsFilter(with: self.fieldsFilter, excludedFields: fields)
        return old
    }
}

/// Used internally to configure the filter
public struct FieldsFilter {
    /// Baseline `FieldSet` to include
    public enum FieldSet: String {
        /// No fields will be included by default
        case empty = "NONE"
        
        /// A slimmed down set of fields will be included by default
        case partial = "PARTIAL"
        
        /// All fields are included by default
        case all = "ALL"
    }
    
    /// The baseline field set
    internal let fieldSet: FieldSet
    
    /// Filtered fields to include
    internal let includedFields: [String]?
    
    /// Filtered fields to exclude
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
