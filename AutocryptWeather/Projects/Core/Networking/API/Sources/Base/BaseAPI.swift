//
//  BaseAPI.swift
//  API
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

public enum BaseAPI: String {
    case baseURL
    
    public var baseAPIDesc: String {
        switch self {
        case .baseURL:
            return "https://api.openweathermap.org/data/3.0/"
        }
    }
    
}
