//
//  EncryptionProviderSpec.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import iOSClientExposure

struct TestCrypto: EncryptionProvider {
    internal static var password: Data? {
        return "key".sha256Hash
    }
    
    internal static let iv = "vector"
}

struct TestWithoutPasswordCrypto: EncryptionProvider {
    internal static var password: Data? {
        return nil
    }
    
    internal static let iv = "vector"
}

class EncryptionProviderSpec: QuickSpec {
    override func spec() {
        let crypto = TestCrypto()
        describe("Encrypt and Decrypt") {
            let referenceString = "This is my test string"
            let referenceData = referenceString.data(using: .utf8)
            it("Should encrypt and decrypt data correctly") {
                expect{ try crypto.encrypt(data: referenceData) }.toNot(throwError())
                expect{ try crypto.encrypt(data: referenceData) }.toNot(beNil())
                
                let encryptedData = try! crypto.encrypt(data: referenceData)
                expect(encryptedData).toNot(beNil())
                let encrytedString = String(data: encryptedData!, encoding: .utf8)
                expect(encrytedString).to(beNil())
                
                expect{ try crypto.decrypt(data: encryptedData) }.toNot(throwError())
                expect{ try crypto.decrypt(data: encryptedData) }.toNot(beNil())
                
                let decryptedData = try! crypto.decrypt(data: encryptedData)
                expect(decryptedData).toNot(beNil())
                let decryptedString = String(data: decryptedData!, encoding: .utf8)
                expect(decryptedString).toNot(beNil())
                expect(decryptedString).to(equal(referenceString))
            }
            
            it("Should not decrypt or encrypt without valid data") {
                expect{ try crypto.encrypt(data: nil) }.toNot(throwError())
                expect{ try crypto.encrypt(data: nil) }.to(beNil())
                
                expect{ try crypto.decrypt(data: nil) }.toNot(throwError())
                expect{ try crypto.decrypt(data: nil) }.to(beNil())
            }
            
            it("Should not decrypt or encrypt without a password") {
                let strangeCrypto = TestWithoutPasswordCrypto()
                expect{ try strangeCrypto.encrypt(data: referenceData) }.toNot(throwError())
                expect{ try strangeCrypto.encrypt(data: referenceData) }.to(beNil())
                
                expect{ try strangeCrypto.decrypt(data: referenceData) }.toNot(throwError())
                expect{ try strangeCrypto.decrypt(data: referenceData) }.to(beNil())
            }
        }
    }
}
