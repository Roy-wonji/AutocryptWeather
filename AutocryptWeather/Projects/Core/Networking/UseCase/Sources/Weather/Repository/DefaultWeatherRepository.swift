//
//  DefaultWeatherRepository.swift
//  UseCase
//
//  Created by 서원지 on 8/8/24.
//

import Foundation
import Model

public final class DefaultWeatherRepository: WeatherRepositoryProtocol {
    
    public init() {}
    
    public func fetchWeather(
        latitude: Double,
        longitude: Double
    ) async throws -> WeatherResponseModel? {
        return nil
    }
}
