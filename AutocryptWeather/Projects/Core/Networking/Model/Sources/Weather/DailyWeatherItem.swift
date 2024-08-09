//
//  DailyWeatherItem.swift
//  Model
//
//  Created by 서원지 on 8/9/24.
//

import Foundation

public struct DailyWeatherItem: Identifiable, Equatable {
    public var id: UUID
    public var timeText: String
    public var weatherImageName: String
    public var currentTemp: String
    public var minTemp: Double
    public var maxTemp: Double
    public var lowestTemp: Double
    public var highestTemp: Double
    
    public init(
        id: UUID,
        timeText: String,
        weatherImageName: String,
        currentTemp: String,
        minTemp: Double,
        maxTemp: Double,
        lowestTemp: Double,
        highestTemp: Double
    ) {
        self.id = id
        self.timeText = timeText
        self.weatherImageName = weatherImageName
        self.currentTemp = currentTemp
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.lowestTemp = lowestTemp
        self.highestTemp = highestTemp
    }
}
