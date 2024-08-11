//
//  WeatherMapView.swift
//  Presentation
//
//  Created by 서원지 on 8/9/24.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem
import MapKit
import Model


public struct WeatherMapView: View {
    @Binding var region: MKCoordinateRegion
    @State private var userLocation: IdentifiableLocation
    @Binding var latitude: Double
    @Binding var longitude: Double
    @Namespace private var namespace
    
    @State private var coordinate: CLLocationCoordinate2D
    @Bindable var store: StoreOf<Weather>
    

    init(
        region: Binding<MKCoordinateRegion>,
        latitude: Binding<Double>,
        longitude: Binding<Double>,
        store: StoreOf<Weather>
        
    ) {
        self._region = region
        self._latitude = latitude
        self._longitude = longitude
        
        let initialCoordinate: CLLocationCoordinate2D
        if latitude.wrappedValue != 0.0 && longitude.wrappedValue != 0.0 {
            initialCoordinate = CLLocationCoordinate2D(latitude: latitude.wrappedValue, longitude: longitude.wrappedValue)
        } else if let location = store.locationMaaner.manager.location {
            initialCoordinate = location.coordinate
        } else {
            initialCoordinate = region.wrappedValue.center
        }
        self._coordinate = State(initialValue: initialCoordinate)
        self._userLocation = State(initialValue: IdentifiableLocation(coordinate: initialCoordinate))
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(height: UIScreen.screenHeight * 0.4)
                .padding(.horizontal, 20)
                .overlay(
                    VStack(alignment: .leading) {
                        HStack {
                            Text("강수량")
                                .pretendardFont(family: .SemiBold, size: 16)
                                .foregroundStyle(Color.basicWhite)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .foregroundStyle(Color.basicWhite)
                        .opacity(0.6)
                        .padding([.top, .leading], 16)
                        
                        Divider()
                            .background(Color.white)
                            .padding(.horizontal, 40)
                        
                        Spacer().frame(height: 10)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear)
                            .frame(height: UIScreen.screenHeight * 0.3)
                            .padding(.horizontal, 40)
                            .overlay(
                                Map(coordinateRegion: $region, showsUserLocation: false, annotationItems: [userLocation]) { location in
                                    MapMarker(coordinate: location.coordinate)
                                }
                                    .mapScope(namespace)
                                    .frame(height: UIScreen.screenHeight * 0.3)
                                    .padding(.horizontal, 40)
                                    .colorScheme(.dark)
                                    .mapStyle(.standard(elevation: .flat))
                            )
                        
                        Spacer().frame(height: 20)
                    }
                )
        }
        .onAppear {
            updateCoordinate()
        }
        .onChange(of: latitude) { _ in updateCoordinate() }
        .onChange(of: longitude) { _ in updateCoordinate() }
    }
    
    private func updateCoordinate() {
        if latitude != 0.0 && longitude != 0.0 {
            withAnimation {
                let newCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                coordinate = newCoordinate
                userLocation = IdentifiableLocation(coordinate: newCoordinate)
                region.center = newCoordinate
                region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            }
        } else {
            withAnimation {
                store.locationMaaner.checkAuthorizationStatus()
                let newCoordinate = CLLocationCoordinate2D(latitude: store.locationMaaner.manager.location?.coordinate.latitude ?? .zero, longitude: store.locationMaaner.manager.location?.coordinate.longitude ?? .zero)
                coordinate = newCoordinate
                userLocation = IdentifiableLocation(coordinate: newCoordinate)
                region.center = newCoordinate
                region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            }
        }
    }
}

