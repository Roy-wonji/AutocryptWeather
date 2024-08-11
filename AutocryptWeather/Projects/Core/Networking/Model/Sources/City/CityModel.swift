//
//  CityModel.swift
//  Model
//
//  Created by 서원지 on 8/10/24.
//

import Foundation

public typealias CityModels = [CityModel]

// MARK: - Welcome
public struct CityModel:  Equatable , Codable{
    public let id: Int?
    public let name, country: String?
    public let coord: Coord?
    
    public init(
        id: Int?,
        name: String?,
        country: String?,
        coord: Coord?
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.coord = coord
    }
}

// MARK: - Coord
public struct Coord: Codable , Equatable{
    public let lon, lat: Double?
    
    public init(
        lon: Double?,
        lat: Double?
    ) {
        self.lon = lon
        self.lat = lat
    }
}



