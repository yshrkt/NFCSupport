//
//  NFCNDEFWellknownActionRecordTests.swift
//  NFCSupportTests
//
//  Created by Yoshihiro Kato on 2017/08/11.
//

import XCTest
@testable import NFCSupport

class NFCNDEFWellknownActionRecordTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEncode() {
        let record = NFCNDEFWellknown.ActionRecord(action: .openForEditing)
        let payload = try? record.payload()
        XCTAssertNotNil(payload)
    }
    
    func testDecode() {
        let record = NFCNDEFWellknown.ActionRecord(action: .doTheAction)
        let payload = try? record.payload()
        XCTAssertNotNil(payload)
        
        let decodedRecord = try? NFCNDEFWellknown.ActionRecord(with: payload!)
        XCTAssertEqual(record, decodedRecord)
    }
}
