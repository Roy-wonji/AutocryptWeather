//
//  CityUseCase.swift
//  UseCase
//
//  Created by 서원지 on 8/10/24.
//

import Foundation
import Model
import ComposableArchitecture
import DiContainer

public struct CityUseCase: CityUseCaseProtocol {
    private let repository: CityRepositoryProtocol
    
    public init(
        repository: CityRepositoryProtocol
    ) {
        self.repository = repository
    }
    
    //MARK: - json 파일로 위치 정보 가져오기
    public func loadCities(page: Int, pageSize: Int, isShowAll: Bool) async throws -> CityModels? {
        try await repository.loadCities(page: page, pageSize: pageSize, isShowAll: isShowAll)
    }
    
    //MARK: - json 파일 파싱
    public func loadLocalJsonData(fileName: String, fileType: String) -> Data? {
        repository.loadLocalJsonData(fileName: fileName, fileType: fileType)
    }
}

extension  CityUseCase: DependencyKey {
    public static let liveValue: CityUseCase = {
        let cityRepository = DependencyContainer.live.resolve(CityRepositoryProtocol.self) ?? DefaultCityRepository()
        return CityUseCase(repository: cityRepository)
    }()
}
