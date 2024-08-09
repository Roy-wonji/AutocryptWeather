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
import MapKit

public struct HomeView : View {
    @Bindable var store: StoreOf<Home>
    @Environment(\.scenePhase) var scenePhase
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude:  LocationManger.shared.manager.location?.coordinate.latitude ?? .zero, longitude:  LocationManger.shared.manager.location?.coordinate.longitude ?? .zero),
        span: MKCoordinateSpan(latitudeDelta: 5  , longitudeDelta: 5)
    )
    
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
                        .frame(height: 20)
                    
                    WeatherMapView(store: store, region: $region, rainText: (store.weatherModel?.daily?.first?.pop ?? .zero).formatToOneDecimalPlace((store.weatherModel?.daily?.first?.pop ?? .zero)))
                    
                    Spacer()
                        .frame(height: 20)
                    
                    HStack {
                        homeTempletView(title: "습도", detailData: "\(store.weatherModel?.current?.humidity ?? .zero)%", isWindSpeed: false, windSpeed: "")
                        
                        Spacer()
                        
                        homeTempletView(title: "구름", detailData:  "\(store.weatherModel?.current?.clouds ?? .zero)%"  , isWindSpeed: false, windSpeed: "")
                        
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        homeTempletView(title: "바람 속도", detailData: "\(store.weatherModel?.current?.windSpeed ?? .zero)%", isWindSpeed: true, windSpeed: "\(store.weatherModel?.current?.windGust ?? .zero)%")
                        
                        Spacer()
                        
                        homeTempletView(title: "기압", detailData:  "\(store.weatherModel?.current?.pressure ?? .zero) hPa"  , isWindSpeed: false, windSpeed: "")
                        
                    }
                    .padding(.horizontal, 20)
                    
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
    
    @ViewBuilder
    private func homeTempletView(
        title: String,
        detailData: String,
        isWindSpeed: Bool,
        windSpeed: String
    ) -> some View{
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 160, height: 160)
                .overlay {
                    VStack {
                        Spacer()
                            .frame(height: 10)
                        
                        HStack {
                            
                            Text(title)
                                .pretendardFont(family: .Regular, size: 14)
                                .foregroundStyle(Color.basicWhite)
                                .opacity(0.8)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        HStack {
                            Text(detailData)
                                .pretendardFont(family: .SemiBold, size: 25)
                                .foregroundColor(Color.basicWhite)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        
                        Spacer()
                        
                        if isWindSpeed {
                            HStack {
                                Text("강풍 : \(windSpeed) m/s")
                                    .pretendardFont(family: .SemiBold, size: 14)
                                    .foregroundColor(Color.basicWhite)
                                
                                
                                Spacer()
                            }.padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 20)
                            
                        } else {
                            Spacer()
                        }
                        
                    }
                }
        }
    }
    
}
