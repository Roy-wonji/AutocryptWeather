//
//  Extension+APIHeader.swift
//  Foundations
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

extension APIHeader {
    public static var baseHeader: Dictionary<String, String> {
        [
            contentType : APIHeaderManger.shared.contentType,
            
        ]
    }
    
}
