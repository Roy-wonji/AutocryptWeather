//
//  FeelsLike.swift
//  Model
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

// MARK: - FeelsLike
public struct FeelsLike: Codable, Equatable {
    public let day, night, eve, morn: Double?
    
    public init(
        day: Double?,
        night: Double?,
        eve: Double?,
        morn: Double?
    ) {
        self.day = day
        self.night = night
        self.eve = eve
        self.morn = morn
    }
}
