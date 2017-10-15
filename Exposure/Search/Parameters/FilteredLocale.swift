//
//  FilteredLocale.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
/// Defines an *Exposure request* filter on included response fields.
public protocol FilteredLocale {
    /// Filter to apply
    var localeFilter: LocaleFilter { get set }
}

extension FilteredLocale {
    /// Filter on the specified locale
    ///
    /// - parameter locale: The locale to filter on
    /// - returns: `Sefl`
    public func filter(locale: String?) -> Self {
        var old = self
        old.localeFilter = LocaleFilter(specifiedLocale: locale)
        return self
    }
    
    /// Return the fields specifically specified to be included. Optional
    public var specifiedLocale: String? {
        return localeFilter.specifiedLocale
    }
}

/// Used internally to configure the locale filter
public struct LocaleFilter {
    /// The filter specified locale
    internal let specifiedLocale: String?
    
    internal init(specifiedLocale: String? = nil) {
        self.specifiedLocale = specifiedLocale
    }
}
