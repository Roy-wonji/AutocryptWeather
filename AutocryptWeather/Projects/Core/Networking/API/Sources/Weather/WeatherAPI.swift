//
//  WeatherAPI.swift
//  API
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

public enum WeatherAPI: String {
    case onecall
    
    public var weatherAPIDesc: String {
        switch self {
        case .onecall:
            return "onecall"
        }
    }
}
