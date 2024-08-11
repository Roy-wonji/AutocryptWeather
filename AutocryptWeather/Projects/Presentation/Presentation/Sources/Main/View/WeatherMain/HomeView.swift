//
//  HomeView.swift
//  Presentation
//
//  Created by 서원지 on 8/8/24.
//

import SwiftUI
import MapKit
import Combine

import ComposableArchitecture
import DesignSystem

import Utill


public struct WeatherView : View {
    @Bindable var store: StoreOf<Weather>
    @Environment(\.scenePhase) var scenePhase
    var location = LocationManger()
    @State private var cancellable: AnyCancellable?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude:  LocationManger.shared.manager.location?.coordinate.latitude ?? .zero, longitude:  LocationManger.shared.manager.location?.coordinate.longitude ?? .zero),
        span: MKCoordinateSpan(latitudeDelta: 5  , longitudeDelta: 5)
    )
    
    
    public init(store: StoreOf<Weather>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack{
            Image(asset: .bgClear)
                .resizable()
                .ignoresSafeArea()
            
            if store.mainWeatherLoading {
                Spacer()
                
                ProgressView()
                    .progressViewStyle(.circular)
                
                
                Spacer()
            } else {
                VStack {
                    Spacer()
                        .frame(height: 20)
                    
                    searchBar()
                    
                    ScrollView(showsIndicators: false) {
                        if !store.searchText.isEmpty ||  store.showCity {
                            cityLists()
                                .onAppear {
                                    store.send(.async(.cityListLoad))
                                }
                                .onChange(of: store.searchText) { oldValue, newValue in
                                    if newValue.isEmpty {
                                        store.send(.async(.cityListLoad))
                                    } else {
                                        store.send(.async(.searchCity(searchText: newValue)))
                                    }
                                }
                               
                        } else if store.showCity == false {
                            weatherView()
                            
                        }
                        
                    }
                    .refreshable {
                        refreshWeatherData()
                    }
                }
                .onAppear {
                    store.locationMaaner.checkAuthorizationStatus()
                }
                .onChange(of: store.longitude) { newValue in
                    store.longitude = newValue
                    
                    checkAndFetchWeathers()
                }
                .onChange(of: store.latitude) { newValue in
                    store.latitude = newValue
                    
                    checkAndFetchWeathers()
                }
                
                .onChange(of: scenePhase) { oldValue, newValue in
                    switch newValue {
                    case .active:
                        store.locationMaaner.checkAuthorizationStatus()
                        store.send(.async(.fetchWeather(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)))
                    case .inactive:
                        store.locationMaaner.checkAuthorizationStatus()
                        store.send(.async(.fetchWeather(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)))
                    case .background:
                        store.locationMaaner.checkAuthorizationStatus()
                    @unknown default:
                        break
                    }
                }
            }
            
            
           
        }
    }
}

extension WeatherView {
    
    @ViewBuilder
    private func weatherView() -> some View {
        LazyVStack {
            Spacer()
                .frame(height: 20)
            
            mainHeaderView()
           
            HourlyWeatherView(store: store, latitude: $store.latitude, longitude: $store.longitude)
            
            Spacer()
                .frame(height: 20)
            
            DailyWeatherView(store: store, latitude: $store.latitude, longitude: $store.longitude)
            
            Spacer()
                .frame(height: 20)
            
            WeatherMapView(region: $region, latitude: $store.latitude, longitude: $store.longitude, store: store)
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                homeTempletView(title: "습도", detailData: "\(store.weatherModel?.current?.humidity ?? .zero)%", isWindSpeed: false, windSpeed: "")
                
                Spacer()
                
                homeTempletView(title: "구름", detailData:  "\(store.weatherModel?.current?.clouds ?? .zero)%"  , isWindSpeed: false, windSpeed: "")
                
            }
            .padding(.horizontal, 20)
            
            HStack {
                homeTempletView(title: "바람 속도", detailData: "\(store.weatherModel?.current?.windSpeed ?? .zero) m/s", isWindSpeed: true, windSpeed: "\(store.weatherModel?.current?.windGust ?? .zero)")
                
                Spacer()
                
                homeTempletView(title: "기압", detailData:  "\(store.weatherModel?.current?.pressure ?? .zero) hPa"  , isWindSpeed: false, windSpeed: "")
                
            }
            .padding(.horizontal, 20)

            
            Spacer()
                .frame(height: 50)
        }
    }
    
    @ViewBuilder
    private func mainHeaderView() -> some View {
        LazyVStack(alignment: .center) {
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
    
    
    @ViewBuilder
    private func searchBar() -> some View {
        VStack {
            Spacer()
                .frame(height: 20)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray300.opacity(0.5))
                .frame(height:  48)
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .onTapGesture {
                                    store.showCity = true
                                }
                            
                            Spacer()
                                .frame(width: 10)
                            
                            TextField("도시를 검색 해주세여!", text: $store.searchText)
                                .pretendardFont(family: .SemiBold, size: 20)
                                .foregroundStyle(store.searchText.isEmpty ? Color.gray200 : Color.basicWhite)
                                .onSubmit {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                                .onTapGesture {
                                    store.showCity = true
                                }
                               
                            Spacer()
                        }
                    }
                    .onTapGesture {
                        store.showCity.toggle()
                    }
                    
                }
                
        }
        .padding(.horizontal, 20)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    @ViewBuilder
    private func cityLists() -> some View {
        LazyVStack {
            if let cityModel = store.cityModel {
                ForEach(cityModel, id: \.id) { item in
                    cityList(name: item.name ?? "", country: item.country ?? "", completion: {
                        store.longitude = item.coord?.lon ?? .zero
                        store.latitude = item.coord?.lat ?? .zero
                        store.showCity = false
                        store.searchText = ""
                    })
                    .onAppear {
                        if item == store.cityModel?.last {
                            store.send(.async(.cityListLoad))
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func cityList(name: String, country: String, completion: @escaping() -> Void) -> some View {
        VStack {
            Spacer()
                .frame(height: 10)
            
            HStack {
                Text(name)
                    .pretendardFont(family: .SemiBold, size: 20)
                    .foregroundColor(Color.basicWhite)
                
                Spacer()
            }
            .onTapGesture {
                completion()
            }
            
            Spacer()
                .frame(height: 5)
            
            HStack {
                Text(country)
                    .pretendardFont(family: .SemiBold, size: 20)
                    .foregroundColor(Color.basicWhite)
                
                Spacer()
            }
            .onTapGesture {
                completion()
            }
            
            Divider()
                .background(.white)
        }
        .padding(.horizontal, 20)
        .onTapGesture {
            completion()
        }
    }
    private func checkAndFetchWeather() {
        if store.latitude != 0.0 && store.longitude != 0.0 {
            cancellable?.cancel()
            cancellable = Just(())
                .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
                .sink { _ in
                    region.span =  MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                    checkAndFetchWeathers()
                }
        }
    }
    
    private func checkAndFetchWeathers() {
           if store.latitude != 0.0 && store.longitude != 0.0 {
               region.center = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
               region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
               
               refreshWeatherData()
           }
       }
       
       private func refreshWeatherData() {
           if store.latitude == .zero && store.longitude == .zero {
               store.send(.async(.fetchWeather(
                latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero,
                longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero
               )))
               store.send(.async(.filterDailyWeather(
                latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero,
                longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero
               )))
               store.send(.async(.dailyWeather(
                latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero,
                longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero
               )))
           } else {
               store.send(.async(.fetchWeather(
                   latitude: store.latitude,
                   longitude: store.longitude
               )))
               store.send(.async(.filterDailyWeather(
                   latitude: store.latitude,
                   longitude: store.longitude
               )))
               store.send(.async(.dailyWeather(
                   latitude: store.latitude,
                   longitude: store.longitude
               )))
           }
       }
}
