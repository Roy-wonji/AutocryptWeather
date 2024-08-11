//
//  AppDIContainer.swift
//  Weather
//
//  Created by 서원지 on 8/8/24.
//

import Foundation
import UseCase
import DiContainer

public final class AppDIContainer {
    public static let shared: AppDIContainer = .init()

    private let diContainer: DependencyContainer = .live

    private init() {
    }

    public func registerDependencies() async {
        await registerRepositories()
        await registerUseCases()
    }

    // MARK: - Use Cases
    private func registerUseCases() async {
        await registerWeatherUseCase()
        await registerCityUseCase()
    }

    private func registerWeatherUseCase() async {
        await diContainer.register(WeatherUseCaseProtocol.self) {
            guard let repository = self.diContainer.resolve(WeatherRepositoryProtocol.self) else {
                assertionFailure("AuthRepositoryProtocol must be registered before registering AuthUseCaseProtocol")
                return WeatherUseCase(repository: DefaultWeatherRepository())
            }
            return WeatherUseCase(repository: repository)
        }
    }
    
    private func registerCityUseCase() async {
        await diContainer.register(CityUseCaseProtocol.self) {
            guard let repository = self.diContainer.resolve(CityRepositoryProtocol.self) else {
                assertionFailure("AuthRepositoryProtocol must be registered before registering AuthUseCaseProtocol")
                return CityUseCase(repository: DefaultCityRepository())
            }
            return CityUseCase(repository: repository)
        }
    }
    

    // MARK: - Repositories Registration
    private func registerRepositories() async {
        await registerWeatherRepositories()
        await registerCityRepositories()

    }

    private func registerWeatherRepositories() async {
        await diContainer.register(WeatherRepositoryProtocol.self) {
            WeatherRepository()
        }
    }

    
    private func registerCityRepositories() async {
        await diContainer.register(CityRepositoryProtocol.self) {
            CityRepository()
        }
    }    
}

