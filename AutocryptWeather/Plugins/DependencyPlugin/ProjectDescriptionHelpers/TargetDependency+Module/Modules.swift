//
//  Modules.swift
//  Plugins
//
//  Created by 서원지 on 8/7/24.
//

import Foundation
import ProjectDescription

public enum ModulePath {
    case Presentation(Presentations)
    case Core(Cores)
    case Networking(Networkings)
    case Shared(Shareds)
}

// MARK: FeatureModule
public extension ModulePath {
    enum Presentations: String, CaseIterable {
        case Presentation
        public static let name: String = "Presentation"
    }
}

//MARK: -  CoreMoudule
public extension ModulePath {
    enum Cores: String, CaseIterable {
        case Core
        case Authorization
        
        public static let name: String = "Core"
    }
}

//MARK: -  CoreDomainModule
public extension ModulePath {
    enum Networkings: String, CaseIterable {
        case API
        case Networkings
        case Model
        case Service
        case DiContainer
        case UseCase
        case Foundations
        case Utills
        case ThirdPartys
        
        
        public static let name: String = "Networking"
    }
}

public extension ModulePath {
    enum Shareds: String, CaseIterable {
        case Shareds
        case DesignSystem
        case Utill
        case ThirdParty
        
        public static let name: String = "Shared"
    }
}


