//
//  DefaultCityRepository.swift
//  UseCase
//
//  Created by 서원지 on 8/10/24.
//

import Foundation
import Model

final public class DefaultCityRepository: CityRepositoryProtocol {
   
    
    
    public init(){}
    
    public func loadCities(page: Int, pageSize: Int, isShowAll: Bool) async throws -> Model.CityModels? {
        return nil
    }
    
    public func loadLocalJsonData(fileName: String, fileType: String)  -> Data? {
        return nil
    }
}
