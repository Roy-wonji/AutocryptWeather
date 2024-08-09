//
//  Extension+Task.swift
//  Utill
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async {
        let duration = UInt64(seconds * Double(NSEC_PER_SEC))
        try? await Task.sleep(nanoseconds: duration)
    }
}

