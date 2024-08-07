//
//  Extension+Data.swift
//  Utill
//
//  Created by 서원지 on 8/7/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

// Data 타입의 확장으로 공용 디코딩 함수 정의
extension Data {
    //MARK: -  async/ await 으로 디코딩
    func decoded<T: Decodable>(as type: T.Type) throws -> T {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: self)
        }
}

