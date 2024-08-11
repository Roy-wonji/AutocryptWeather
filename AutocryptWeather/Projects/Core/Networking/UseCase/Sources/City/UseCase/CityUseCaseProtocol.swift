//
//  CityUseCaseProtocol.swift
//  UseCase
//
//  Created by 서원지 on 8/10/24.
//

import Foundation
import Model

public protocol CityUseCaseProtocol {
    func  loadCities(page: Int, pageSize: Int, isShowAll: Bool)  async throws -> CityModels?
    func loadLocalJsonData(fileName: String, fileType: String) -> Data?
}
