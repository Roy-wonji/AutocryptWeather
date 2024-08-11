//
//  CityRepository.swift
//  UseCase
//
//  Created by 서원지 on 8/10/24.
//

import Foundation

import Service
import Model
import Foundations

@Observable
public class CityRepository: CityRepositoryProtocol {
    
    public init() {}
    
    public func loadLocalJsonData(fileName: String, fileType: String) -> Data? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: fileType) {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                Log.error("에러 JSON 파싱 data: ", error)
            }
        }
        return nil
    }
    
    
    public func loadCities(page: Int, pageSize: Int = 20, isShowAll: Bool = false) async throws -> CityModels? {
        guard let jsonData = loadLocalJsonData(fileName: "cityList", fileType: "json") else {
                print("Error: No data found.")
                throw DataError.noData
            }

            do {
                let decodedCities = try JSONDecoder().decode(CityModels.self, from: jsonData)
                
                // Calculate the range for the current page
                let startIndex = page * pageSize
                let endIndex = min(startIndex + pageSize, decodedCities.count)
                if !isShowAll {
                    return decodedCities
                } else {
                    if startIndex < endIndex {
                        let paginatedCities = Array(decodedCities[startIndex..<endIndex])
                        Log.debug("파싱 성공 ", paginatedCities)
                        return paginatedCities
                    } else {
                        return [] // No more data to load
                    }
                }
                
                
            } catch {
                Log.error("디코딩 애러 JSON:", error)
                throw error
            }
    }
}

