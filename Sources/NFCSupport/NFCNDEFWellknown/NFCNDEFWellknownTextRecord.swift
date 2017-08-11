//
//  NFCNDEFWellknownTextRecord.swift
//  NFCSupport
//
//  Created by Yoshihiro Kato on 2017/06/25.
//  Copyright © 2017年 Yoshihiro Kato. All rights reserved.
//

import Foundation

public extension NFCNDEFWellknown {
    public struct TextRecord: NFCNDEFWellknownRecord {
        public let encoding: String.Encoding
        public let languageCode: String
        public let text: String
        
        public init(text: String, languageCode: String, encoding: String.Encoding) {
            self.text = text
            self.languageCode = languageCode
            self.encoding = encoding
        }
        
        public init(with payload: Data) throws {
            guard payload.count > 0 else {
                throw NFCNDEFWellknown.Error.invalid
            }
            let status = payload[0]
            self.encoding = (status & 0x80 == 0) ? .utf8 : .utf16
            let langLength: Int = Int(status & 0x3F)
            guard payload.count >= langLength+1 else {
                throw NFCNDEFWellknown.Error.invalid
            }
            guard let lang = String(data: payload.subdata(in: (1..<langLength+1)), encoding: .ascii) else {
                throw NFCNDEFWellknown.Error.invalid
            }
            self.languageCode = lang
            self.text = String(data: payload.subdata(in: (langLength+1..<payload.count)), encoding: self.encoding) ?? ""
        }
        
        public var description: String {
            return "TextRecord (languageCode: \(languageCode), text: \(text))"
        }
        
        public func payload() throws -> Data {
            var payload: Data = Data()
            guard encoding == .utf8 || encoding == .utf16 else {
                throw NFCNDEFWellknown.Error.invalid
            }
            let status: UInt8 = (encoding == .utf16) ? (0x08 | UInt8(languageCode.count)) : UInt8(languageCode.count)
            payload.append(status)
            
            guard let langCodeData = languageCode.data(using: .ascii) else {
                throw NFCNDEFWellknown.Error.invalid
            }
            payload.append(langCodeData)
            
            guard let textData = text.data(using: encoding) else {
                throw NFCNDEFWellknown.Error.invalid
            }
            payload.append(textData)
            
            return payload
        }
    }
}

extension NFCNDEFWellknown.TextRecord: Equatable {
    public static func == (lhs: NFCNDEFWellknown.TextRecord,
                           rhs: NFCNDEFWellknown.TextRecord) -> Bool {
        return lhs.text == rhs.text
            && lhs.languageCode == rhs.languageCode
            && lhs.encoding == rhs.encoding
    }
}
