//
//  FilterWeather.swift
//  Presentation
//
//  Created by 서원지 on 8/9/24.
//

import Foundation
import Model

public struct FilterWeather{
    
    public static let shared = FilterWeather()
    
    public init() {}
    
    //MARK: - 날짜 변환
    func changeFullDateToHourString(from dt: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let calendar = Calendar.current
        
        var currentDate = Date()
        if let roundedCurrentDate = calendar.date(bySetting: .minute, value: 0, of: currentDate) {
            currentDate = roundedCurrentDate
        }
        
        if calendar.isDate(date, equalTo: currentDate, toGranularity: .hour) {
            return "현재"
        }
        
        
        let hour = calendar.component(.hour, from: date)
        let period = hour < 12 ? "오전" : "오후"
        
        let hourString: String
        if hour == 0 || hour == 12 {
            hourString = "12시"
        } else {
            hourString = "\(hour % 12)시"
        }
        
        return "\(period) \(hourString)"
    }

    //MARK: - 48시간 날짜로  날씨 보여주기
    func mapToHourlyWeatherItems(
        _ weatherResponse: WeatherResponseModel,
        hoursInterval: Int = 3,
        totalHours: Int = 48
    ) -> [HourlyWeatherItem] {
        let calendar = Calendar.current
        
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
            dateFormatter.timeZone = TimeZone(secondsFromGMT: weatherResponse.timezoneOffset ?? .zero)
            for weatherData in hourlyData {
                guard let weatherTimestamp = weatherData.dt else { continue }
                
                let weatherDate = Date(timeIntervalSince1970: TimeInterval(weatherTimestamp))
                
                // Ensure that the weatherDate is within the range [startDate, endDate]
                if weatherDate >= startDate && weatherDate <= endDate {
                    let hourDifference = calendar.dateComponents([.hour], from: startDate, to: weatherDate).hour ?? .zero
                    
                    if hourDifference % hoursInterval == .zero || calendar.isDate(weatherDate, equalTo: currentDate, toGranularity: .hour) {
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
    
    //MARK: - 5일간 날씨 가져오기
    func processDailyWeatherData(data: [Daily]) -> [DailyWeatherItem] {
        var dailyWeatherViewItem: [DailyWeatherItem] = []
        
        // 최대 5개의 데이터만 처리
        let limit = min(data.count, 5)
        
        for i in 0..<limit {
            let dt = data[i].dt ?? .zero
            let date = Date(timeIntervalSince1970: TimeInterval(dt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone(identifier: "KST")
            let dateString = dateFormatter.string(from: date)
            
            // 첫 번째 항목을 찾기 위한 로직 적용
            let timeText: String
            if i == 0 || findFirstIndexItem(date: dateString) {
                timeText = "오늘"
            } else {
                timeText = changeFullDateToDayString(from: dateString)
            }
            
            let uuid: String = String(describing: data[i].weather?.first?.id ?? .zero)
            let weatherImageName = data[i].weather?.first?.icon ?? "01d"
            let currentTemp = "\(Int(data[i].temp?.day ?? .zero))º"
            let minTemp = data[i].temp?.min ?? .zero
            let maxTemp = data[i].temp?.max ?? .zero
            
            let dailyWeatherItem = DailyWeatherItem(
                id: UUID(uuidString: uuid) ?? UUID(),
                timeText: timeText,
                weatherImageName: weatherImageName, // weatherImageName 그대로 사용
                currentTemp: currentTemp,
                minTemp: minTemp,
                maxTemp: maxTemp
            )
            dailyWeatherViewItem.append(dailyWeatherItem)
        }
        return dailyWeatherViewItem
    }

    //MARK: - 인덱스에서 시작 날짜 찾기
    func findFirstIndexItem(date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        
        if let timeDate = dateFormatter.date(from: date) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: timeDate)
            return hour == .zero
        }
        
        return false
    }

    //MARK: - 요일 변환
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
