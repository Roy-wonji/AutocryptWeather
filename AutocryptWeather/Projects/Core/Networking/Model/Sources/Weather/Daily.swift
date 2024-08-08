//
//  Daily.swift
//  Model
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

// MARK: - Daily
public struct Daily: Codable, Equatable {
    public let dt, sunrise, sunset, moonrise: Int?
    public let moonset: Int?
    public let moonPhase: Double?
    public let summary: String?
    public let temp: Temp?
    public let feelsLike: FeelsLike?
    public let pressure, humidity: Int?
    public let dewPoint, windSpeed: Double?
    public let windDeg: Int?
    public let windGust: Double?
    public let weather: [Weather]?
    public let clouds: Int?
    public let pop, rain, uvi: Double?

    public enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case summary, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi
    }
    
    public init(
        dt: Int?,
        sunrise: Int?,
        sunset: Int?,
        moonrise: Int?,
        moonset: Int?,
        moonPhase: Double?,
        summary: String?,
        temp: Temp?,
        feelsLike: FeelsLike?,
        pressure: Int?,
        humidity: Int?,
        dewPoint: Double?,
        windSpeed: Double?,
        windDeg: Int?,
        windGust: Double?,
        weather: [Weather]?,
        clouds: Int?,
        pop: Double?,
        rain: Double?,
        uvi: Double?
    ) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.moonrise = moonrise
        self.moonset = moonset
        self.moonPhase = moonPhase
        self.summary = summary
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.windGust = windGust
        self.weather = weather
        self.clouds = clouds
        self.pop = pop
        self.rain = rain
        self.uvi = uvi
    }
    
}
