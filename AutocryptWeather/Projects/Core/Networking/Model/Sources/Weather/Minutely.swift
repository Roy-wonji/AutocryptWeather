//
//  Minutely.swift
//  Model
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

// MARK: - Minutely
public struct Minutely: Codable, Equatable {
    public let dt, precipitation: Int?
    
    public init(
        dt: Int?,
        precipitation: Int?
    ) {
        self.dt = dt
        self.precipitation = precipitation
    }
}
