//
//  WeatherUseCase.swift
//  UseCase
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

import DiContainer
import Model


import ComposableArchitecture

public struct WeatherUseCase: WeatherUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol
    
    public init(
        repository: WeatherRepositoryProtocol
    ) {
        self.repository = repository
    }
    
    //MARK: - 현재 위치의 날씨 정보 가져오기
    public func fetchWeather(
        latitude: Double,
        longitude: Double
    ) async throws -> WeatherResponseModel? {
        try await repository.fetchWeather(latitude: latitude, longitude: longitude)
    }
    
}
    

extension  WeatherUseCase: DependencyKey {
    public static let liveValue: WeatherUseCase = {
        let weatherRepository = DependencyContainer.live.resolve(WeatherRepositoryProtocol.self) ?? DefaultWeatherRepository()
        return WeatherUseCase(repository: weatherRepository)
    }()
}
