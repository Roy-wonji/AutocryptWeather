//
//  APIHeaderManger.swift
//  Foundations
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

import Foundation

public class APIHeaderManger {
    public static let shared = APIHeaderManger()
    
    public init() {}
    
    public let contentType: String = "application/json"
}
