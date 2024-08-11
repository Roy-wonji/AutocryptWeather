//
//  HourlyWeatherView.swift
//  Presentation
//
//  Created by 서원지 on 8/9/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct HourlyWeatherView: View {
    @Bindable var store: StoreOf<Home>
    @Binding var latitude: Double
    @Binding var longitude: Double

    
    public init(
            store: StoreOf<Home>,
            latitude: Binding<Double>,
            longitude: Binding<Double>)
        {
            self.store = store
            self._latitude = latitude
            self._longitude = longitude
        }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(height: UIScreen.screenHeight * 0.2)
                .padding(.horizontal, 20)
                .overlay {
                    LazyVStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.basicWhite)
                            
                            Text("시간별 일기 예보")
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
                            .padding(.horizontal, 40)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(store.filterDayWeather) { item in
                                    VStack {
                                        Text(item.timeText)
                                            .font(.system(size: 18))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Image(assetName: item.weatherImageName)
                                            .resizable()
                                            .frame(width: 28, height: 28)
                                        
                                        Text(item.tempText)
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            
        }
        .onAppear {
            fetchHourWeather()
        }
        .onChange(of: latitude) { _ in
            fetchHourWeather()
        }
        .onChange(of: longitude) { _ in
            fetchHourWeather()
        }
    }
}



extension HourlyWeatherView {
    
    private func fetchHourWeather() {
           // Ensure latitude and longitude are valid before fetching weather data
           if latitude != 0.0 && longitude != 0.0 {
               store.send(.async(.dailyWeather(
                   latitude: latitude,
                   longitude: longitude
               )))
           } else {
               store.send(.async(.filterDailyWeather(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)))
           }
       }
}
