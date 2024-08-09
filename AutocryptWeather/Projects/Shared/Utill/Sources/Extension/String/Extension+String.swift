//
//  Extension+String.swift
//  Utill
//
//  Created by 서원지 on 8/9/24.
//

import Foundation

public extension Double {
 
    func formatToOneDecimalPlace(_ value: Double?) -> String {
        guard let value = value else {
            return "0.0" 
        }
        return String(format: "%.1f", value)
    }

}
