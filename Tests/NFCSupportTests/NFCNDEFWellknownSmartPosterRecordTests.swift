//
//  NFCNDEFWellknownSmartPosterRecordTests.swift
//  NFCSupportTests
//
//  Created by Yoshihiro Kato on 2017/08/11.
//

import XCTest
@testable import NFCSupport

class NFCNDEFWellknownSmartPosterRecordTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEncode() {
        let uri = NFCNDEFWellknown.URIRecord(identifier: .https, resource: "apple.com")
        let action = NFCNDEFWellknown.ActionRecord(action: .doTheAction)
        let titles: [NFCNDEFWellknown.TextRecord] = [
            NFCNDEFWellknown.TextRecord(text: "Encode test", languageCode: "en", encoding: .utf8),
            NFCNDEFWellknown.TextRecord(text: "Test de codage", languageCode: "fr", encoding: .utf8)
        ]
        
        let record1 = NFCNDEFWellknown.SmartPosterRecord(uriRecord: uri)
        let payload1 = try? record1.payload()
        XCTAssertNotNil(payload1)
        
        let record2 = NFCNDEFWellknown.SmartPosterRecord(uriRecord: uri, actionRecord: action)
        let payload2 = try? record2.payload()
        XCTAssertNotNil(payload2)
        
        let record3 = NFCNDEFWellknown.SmartPosterRecord(uriRecord: uri, actionRecord: action, titleRecords: titles)
        let payload3 = try? record3.payload()
        XCTAssertNotNil(payload3)
        
    }
    
    func testDecode() {
        let uri = NFCNDEFWellknown.URIRecord(identifier: .https, resource: "apple.com")
        let action = NFCNDEFWellknown.ActionRecord(action: .doTheAction)
        let titles: [NFCNDEFWellknown.TextRecord] = [
            NFCNDEFWellknown.TextRecord(text: "Encode test", languageCode: "en", encoding: .utf8),
            NFCNDEFWellknown.TextRecord(text: "Test de codage", languageCode: "fr", encoding: .utf8)
        ]
        
        let record1 = NFCNDEFWellknown.SmartPosterRecord(uriRecord: uri)
        let payload1 = try? record1.payload()
        XCTAssertNotNil(payload1)
        
        let decodedRecord1 = try? NFCNDEFWellknown.SmartPosterRecord(with: payload1!)
        XCTAssertEqual(record1, decodedRecord1)
        
        let record2 = NFCNDEFWellknown.SmartPosterRecord(uriRecord: uri, actionRecord: action)
        let payload2 = try? record2.payload()
        XCTAssertNotNil(payload2)
        
        let decodedRecord2 = try? NFCNDEFWellknown.SmartPosterRecord(with: payload2!)
        XCTAssertEqual(record2, decodedRecord2)
        
        let record3 = NFCNDEFWellknown.SmartPosterRecord(uriRecord: uri, actionRecord: action, titleRecords: titles)
        let payload3 = try? record3.payload()
        XCTAssertNotNil(payload3)
        
        let decodedRecord3 = try? NFCNDEFWellknown.SmartPosterRecord(with: payload3!)
        XCTAssertEqual(record3, decodedRecord3)
    }
    
}
