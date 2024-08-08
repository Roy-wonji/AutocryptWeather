//
//  WeatherService.swift
//  Service
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

import API
import Foundations

import Moya


public enum WeatherService {
    case weather(lat: Double, lon: Double)
}


extension WeatherService: BaseTargetType {
    public var path: String {
        switch self {
        case .weather(let lat, let lon):
            return WeatherAPI.onecall.weatherAPIDesc
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .weather:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .weather(let lat, let lon):
            let parameters: [String: Any] = [
                "lat": lat,
                "lon": lon,
                "appid": Bundle.main.apiKey,
                "lang": "KR",
                "units": "metric"
                ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
