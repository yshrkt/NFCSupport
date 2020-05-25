//
//  NFCNDEFWellknownRecordHeader.swift
//  NFCSupport
//
//  Created by Yoshihiro Kato on 2017/08/11.
//  Copyright © 2017年 Yoshihiro Kato. All rights reserved.
//

import Foundation

extension NFCNDEFWellknown {
    struct RecordHeader: OptionSet {
        let rawValue: UInt8
        
        static let messageBegin = RecordHeader(rawValue: 1 << 7)
        static let messageEnd   = RecordHeader(rawValue: 1 << 6)
        static let chunkFlag    = RecordHeader(rawValue: 1 << 5)
        static let shortRecord  = RecordHeader(rawValue: 1 << 4)
        static let idLength     = RecordHeader(rawValue: 1 << 3)
        
        // Type name format
        static let tnfEmpty       = RecordHeader([])
        static let tnfWellknown   = RecordHeader(rawValue: 1)
        static let tnfMedia       = RecordHeader(rawValue: 2)
        static let tnfAbsoluteURI = RecordHeader(rawValue: 3)
        static let tnfExternal    = RecordHeader(rawValue: 4)
        static let tnfUnknown     = RecordHeader(rawValue: 5)
        static let tnfUnchanged   = RecordHeader(rawValue: 6)
    }
}
