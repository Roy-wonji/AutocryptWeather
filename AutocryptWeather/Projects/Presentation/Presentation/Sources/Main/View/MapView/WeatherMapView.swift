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
    var rainText: String
    
    @State private var coordinate: CLLocationCoordinate2D
    
    init(region: Binding<MKCoordinateRegion>, latitude: Binding<Double>, longitude: Binding<Double>, rainText: String) {
            self._region = region
            self._latitude = latitude
            self._longitude = longitude
            self.rainText = rainText
            
            // Initialize the coordinate based on the provided latitude/longitude or fallback to the user's location
            let initialCoordinate: CLLocationCoordinate2D
            if latitude.wrappedValue != 0.0 && longitude.wrappedValue != 0.0 {
                initialCoordinate = CLLocationCoordinate2D(latitude: latitude.wrappedValue, longitude: longitude.wrappedValue)
            } else {
                initialCoordinate = region.wrappedValue.center
            }
            self._coordinate = State(initialValue: initialCoordinate)
            self._userLocation = State(initialValue: IdentifiableLocation(coordinate: initialCoordinate))
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
                                    
                                    MapAnnotation(coordinate: coordinate) {
                                        Circle()
                                            .fill(Color.basicWhite)
                                            .frame(width: 25, height: 25)
                                            .overlay(
                                                Circle()
                                                    .fill(Color.blue)
                                                    .frame(width: 18, height: 18)
                                                    .overlay(
                                                        Text(rainText)
                                                            .pretendardFont(family: .Regular, size: 10)
                                                            .foregroundColor(Color.basicWhite)
                                                    )
                                            )
                                    }
                                }
                                    .frame(height: UIScreen.screenHeight * 0.3)
                                    .padding(.horizontal, 40)
                                    .colorScheme(.dark)
                                    .mapStyle(.standard(elevation: .flat))
                            )
                        
                        Spacer().frame(height: 20)
                    }
                )
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
                withAnimation {
                    region.center = newCoordinate
                    region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1) 
                }
            }
        } 
        
    }
}

