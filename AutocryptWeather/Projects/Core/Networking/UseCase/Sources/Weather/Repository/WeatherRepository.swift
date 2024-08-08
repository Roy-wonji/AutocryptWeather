//
//  WeatherRepository.swift
//  UseCase
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

import Moya
import Model

import Service

import Foundations


@Observable public class WeatherRepository : WeatherRepositoryProtocol {
    private let provider = MoyaProvider<WeatherService>()
    
    public init() {
        
    }
    
    //MARK: - 날씨 조회
    public func fetchWeather(
        latitude: Double,
        longitude: Double
    ) async throws -> WeatherResponseModel? {
        return try await provider.requestAsync(.weather(lat: latitude, lon: longitude), decodeTo: WeatherResponseModel.self)
    }
}
