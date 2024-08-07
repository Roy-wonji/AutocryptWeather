//
//  Protocol+FeatureAction.swift
//  Utill
//
//  Created by 서원지 on 8/7/24.
//

import Foundation
import ComposableArchitecture

public protocol FeatureAction {
  associatedtype ViewAction
  associatedtype InnerAction
  associatedtype AsyncAction
    associatedtype NavigationAction


  // NOTE: view 에서 사용되는 Action 을 정의합니다.
    static func view(_: ViewAction) -> Self
  // NOTE: 그 외 Reducer 내부적으로 사용되는 Action 을 정의합니다.
  static func inner(_: InnerAction) -> Self

  // NOTE: 비동기적으로 돌아가는 Action 을 정의합니다.
  static func async(_: AsyncAction) -> Self
    
    static func navigation(_: NavigationAction) -> Self

 
}
