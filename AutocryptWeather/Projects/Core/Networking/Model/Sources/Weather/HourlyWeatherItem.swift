//
//  HourlyWeatherItem.swift
//  Model
//
//  Created by 서원지 on 8/9/24.
//

import Foundation

public struct HourlyWeatherItem: Identifiable, Equatable {
    public var id: UUID
    public var timeText: String
    public var weatherImageName: String
    public var tempText: String
    
    public init(
        id: UUID,
        timeText: String,
        weatherImageName: String,
        tempText: String
    ) {
        self.id = id
        self.timeText = timeText
        self.weatherImageName = weatherImageName
        self.tempText = tempText
    }
}

