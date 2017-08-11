//
//  NFCNDEFWellknownSmartPosterRecord.swift
//  NFCSupport
//
//  Created by Yoshihiro Kato on 2017/08/05.
//  Copyright © 2017年 Yoshihiro Kato. All rights reserved.
//

import Foundation

public extension NFCNDEFWellknown {
    public struct SmartPosterRecord: NFCNDEFWellknownRecord {
        public let uriRecord: URIRecord
        public let actionRecord: ActionRecord?
        public let titleRecords: [TextRecord]
        
        public var uri: URL? {
            return uriRecord.uri
        }
        
        var action: ActionRecord.Action? {
            return actionRecord?.action
        }
        
        public init(uriRecord: URIRecord, actionRecord: ActionRecord? = nil, titleRecords: [TextRecord] = []) {
            self.uriRecord = uriRecord
            self.actionRecord = actionRecord
            self.titleRecords = titleRecords
        }
        
        public init(with payload: Data) throws {
            guard payload.count > 2 else {
                throw NFCNDEFWellknown.Error.invalid
            }
            var offset = 0
            var uri: URIRecord?
            var titles: [TextRecord] = []
            var action: ActionRecord?
            repeat {
                let header = RecordHeader(rawValue: payload[offset])
                offset += 1
                let typeLength = Int(payload[offset])
                
                offset += 1
                let recordLength: Int = { 
                    if header.contains(.shortRecord) {
                        return Int(payload[offset])
                    }else {
                        var len = 0
                        len |= Int(payload[offset]) << 24
                        len |= Int(payload[offset + 1]) << 16
                        len |= Int(payload[offset + 2]) << 8
                        len |= Int(payload[offset + 3])
                        return len
                    }
                }()
                
                offset += header.contains(.shortRecord) ? 1 : 4
                let typeData = payload.subdata(in: (offset ..< offset+typeLength))
                let type = NFCNDEFWellknown.RecordType(rawData: typeData)
                
                offset += typeLength
                let recordData = payload.subdata(in: (offset ..< offset+recordLength))
                
                switch type {
                case .uri:
                    uri = try URIRecord(with: recordData)
                case .text:
                    let title = try TextRecord(with: recordData)
                    titles.append(title)
                case .action:
                    action = try ActionRecord(with: recordData)
                default:
                    break
                }
                offset += recordLength
            } while offset < payload.count
            
            guard let uriRecord = uri else {
                throw NFCNDEFWellknown.Error.invalid
            }
            self.uriRecord = uriRecord
            self.titleRecords = titles
            self.actionRecord = action
        }
        
        public var description: String {
            let titles = titleRecords.map { $0.description }.joined(separator: ", ")
            return "SmartPosterRecord (uri: \(uriRecord.description), action: \(actionRecord?.description ?? "(null)"), titles: \(titles))"
        }
        
        public func payload() throws -> Data {
            var payload: Data = Data()
            
            // URI
            let uriPayload = try uriRecord.payload()
            
            let uriHeader: RecordHeader = {
                if !titleRecords.isEmpty || !actionRecord.isNil {
                    return [.messageBegin, .tnfWellknown]
                    
                }else {
                    return [.messageBegin, .messageEnd, .tnfWellknown]
                }
            }()
            
            payload.append(uriHeader.rawValue)
            
            payload.append(UInt8(RecordType.uri.string.count))
            payload.append(lengthAsLongFormat(of: uriPayload))
            payload.append(RecordType.uri.data)
            payload.append(uriPayload)
            
            // Action
            if let actionRecord = actionRecord {
                let actionPayload = try actionRecord.payload()
                
                let header: RecordHeader = [.shortRecord, .tnfWellknown]
                payload.append(header.rawValue)
                payload.append(UInt8(RecordType.action.string.count))
                payload.append(UInt8(actionPayload.count))
                payload.append(RecordType.action.data)
                payload.append(actionPayload)
            }
            
            // Titles
            if !titleRecords.isEmpty {
                for (index, titleRecord) in titleRecords.enumerated() {
                    let titlePayload = try titleRecord.payload()
                    
                    let header: RecordHeader = {
                        if index == titleRecords.count-1 {
                            return [.messageEnd, .shortRecord, .tnfWellknown]
                        }else {
                            return [.shortRecord, .tnfWellknown]
                        }
                    }()
                    payload.append(header.rawValue)
                    payload.append(UInt8(RecordType.text.string.count))
                    payload.append(UInt8(titlePayload.count))
                    payload.append(RecordType.text.data)
                    payload.append(titlePayload)
                    
                }
            }
            
            return payload
        }
        
        private func lengthAsLongFormat(of data: Data) -> Data {
            var result = Data()
            let length: UInt32 = UInt32(data.count)
            result.append(UInt8((length >> 24) & 0x0F))
            result.append(UInt8((length >> 16) & 0x0F))
            result.append(UInt8((length >> 8) & 0x0F))
            result.append(UInt8(length & 0x0F))
            return result
        }
    }
}

extension NFCNDEFWellknown.SmartPosterRecord: Equatable {
    public static func == (lhs: NFCNDEFWellknown.SmartPosterRecord,
                           rhs: NFCNDEFWellknown.SmartPosterRecord) -> Bool {
        return lhs.uriRecord == rhs.uriRecord
            && lhs.actionRecord == rhs.actionRecord
            && lhs.titleRecords == rhs.titleRecords
    }
}
