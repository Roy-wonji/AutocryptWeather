//
//  Current.swift
//  Model
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

// MARK: - Current
public struct Current: Codable, Equatable {
    public let dt, sunrise, sunset: Int?
    public let temp, feelsLike: Double?
    public let pressure, humidity: Int?
    public let dewPoint, uvi: Double?
    public let clouds, visibility: Int?
    public let windSpeed: Double?
    public let windDeg: Int?
    public let weather: [Weather]?
    public let windGust, pop: Double?

    public enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop
    }
    
    public init(
        dt: Int?,
        sunrise: Int?,
        sunset: Int?,
        temp: Double?,
        feelsLike: Double?,
        pressure: Int?,
        humidity: Int?,
        dewPoint: Double?,
        uvi: Double?,
        clouds: Int?,
        visibility: Int?,
        windSpeed: Double?,
        windDeg: Int?,
        weather: [Weather]?,
        windGust: Double?,
        pop: Double?
    ) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.uvi = uvi
        self.clouds = clouds
        self.visibility = visibility
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.weather = weather
        self.windGust = windGust
        self.pop = pop
    }
}
