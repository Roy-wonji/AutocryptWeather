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

struct IdentifiableLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

public struct WeatherMapView: View {
    @Bindable var store: StoreOf<Home>
    @Binding var region: MKCoordinateRegion
    @State private var userLocation = IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: LocationManger.currentLocation?.latitude ?? .zero, longitude: LocationManger.currentLocation?.longitude ?? .zero))

    var rainText: String
    
    public init(
        store: StoreOf<Home>,
        region: Binding<MKCoordinateRegion>,
        rainText: String
    ) {
        self.store = store
        self._region = region
        self.rainText = rainText
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(height: UIScreen.screenHeight * 0.4)
                .padding(.horizontal, 20)
                .overlay {
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
                            .background(.white)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                            .frame(height: 10)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear)
                            .frame(height:  UIScreen.screenHeight * 0.3)
                            .padding(.horizontal, 40)
                            .overlay {
                                Map(coordinateRegion: $region, interactionModes: [.zoom], showsUserLocation: true, annotationItems: [userLocation]) { location in
                                    MapAnnotation(coordinate: location.coordinate) {
                                        Circle()
                                            .fill(Color.basicWhite)
                                            .frame(width: 25, height: 25)
                                            .overlay {
                                                Circle()
                                                    .fill(Color.blue)
                                                    .frame(width: 20, height: 20)
                                                    .overlay {
                                                        Text(rainText)
                                                            .pretendardFont(family: .Regular, size: 10)
                                                            .foregroundColor(Color.basicWhite)
                                                    }
                                            }
                                    }
                                }
                                .frame(height: UIScreen.screenHeight * 0.3)
                                .padding(.horizontal, 40)
                                .colorScheme(.dark)
                                .mapStyle(.standard(elevation: .flat))


                            }
                            
                        
                        Spacer()
                            .frame(height: 20)
                        
                    }
                }
            
        }
    }
}
