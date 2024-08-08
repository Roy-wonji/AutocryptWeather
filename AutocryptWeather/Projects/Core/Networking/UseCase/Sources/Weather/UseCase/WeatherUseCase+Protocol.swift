//
//  WeatherUseCase+Protocol.swift
//  UseCase
//
//  Created by 서원지 on 8/8/24.
//

import Foundation
import Model

public protocol WeatherUseCaseProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponseModel?
}
