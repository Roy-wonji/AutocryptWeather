//
//  Temp.swift
//  Model
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

// MARK: - Temp
public struct Temp: Codable, Equatable {
    public let day, min, max, night: Double?
    public let eve, morn: Double?
    
    public init(
        day: Double?,
        min: Double?,
        max: Double?,
        night: Double?,
        eve: Double?,
        morn: Double?
    ) {
        self.day = day
        self.min = min
        self.max = max
        self.night = night
        self.eve = eve
        self.morn = morn
    }
}
