//
//  NFCNDEFWellknown.swift
//  NFCSupport
//
//  Created by Yoshihiro Kato on 2017/06/24.
//  Copyright © 2017年 Yoshihiro Kato. All rights reserved.
//

import Foundation

public protocol NFCNDEFWellknownRecord: CustomStringConvertible {
    init(with payload: Data) throws
    func payload() throws -> Data
}

public struct NFCNDEFWellknown {
    public enum Error: Swift.Error {
        case invalid
        case unsupported
    }
    
    public enum ParseResult {
        case text(record: TextRecord)
        case uri(record: URIRecord)
        case smartPoster(record: SmartPosterRecord)
        case unsupported(type: RecordType)
    }
    
    public static func parse(type: Data, payload: Data) throws -> ParseResult {
        let recordType = NFCNDEFWellknown.RecordType(rawData: type)
        switch recordType {
        case .text:
            return .text(record: try recordType.parse(with: payload))
        case .uri:
            return .uri(record: try recordType.parse(with: payload))
        case .smartPoster:
            return .smartPoster(record: try recordType.parse(with: payload))
        default:
            return .unsupported(type: recordType)
        }
    }
    
    public enum RecordType {
        case alternativeCarrier
        case handoverCarrier
        case handoverRequest
        case handoverSelect
        case text
        case uri
        case smartPoster
        case action
        case unknown
        
        public init(rawData: Data) {
            guard let type = String(data: rawData, encoding: .utf8) else {
                self = .unknown
                return
            }
            
            switch type {
            case RecordType.alternativeCarrier.string:
                self = .alternativeCarrier
            case RecordType.handoverCarrier.string:
                self = .handoverCarrier
            case RecordType.handoverRequest.string:
                self = .handoverRequest
            case RecordType.handoverSelect.string:
                self = .handoverSelect
            case RecordType.smartPoster.string:
                self = .smartPoster
            case RecordType.text.string:
                self = .text
            case RecordType.uri.string:
                self = .uri
            case RecordType.action.string:
                self = .action
            default:
                self = .unknown
            }
        }
        
        var string: String {
            switch self {
            case .alternativeCarrier:
                return "ac"
            case .handoverCarrier:
                return "Hc"
            case .handoverRequest:
                return "Hr"
            case .handoverSelect:
                return "Hs"
            case .text:
                return "T"
            case .uri:
                return "U"
            case .smartPoster:
                return "Sp"
            case .action:
                return "act"
            case .unknown:
                return ""
            }
        }
        
        var data: Data {
            return self.string.data(using: .ascii)!
        }
        
        public func parse<T: NFCNDEFWellknownRecord>(with payload: Data) throws -> T {
            switch self {
            case .text:
                return try cast(TextRecord(with: payload))
            case .uri:
                return try cast(URIRecord(with: payload))
            case .smartPoster:
                return try cast(SmartPosterRecord(with: payload))
            case .action:
                return try cast(ActionRecord(with: payload))
            default:
                throw NFCNDEFWellknown.Error.unsupported
            }
        }
    }
    
}
