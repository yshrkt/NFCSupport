//
//  NFCNDEFWellknownActionRecord.swift
//  NFCSupport
//
//  Created by Yoshihiro Kato on 2017/08/05.
//  Copyright © 2017年 Yoshihiro Kato. All rights reserved.
//

import Foundation

public extension NFCNDEFWellknown {
    struct ActionRecord: NFCNDEFWellknownRecord {
        public enum Action {
            case doTheAction
            case saveForLater
            case openForEditing
            case unknown
        }
        
        let action: Action
        
        public init(action: Action) {
            self.action = action
        }
        
        public init(with payload: Data) throws {
            guard payload.count > 0 else {
                throw NFCNDEFWellknown.Error.invalid
            }
            switch payload[0] {
            case 0x00:
                action = .doTheAction
            case 0x01:
                action = .saveForLater
            case 0x02:
                action = .openForEditing
            default:
                action = .unknown
            }
        }
        
        public var description: String {
            return "ActionRecord (action: \(action))"
        }
        
        public func payload() throws -> Data {
            var payload: Data = Data()
            
            switch action {
            case .doTheAction:
                payload.append(0x00)
            case .saveForLater:
                payload.append(0x01)
            case .openForEditing:
                payload.append(0x02)
            default:
                throw NFCNDEFWellknown.Error.invalid
            }
            
            return payload
        }
    }
}

extension NFCNDEFWellknown.ActionRecord: Equatable {
    public static func == (lhs: NFCNDEFWellknown.ActionRecord,
                    rhs: NFCNDEFWellknown.ActionRecord) -> Bool {
        return lhs.action == rhs.action
    }
}
