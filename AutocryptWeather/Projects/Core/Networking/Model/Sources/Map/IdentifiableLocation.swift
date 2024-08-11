//
//  IdentifiableLocation.swift
//  Model
//
//  Created by 서원지 on 8/10/24.
//

import Foundation
import MapKit

public struct IdentifiableLocation: Identifiable {
    public let id = UUID()
    public let coordinate: CLLocationCoordinate2D
    
    
    public init(
        coordinate: CLLocationCoordinate2D
    ) {
        self.coordinate = coordinate
    }
}
