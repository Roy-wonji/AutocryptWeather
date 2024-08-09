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
                        Log.debug("날씨 파실 성공")
                        
                    case .failure(let error):
                        Log.error("날씨 데이터 오류'", error.localizedDescription)
                    }
                    
                    return .none
                    
                case .filterDailyWeather(let latitude, let longitude):
                     let hourlyWeatherItems: [(timeText: String, weatherIcon: String, temperature: String)]
                    return .run { @MainActor send in
                        let fetchWeatherResult = await Result {
                            try await weatherUseCase.fetchWeather(latitude: latitude, longitude: longitude)
                        }
                        
                        switch fetchWeatherResult {
                        case .success(let weatherResponse):
                            if let weatherResponseModel = weatherResponse {
                                let hourlyWeatherItems =  mapToHourlyWeatherItems(weatherResponseModel, hoursInterval: 3, totalHours: 48)
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
                        
                        Log.debug("날씨 파실 성공")
                        
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
                                let dailyWeatherItems = processDailyWeatherData(data: weatherResponseModel.daily ?? [])
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
    
    
    func compareTime(
        from target: String
    ) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        
        let currentDate = dateFormatter.string(from: Date())
        let threeDaysLaterDate = dateFormatter.string(from: Calendar.current.date(
            byAdding: .day,
            value: 2,
            to: Date()
        ) ?? Date())
        return currentDate < target && target < threeDaysLaterDate
    }

    func changeFullDateToHourString(from dt: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let calendar = Calendar.current
        
        // Get the current date rounded to the nearest hour
        var currentDate = Date()
        if let roundedCurrentDate = calendar.date(bySetting: .minute, value: 0, of: currentDate) {
            currentDate = roundedCurrentDate
        }
        
        // Check if the date is equal to the current date
        if calendar.isDate(date, equalTo: currentDate, toGranularity: .hour) {
            return "현재"
        }
        
        // Determine whether the time is AM or PM
        let hour = calendar.component(.hour, from: date)
        let period = hour < 12 ? "오전" : "오후"
        
        // Format the hour string
        let hourString: String
        if hour == 0 || hour == 12 {
            hourString = "12시"
        } else {
            hourString = "\(hour % 12)시"
        }
        
        return "\(period) \(hourString)"
    }


    func mapToHourlyWeatherItems(_ weatherResponse: WeatherResponseModel, hoursInterval: Int = 3, totalHours: Int = 48) -> [HourlyWeatherItem] {
        let calendar = Calendar.current
        
        // Truncate the current time to the nearest hour
        var currentDate = Date()
        if let truncatedCurrentDate = calendar.date(bySettingHour: calendar.component(.hour, from: currentDate), minute: 0, second: 0, of: currentDate) {
            currentDate = truncatedCurrentDate
        }
        
        let startDate = currentDate
        let endDate = calendar.date(byAdding: .hour, value: totalHours, to: startDate) ?? Date()
        
        var hourlyWeatherItems = [HourlyWeatherItem]()
        
        if let hourlyData = weatherResponse.hourly {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: weatherResponse.timezoneOffset ?? 0) // Use the offset from the response
            
            for weatherData in hourlyData {
                guard let weatherTimestamp = weatherData.dt else { continue }
                
                let weatherDate = Date(timeIntervalSince1970: TimeInterval(weatherTimestamp))
                
                // Ensure that the weatherDate is within the range [startDate, endDate]
                if weatherDate >= startDate && weatherDate <= endDate {
                    let hourDifference = calendar.dateComponents([.hour], from: startDate, to: weatherDate).hour ?? 0
                    
                    // Only add items that match the 3-hour interval or the current time
                    if hourDifference % hoursInterval == 0 || calendar.isDate(weatherDate, equalTo: currentDate, toGranularity: .hour) {
                        let timeText = calendar.isDate(weatherDate, equalTo: currentDate, toGranularity: .hour)
                            ? "현재"
                            : changeFullDateToHourString(from: weatherTimestamp)
                        
                        let hourlyWeatherItem = HourlyWeatherItem(
                            id: UUID(),
                            timeText: timeText,
                            weatherImageName: weatherData.weather?.first?.icon ?? "default_weather_image",
                            tempText: String(format: "%.1fº", weatherData.temp ?? .zero)
                        )
                        hourlyWeatherItems.append(hourlyWeatherItem)
                    }
                }
            }
        }
        
        return hourlyWeatherItems
    }



    
    func processDailyWeatherData(data: [Daily]) -> [DailyWeatherItem] {
        var lowestTemp: Double = Double.greatestFiniteMagnitude
        var highestTemp: Double = -Double.greatestFiniteMagnitude
        var dailyWeatherViewItem: [DailyWeatherItem] = []
        
        // 최대 5개의 데이터만 처리
        let limit = min(data.count, 5)
        
        for i in 0..<limit {
            let dt = data[i].dt ?? 0
            let date = Date(timeIntervalSince1970: TimeInterval(dt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: date)
            
            let uuid: String = String(describing: data[i].weather?.first?.id ?? 0)
            let weatherImageName = data[i].weather?.first?.icon ?? "01d" // 기본 이미지 "01d" 사용
            let currentTemp = "\(Int(data[i].temp?.day ?? 0.0))º"
            let minTemp = data[i].temp?.min ?? 0.0
            let maxTemp = data[i].temp?.max ?? 0.0
            
            lowestTemp = min(lowestTemp, minTemp)
            highestTemp = max(highestTemp, maxTemp)
            
            let dailyWeatherItem = DailyWeatherItem(
                id: UUID(uuidString: uuid) ?? UUID(),
                timeText: i == 0 ? "오늘" : changeFullDateToDayString(from: dateString),
                weatherImageName: weatherImageName, // weatherImageName 그대로 사용
                currentTemp: currentTemp,
                minTemp: minTemp,
                maxTemp: maxTemp
            )
            dailyWeatherViewItem.append(dailyWeatherItem)
        }
        return dailyWeatherViewItem
    }


    func findFirstIndexItem(date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        
        if let timeDate = dateFormatter.date(from: date) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: timeDate)
            return hour == 0
        }
        
        return false
    }

    func changeFullDateToDayString(
            from fullDate: String
        ) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let date = dateFormatter.date(from: fullDate) {
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "EEEEE"
                dayFormatter.locale = Locale(identifier: "ko_KR")
                return dayFormatter.string(from: date)
            }
            
            return ""
        }
    
}


