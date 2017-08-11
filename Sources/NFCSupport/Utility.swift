//
//  Utility.swift
//  NFCSupport
//
//  Created by Yoshihiro Kato on 2017/06/24.
//  Copyright © 2017年 Yoshihiro Kato. All rights reserved.
//

extension Optional {
    var isNil: Bool {
        if case .none = self {
            return true
        }else {
            return false
        }
    }
}

func cast<T>(_ x: Any) -> T {
    return x as! T
}
