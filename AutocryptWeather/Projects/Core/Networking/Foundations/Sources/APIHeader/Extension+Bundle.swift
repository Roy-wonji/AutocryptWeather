//
//  Extension+Bundle.swift
//  Foundations
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

public extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "WeatherInfo", ofType: "plist") else { return  "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("DEBUG: WeatherInfo.plist에서 API_KEY 설정 에러") }
        
        return key
    }
}
