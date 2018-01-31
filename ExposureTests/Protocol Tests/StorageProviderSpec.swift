//
//  StorageProviderSpec.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import Exposure

struct TestStorageProvider: StorageProvider {
    let filenames = ["first","second","third"]
    let subDirectory = "subDirectory"
    var data: [(String, Data)] {
        return filenames.flatMap{ filename -> (String, Data)? in
            if let d = filename.data(using: .utf8) {
                return (filename,d)
            }
            return nil
        }
    }
    func baseUrl() throws -> URL {
        return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("TestStorageProvider")
    }
    
    enum TestError: Swift.Error {
        case failedToCreateTestData
    }
}


///
/// x :documentDirectory/TestStorageProvider
/// |
/// x--o first.file
/// |
/// x--x :documentDirectory/TestStorageProvider/subDirectory
///    |
///    x--o second.file
///    x--o third.file
class StorageProviderSpec: QuickSpec {
    let storage = TestStorageProvider()
    override func spec() {
        describe("Storage") {
            
            expect{ try self.storage.baseUrl() }.toNot(throwError())
            let url = try! self.storage.baseUrl()
            
            it("Should list files at a path") {
                expect{ try self.createFileStructure() }.toNot(throwError())
                
                expect{ try self.storage.files(at: url, preloadingKeys: [URLResourceKey.isDirectoryKey], filter: { (url, enumerator) -> Bool in
                    let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                    
                    if let isDirectory = resourceValues.isDirectory {
                        return !isDirectory
                    }
                    return false
                })}.toNot(throwError())
                
                let returned = try! self.storage.files(at: url, preloadingKeys: [URLResourceKey.isDirectoryKey]) { (url, enumerator) -> Bool in
                    let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                    
                    if let isDirectory = resourceValues.isDirectory {
                        return !isDirectory
                    }
                    return false
                }
                print(returned)
                expect(returned.count).to(equal(3))
            }
            
            it("Should list all files older than current time") {
                let subUrl = url.appendingPathComponent(self.storage.subDirectory)
                let date = Date().millisecondsSince1970
                expect{ try self.storage.allFiles(at: subUrl, olderThan: date) }.toNot(throwError())
                
                let result = try! self.storage.allFiles(at: subUrl, olderThan: date)
                expect(result.count).to(equal(2))
            }
            
            it("Should not find any test files created long ago") {
                let subUrl = url.appendingPathComponent(self.storage.subDirectory)
                let date = Date().millisecondsSince1970 / 2
                expect{ try self.storage.allFiles(at: subUrl, olderThan: date) }.toNot(throwError())
                
                let result = try! self.storage.allFiles(at: subUrl, olderThan: date)
                expect(result.count).to(equal(0))
            }
            
            it("Should list all files older than current time but exclude specified subdirectories") {
                let date = Date().millisecondsSince1970
                expect{ try self.storage.allFiles(at: url, olderThan: date) }.toNot(throwError())
                
                let result = try! self.storage.allFiles(at: url, olderThan: date, excludingSubdirectories: [self.storage.subDirectory])
                expect(result.count).to(equal(1))
            }
            
            it("Should remove files at specified location") {
                let thirdFile = url.appendingPathComponent(self.storage.subDirectory).appendingPathComponent(self.storage.filenames.last!)
                let date = Date().millisecondsSince1970
                expect{ try self.storage.allFiles(at: url, olderThan: date) }.toNot(throwError())
                
                expect{ try self.storage.removeFile(at: thirdFile)}.toNot(throwError())
                let result = try! self.storage.allFiles(at: url, olderThan: date)
                expect(result.count).to(equal(2))
                
                
                expect{ try self.storage.removeFile(at: url)}.toNot(throwError())
                let allRemoved = try! self.storage.allFiles(at: url, olderThan: date)
                expect(allRemoved.count).to(equal(0))
            }
        }
    }
    
    func createFileStructure() throws {
        let mainDir = try storage.baseUrl()
        let data = storage.data
        guard data.count == 3 else { throw TestStorageProvider.TestError.failedToCreateTestData }
        
        let first = data.first!
        try first.1.persist(as: first.0, at: mainDir)
        try (1..<data.count).forEach{
            let set = data[$0]
            try set.1.persist(as: set.0, at: mainDir.appendingPathComponent(storage.subDirectory))
        }
    }
}
