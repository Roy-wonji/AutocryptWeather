//
//  WeatherResponseModel.swift
//  Model
//
//  Created by 서원지 on 8/8/24.
//

import Foundation


// MARK: - Welcome
public struct WeatherResponseModel: Codable, Equatable {
    public let lat, lon: Double?
    public let timezone: String?
    public let timezoneOffset: Int?
    public let current: Current?
    public let minutely: [Minutely]?
    public let hourly: [Current]?
    public let daily: [Daily]?

    public enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, minutely, hourly, daily
    }
    
    public init(
        lat: Double?,
        lon: Double?,
        timezone: String?,
        timezoneOffset: Int?,
        current: Current?,
        minutely: [Minutely]?,
        hourly: [Current]?,
        daily: [Daily]?
    ) {
        self.lat = lat
        self.lon = lon
        self.timezone = timezone
        self.timezoneOffset = timezoneOffset
        self.current = current
        self.minutely = minutely
        self.hourly = hourly
        self.daily = daily
    }
    
    
}




