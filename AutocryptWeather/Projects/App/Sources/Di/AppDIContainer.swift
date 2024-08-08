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
//        await registerSignUpUseCase()

//        await registerQrCodeUseCase()
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
    
//    private func registerSignUpUseCase() async {
//        await diContainer.register(SignUpUseCaseProtocol.self) {
//            guard let repository = self.diContainer.resolve(SignUpRepositoryProtocol.self) else {
//                assertionFailure("SignUpRepositoryProtocol must be registered before registering SignUpUseCaseProtocol")
//                return SignUpUseCase(repository: DefaultSignUpRepository())
//            }
//            return SignUpUseCase(repository: repository)
//        }
//    }


    // MARK: - Repositories Registration
    private func registerRepositories() async {
        await registerWeatherRepositories()

    }

    private func registerWeatherRepositories() async {
        await diContainer.register(WeatherRepositoryProtocol.self) {
            WeatherRepository()
        }
    }
//    
//    private func registerSignUpRepositories() async {
//        await diContainer.register(SignUpRepositoryProtocol.self) {
//            SingUpRepository()
//        }
//    }
    
}

