//
//  DailyWeatherView.swift
//  Presentation
//
//  Created by 서원지 on 8/9/24.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

public struct DailyWeatherView: View {
    @Bindable var store: StoreOf<Home>
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(height: UIScreen.screenHeight * 0.6)
                .padding(.horizontal, 20)
                .overlay {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.basicWhite)
                            
                            Text("5일간의 일기예보")
                                .pretendardFont(family: .SemiBold, size: 16)
                                .foregroundStyle(Color.basicWhite)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .foregroundStyle(Color.basicWhite)
                        .opacity(0.6)
                        .padding([.top, .leading], 16)
                        
                        Divider()
                            .background(.white)
                            .padding(.horizontal, 12)
                        
                        ForEach(store.dailyWeatherViewItem) { item in
                            
                            DailyWeatherInfoView(
                                dailyWeatherItem: item,
                                geoWidth: calculateWidth(
                                    maxTemp: item.maxTemp,
                                    highestTemp: item.highestTemp,
                                    minTemp: item.minTemp,
                                    lowestTemp: item.lowestTemp
                                ),
                                geoOffset: calculateOffset(
                                    minTemp: item.minTemp,
                                    lowestTemp: item.lowestTemp,
                                    highestTemp: item.highestTemp
                                )
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .onAppear {
                    store.send(.async(.dailyWeather(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)))
                }
            
        }
    }
}


extension DailyWeatherView {
    func calculateWidth(
           maxTemp: Double,
           highestTemp: Double,
           minTemp: Double,
           lowestTemp: Double
       ) -> CGFloat {
           guard maxTemp != minTemp else {
               return 10
           }
           let overall = abs(highestTemp) + abs(lowestTemp)
           let gap = (abs(highestTemp) - abs(maxTemp)) + (abs(lowestTemp) - abs(minTemp))
           return 100 * (abs(overall) - abs(gap)) / overall
       }
    
    func calculateOffset(
            minTemp: Double,
            lowestTemp: Double,
            highestTemp: Double
        ) -> CGFloat {
            let overall = abs(highestTemp) + abs(lowestTemp)
            let gap = abs(abs(lowestTemp) - abs(minTemp))
            return 100 * gap / overall
        }
}
