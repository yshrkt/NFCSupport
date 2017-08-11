//
//  NFCNDEFWellknownURIRecordTests.swift
//  NFCSupportTests
//
//  Created by Yoshihiro Kato on 2017/08/11.
//

import XCTest
@testable import NFCSupport

class NFCNDEFWellknownURIRecordTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testURI(){
        let record = NFCNDEFWellknown.URIRecord(identifier: .https, resource: "apple.com")
        XCTAssertEqual(record.uri, URL(string: "https://apple.com"))
    }
    
    func testEncode() {
        let record = NFCNDEFWellknown.URIRecord(identifier: .https, resource: "apple.com")
        XCTAssertEqual(record.uri, URL(string: "https://apple.com"))
        let payload = try? record.payload()
        XCTAssertNotNil(payload)
    }
    
    func testDecode() {
        let record = NFCNDEFWellknown.URIRecord(identifier: .https, resource: "apple.com")
        let payload = try? record.payload()
        XCTAssertNotNil(payload)
        
        let decodedRecord = try? NFCNDEFWellknown.URIRecord(with: payload!)
        XCTAssertEqual(record, decodedRecord)
    }
}
