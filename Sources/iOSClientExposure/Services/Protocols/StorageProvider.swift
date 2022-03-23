//
//  StorageProvider.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-07-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Adopting this protocol provides some standardized, simple *file I/O* through some convenience *functions* leveraging `FileManager`
internal protocol StorageProvider { }

extension StorageProvider {
    /// Filter files relative to `directoryUrl`.
    /// The preloaded `URLResourceKeys` can be accessed for each `URL` object while applying the filter.
    ///
    /// See `resourceValues(forKeys:)` function on `URL` for more details.
    ///
    /// - note: Will return both directory and file `URL`s. Specify `URLResourceKey.isDirectoryKey` to be preloaded and filter on that if directories should be excluded.
    ///
    /// - parameter directoryUrl: directory to examine
    /// - parameter preloadingKeys: `URLResourceKey`s to load
    /// - parameter filter: Filter to apply to each `URL` relative to `directoryUrl`
    /// - returns: filtered array of `URL`
    internal func files(at directoryUrl: URL, preloadingKeys keys: [URLResourceKey], filter: (URL, FileManager.DirectoryEnumerator?) throws -> Bool) rethrows -> [URL] {
        let enumerator = FileManager.default.enumerator(at: directoryUrl, includingPropertiesForKeys: keys)
        
        var result:[URL] = []
        while let fileUrl = enumerator?.nextObject() as? URL {
            if try filter(fileUrl, enumerator) {
                result.append(fileUrl)
            }
        }
        return result
    }
    
    /// Returns all files with a creation date older than a specified timestamp.
    ///
    /// - parameter directoryUrl: directory to examine
    /// - parameter olderThan: timestamp specified in *Unix epoch time*, in milliseconds.
    /// - parameter excludingSubdirectories: directory names that should not be examined, or nil
    /// - returns: array of `URL`s specifying files
    /// - throws: Foundation errors related to fetching values associated with `URLResourceKey`s on individual `URL`
    internal func allFiles(at directoryUrl: URL, olderThan timestamp: Int64, excludingSubdirectories excluded: [String]? = nil) throws -> [URL] {
        let urls = try files(at: directoryUrl, preloadingKeys: [.isDirectoryKey, .nameKey, .creationDateKey]) { url, enumerator in
            let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey, .nameKey, .creationDateKey])
            
            if let isDirectory = resourceValues.isDirectory {
                if !isDirectory {
                    if let created = resourceValues.creationDate?.millisecondsSince1970, created < timestamp {
                        return true
                    }
                }
                else {
                    if let skip = excluded, let directoryName = resourceValues.name, skip.contains(directoryName) {
                        /// We will not search subdirectories specified by `excluded`
                        /// Also, directories will not be included in the returned urls no matter what
                        enumerator?.skipDescendants()
                    }
                }
            }
            
            return false
        }
        return urls
    }
    
    /// Convenience method wrapping `FileManager.removeItem(at:)`
    ///
    /// - parameter at: url for file to be removed
    /// - throws: `FileManager` related `Error`
    internal func removeFile(at fileUrl: URL) throws {
        try FileManager.default.removeItem(at: fileUrl)
    }
}
