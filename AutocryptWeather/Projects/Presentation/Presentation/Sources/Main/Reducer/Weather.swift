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
import Combine

@Reducer
public struct Weather {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        public init() {}
        
        var weatherModel: WeatherResponseModel? = nil
        var cityModel: CityModels? = nil
        var filterDayWeather: [HourlyWeatherItem] = []
        var dailyWeatherViewItem: [DailyWeatherItem] = []
        var locationMaaner = LocationManger()
        
        var searchText: String = ""
        var currentPage: Int = 0
        var pageSize: Int = 20
        var showCity: Bool = false
        var longitude: Double = 0
        var latitude: Double = 0
        var mainWeatherLoading: Bool = true
        
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        
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
        case citiesLoadResponse(Result<CityModels, CustomError>)
        case cityListLoad
        case searchCity(searchText: String)
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
        
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        
        
    }
    
    @Dependency(WeatherUseCase.self) var weatherUseCase
    @Dependency(CityUseCase.self) var cityUseCase: CityUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.searchText):
                return .none
                
            case .binding(_):
                return .none
                
            case .view(let View):
                switch View {
                    
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
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
                    
                case .fetchWeatherResponse(let result):
                    switch result {
                    case .success(let weatherResponseModel):
                        state.weatherModel = weatherResponseModel
                        Log.debug("날씨 파실 성공")
                        state.mainWeatherLoading = false
                    case .failure(let error):
                        Log.error("날씨 데이터 오류'", error.localizedDescription)
                    }
                    return .none
                    
                case .filterDaileyWeatherResponse(let result):
                    switch result {
                    case .success(let weatherResponseModel):
                        state.filterDayWeather = weatherResponseModel
                    case .failure(let error):
                        Log.error("날씨 데이터 오류'", error.localizedDescription)
                    }
                    return .none
                    
                case .filterDailyWeather(let latitude, let longitude):
                    return .run {  send in
                        let fetchWeatherResult = await Result {
                            try await weatherUseCase.fetchWeather(latitude: latitude, longitude: longitude)
                        }
                        
                        switch fetchWeatherResult {
                        case .success(let weatherResponse):
                            if let weatherResponseModel = weatherResponse {
                                let hourlyWeatherItems =  FilterWeather.shared.mapToHourlyWeatherItems(weatherResponseModel, hoursInterval: 3, totalHours: 48)
                                await send(.async(.filterDaileyWeatherResponse(.success(hourlyWeatherItems))))
                            }
                            
                        case .failure(let error):
                            await send(.async(.filterDaileyWeatherResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
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
                    return .run {  send in
                        let fetchDailyWeatherResult = await Result {
                            try await weatherUseCase.fetchWeather(latitude: latitude, longitude: longitude)
                        }
                        
                        switch fetchDailyWeatherResult {
                        case .success(let weatherResponse):
                            if let weatherResponseModel = weatherResponse {
                                let dailyWeatherItems = FilterWeather.shared.processDailyWeatherData(data: weatherResponseModel.daily ?? [])
                                await send(.async(.dailyWeatherResponse(.success(dailyWeatherItems))))
                            }
                            
                        case .failure(let error):
                            await send(.async(.dailyWeatherResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
                        }
                    }
                    
                case .citiesLoadResponse(let result):
                    switch result {
                    case .success(let newCities):
                        state.cityModel = newCities
                        state.pageSize += 20
                    case .failure(let error):
                        Log.error("city 파실 에러", error.localizedDescription)
                    }
                    return .none
                    
                case .cityListLoad:
                    var currentPage = state.currentPage
                    var pageSize = state.pageSize
                    return .run {  send in
                        let cityData = await Result {
                            try await cityUseCase.loadCities(page: currentPage, pageSize: pageSize, isShowAll: false)
                        }
                        
                        switch cityData {
                            
                        case .success(let cityData):
                            if let cityData = cityData {
                                await send(.async(.citiesLoadResponse(.success(cityData))))
                            }
                        case .failure(let error):
                            await send(.async(.citiesLoadResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
                        }
                    }
                    
                case .searchCity(let searchText):
                    var currentPage = state.currentPage
                    var pageSize = state.pageSize
                    
                    return .run {  send in
                        let cityData = await Result {
                            try await cityUseCase.loadCities(page: currentPage, pageSize: pageSize, isShowAll: true)
                        }
                        
                        switch cityData {
                            
                        case .success(let cityData):
                            if let cityData = cityData {
                                let filterCityData = cityData.filter {
                                    $0.country?.lowercased() == searchText.lowercased() ||
                                    $0.country?.lowercased().contains(searchText.lowercased()) == true ||
                                    $0.name?.lowercased() == searchText.lowercased() ||
                                    $0.name?.lowercased().contains(searchText.lowercased()) == true
                                }
                                await send(.async(.citiesLoadResponse(.success(filterCityData))))
                            }
                        case .failure(let error):
                            await send(.async(.citiesLoadResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
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


