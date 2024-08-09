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
                .frame(height: UIScreen.screenHeight * 0.34)
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
                            .padding(.horizontal, 40)
                        
                        ForEach(store.dailyWeatherViewItem) { item in
                            
                            DailyWeatherInfoView(
                                dailyWeatherItem: item
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
    
    
}
