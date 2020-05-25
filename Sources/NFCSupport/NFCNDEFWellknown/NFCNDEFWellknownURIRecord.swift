//
//  NFCNDEFWellknownURIRecord.swift
//  NFCSupport
//
//  Created by Yoshihiro Kato on 2017/06/25.
//  Copyright © 2017年 Yoshihiro Kato. All rights reserved.
//

import Foundation

public extension NFCNDEFWellknown {
    struct URIRecord: NFCNDEFWellknownRecord {
        public enum Identifier: UInt8 {
            case none = 0x00
            case httpWww = 0x01
            case httpsWww = 0x02
            case http = 0x03
            case https = 0x04
            case tel = 0x05
            case mailto = 0x06
            case ftpAnonymous = 0x07
            case ftpFtp = 0x08
            case ftps = 0x09
            case sftp = 0x0A
            case smb = 0x0B
            case nfs = 0x0C
            case ftp = 0x0D
            case dav = 0x0E
            case news = 0x0F
            case telnet = 0x10
            case imap = 0x11
            case rtsp = 0x12
            case urn = 0x13
            case pop = 0x14
            case sip = 0x15
            case sips = 0x16
            case tftp = 0x17
            case btspp = 0x18
            case btl2cap = 0x19
            case btgoep = 0x1A
            case tcpobex = 0x1B
            case irdaobex = 0x1C
            case file = 0x1D
            case urnEpcId = 0x1E
            case urnEpcTag = 0x1F
            case urnEpcPat = 0x20
            case urnEpcRaw = 0x21
            case urnEpc = 0x22
            case urnNfc = 0x23
            
            var prefix: String {
                switch self {
                case .httpWww:
                    return "http://www."
                case .httpsWww:
                    return "https://www."
                case .http:
                    return "http://"
                case .https:
                    return "https://"
                case .tel:
                    return "tel:"
                case .mailto:
                    return "mailto:"
                case .ftpAnonymous:
                    return "ftp://anonymous:anonymous@"
                case .ftpFtp:
                    return "ftp://ftp."
                case .ftps:
                    return "ftps://"
                case .sftp:
                    return "sftp://"
                case .smb:
                    return "smb://"
                case .nfs:
                    return "nfs://"
                case .ftp:
                    return "ftp://"
                case .dav:
                    return "dav://"
                case .news:
                    return "news:"
                case .telnet:
                    return "telnet://"
                case .imap:
                    return "imap:"
                case .rtsp:
                    return "rtsp://"
                case .urn:
                    return "urn:"
                case .pop:
                    return "pop:"
                case .sip:
                    return "sip:"
                case .sips:
                    return "sips:"
                case .tftp:
                    return "tftp:"
                case .btspp:
                    return "btspp://"
                case .btl2cap:
                    return "btl2cap://"
                case .btgoep:
                    return "btgoep://"
                case .tcpobex:
                    return "tcpobex://"
                case .irdaobex:
                    return "irdaobex://"
                case .file:
                    return "file://"
                case .urnEpcId:
                    return "urn:epc:id:"
                case .urnEpcTag:
                    return "urn:epc:tag:"
                case .urnEpcPat:
                    return "urn:epc:pat:"
                case .urnEpcRaw:
                    return "urn:epc:raw:"
                case .urnEpc:
                    return "urn:epc:"
                case .urnNfc:
                    return "urn:nfc:"
                default:
                    return ""
                }
            }
        }
        
        public let identifier: Identifier
        public let resource: String
        
        public var uri: URL? {
            return URL(string: identifier.prefix + resource)
        }
        
        public init (identifier: Identifier, resource: String) {
            self.identifier = identifier
            self.resource = resource
        }
        
        public init(with payload: Data) throws {
            guard payload.count > 0 else {
                throw NFCNDEFWellknown.Error.invalid
            }
            guard let identifier = Identifier(rawValue: payload[0]) else {
                throw NFCNDEFWellknown.Error.invalid
            }
            self.identifier = identifier
            self.resource = String(data: payload.subdata(in: (1..<payload.count)), encoding: .utf8) ?? ""
        }
        
        public func payload() throws -> Data {
            var payload = Data()
            payload.append(identifier.rawValue)
            
            guard let resourceData = resource.data(using: .utf8) else {
                throw NFCNDEFWellknown.Error.invalid
            }
            payload.append(resourceData)
            
            return payload
        }
        
        public var description: String {
            return "URIRecord (identifier: \(identifier.prefix), resource: \(resource))"
        }
    }
}

extension NFCNDEFWellknown.URIRecord: Equatable {
    public static func == (lhs: NFCNDEFWellknown.URIRecord,
                           rhs: NFCNDEFWellknown.URIRecord) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.resource == rhs.resource
    }
}
