//
//  Weather.swift
//  Model
//
//  Created by 서원지 on 8/8/24.
//

import Foundation

// MARK: - Weather
public struct Weather: Codable, Equatable {
    public let id: Int?
    public let main: String?
    public let description: String?
    public let icon: String?
    
    public init(
        id: Int?,
        main: String?,
        description: String?,
        icon: String?
    ) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}
