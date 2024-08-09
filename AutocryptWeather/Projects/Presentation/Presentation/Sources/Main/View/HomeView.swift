//
//  HomeView.swift
//  Presentation
//
//  Created by 서원지 on 8/8/24.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem
import Utill

public struct HomeView : View {
    @Bindable var store: StoreOf<Home>
    @Environment(\.scenePhase) var scenePhase
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack{
            Image(asset: .bgClear)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    Spacer()
                        .frame(height: 20)
                    
                    mainHeaderView()
                    
                    Spacer()
                        .frame(height: 20)

                    HourlyWeatherView(store: store)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    DailyWeatherView(store: store)
                    
                    
                    Spacer()
                        .frame(height: 50)
                }
                .refreshable {
                    store.send(.async(.fetchWeather(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)))
                    store.send(.async(.filterDailyWeather(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)))
                    store.send(.async(.dailyWeather(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)))
                }
            }
            .onAppear{
                store.send(.async(.fetchWeather(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)))
            }
            
            .onChange(of: scenePhase) { oldValue, newValue in
                switch newValue {
                case .active:
                    LocationManger.shared.checkAuthorizationStatus()
                    store.send(.async(.fetchWeather(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)))
                case .inactive:
                    LocationManger.shared.checkAuthorizationStatus()
                    store.send(.async(.fetchWeather(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)))
                case .background:
                    LocationManger.shared.checkAuthorizationStatus()
                @unknown default:
                    break
                }
            }
        }
    }
}

extension HomeView {
    
    @ViewBuilder
    private func mainHeaderView() -> some View {
        VStack(alignment: .center) {
            Text(store.weatherModel?.timezone?.split(separator: "/").last ?? "")
                .pretendardFont(family: .SemiBold, size: 40)
                .foregroundStyle(Color.basicWhite)
            
            Text("\(Int(store.weatherModel?.current?.temp ?? .zero))º")
                .pretendardFont(family: .SemiBold, size: 30)
                .foregroundStyle(Color.basicWhite)

            Text(store.weatherModel?.current?.weather?.first?.description ?? "")
                .pretendardFont(family: .Regular, size: 25)
                .foregroundStyle(Color.basicWhite)
//
            HStack {
                Text("최고:")
                    .pretendardFont(family: .Regular, size: 20)
                    .foregroundStyle(Color.basicWhite)
                
                Spacer()
                    .frame(width: 4)
                
                Text("\(store.weatherModel?.daily?.first?.temp?.max?.formatToOneDecimalPlace(store.weatherModel?.daily?.first?.temp?.max ?? .zero) ?? "")º")
                    .foregroundStyle(Color.basicWhite)
                    .pretendardFont(family: .Regular, size: 20)
                
                Spacer()
                    .frame(width: 10)
                
                Rectangle()
                    .fill(Color.basicWhite)
                    .frame(width: 1, height: 16)
                    
                
                Spacer()
                    .frame(width: 10)
                
                Text("최저:")
                    .pretendardFont(family: .Regular, size: 20)
                    .foregroundStyle(Color.basicWhite)
                
                Spacer()
                    .frame(width: 4)
                
                Text("\(store.weatherModel?.daily?.first?.temp?.min?.formatToOneDecimalPlace(store.weatherModel?.daily?.first?.temp?.min ?? .zero) ?? "")º")
                    .foregroundStyle(Color.basicWhite)
                    .pretendardFont(family: .Regular, size: 20)
                    
            }
        }
    }
    
}
