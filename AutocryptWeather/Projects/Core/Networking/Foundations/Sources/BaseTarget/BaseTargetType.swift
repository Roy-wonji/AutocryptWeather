//
//  BaseTargetType.swift
//  Foundations
//
//  Created by 서원지 on 8/8/24.
//

import Foundation
import Moya
import API

public protocol BaseTargetType: TargetType {}

extension BaseTargetType {
    public var baseURL: URL {
        return URL(string: BaseAPI.baseURL.baseAPIDesc)!
    }
    
    public var headers: [String : String]? {
        return APIHeader.baseHeader
    }
    
}
