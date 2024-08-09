//
//  Home.swift
//  Presentation
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

import ComposableArchitecture

import Utill
import UseCase
import Model
import Foundations

@Reducer
public struct Home {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        public init() {}
        
        var weatherModel: WeatherResponseModel? = nil
        var filterDayWeather: [HourlyWeatherItem] = []
        var dailyWeatherViewItem: [DailyWeatherItem] = []
        var locationMaaner = LocationManger()
        var date: Date = Date.now
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        
    }
    
    
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case fetchWeatherResponse(Result<WeatherResponseModel, CustomError>)
        case fetchWeather(latitude: Double, longitude: Double)
        case filterDailyWeather(latitude: Double, longitude: Double)
        case filterDaileyWeatherResponse(Result<[HourlyWeatherItem], CustomError>)
        case dailyWeatherResponse(Result<[DailyWeatherItem], CustomError>)
        case dailyWeather(latitude: Double, longitude: Double)
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
        
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        
        
    }
    
    @Dependency(WeatherUseCase.self) var weatherUseCase
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
                
            case .view(let View):
                switch View {
                    
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                case .fetchWeatherResponse(let result):
                    switch result {
                    case .success(let weatherResponseModel):
                        state.weatherModel = weatherResponseModel
                        Log.debug("날씨 파실 성공")
                        
                    case .failure(let error):
                        Log.error("날씨 데이터 오류'", error.localizedDescription)
                    }
                    
                    return .none
                    
                case .fetchWeather(latitude: let latitude, longitude: let longitude):
                    return .run { @MainActor send in
                        let fetchWeatherResult = await Result {
                            try await weatherUseCase.fetchWeather(latitude: latitude, longitude: longitude)
                        }
                        
                        switch fetchWeatherResult {
                        case .success(let weatherResponse):
                            if let weatherResponseModel = weatherResponse {
                                send(.async(.fetchWeatherResponse(.success(weatherResponseModel))))
                            }
                            
                        case .failure(let error):
                            send(.async(.fetchWeatherResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
                        }
                    }
                    
                case .filterDaileyWeatherResponse(let result):
                    switch result {
                    case .success(let weatherResponseModel):
                        state.filterDayWeather = weatherResponseModel
                    case .failure(let error):
                        Log.error("날씨 데이터 오류'", error.localizedDescription)
                    }
                    return .none
                    
                case .filterDailyWeather(let latitude, let longitude):
                    return .run { @MainActor send in
                        let fetchWeatherResult = await Result {
                            try await weatherUseCase.fetchWeather(latitude: latitude, longitude: longitude)
                        }
                        
                        switch fetchWeatherResult {
                        case .success(let weatherResponse):
                            if let weatherResponseModel = weatherResponse {
                                let hourlyWeatherItems =  FilterWeather.shared.mapToHourlyWeatherItems(weatherResponseModel, hoursInterval: 3, totalHours: 48)
                                send(.async(.filterDaileyWeatherResponse(.success(hourlyWeatherItems))))
                            }
                            
                        case .failure(let error):
                            send(.async(.filterDaileyWeatherResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
                        }
                    }
                    
                case .dailyWeatherResponse(let result):
                    switch result {
                    case .success(let hourlyWeatherItems):
                        state.dailyWeatherViewItem = hourlyWeatherItems
                    case .failure(let error):
                        Log.error("날씨 데이터 오류'", error.localizedDescription)
                    }
                    return .none
                    
                case .dailyWeather(latitude: let latitude, longitude: let longitude):
                    return .run { @MainActor send in
                        let fetchDailyWeatherResult = await Result {
                            try await weatherUseCase.fetchWeather(latitude: latitude, longitude: longitude)
                        }
                        
                        switch fetchDailyWeatherResult {
                        case .success(let weatherResponse):
                            if let weatherResponseModel = weatherResponse {
                                let dailyWeatherItems = FilterWeather.shared.processDailyWeatherData(data: weatherResponseModel.daily ?? [])
                                send(.async(.dailyWeatherResponse(.success(dailyWeatherItems))))
                            }
                            
                        case .failure(let error):
                            send(.async(.dailyWeatherResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
                        }
                    }
                }
                    
                
            case .inner(let InnerAction):
                switch InnerAction {
                    
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                    
                }
            }
        }
    }
}


