//
//  Project+Enviorment.swift
//  MyPlugin
//
//  Created by 서원지 on 8/7/24.
//

import Foundation
import ProjectDescription

public extension Project {
    enum Environment {
        public static let appName = "Weather"
        public static let appDemoName = "Weather-Demo"
        public static let appDevName = "Weather-Dev"
        public static let deploymentTarget : ProjectDescription.DeploymentTargets = .iOS("17.0")
        public static let deploymentDestination: ProjectDescription.Destinations = [.iPhone]
        public static let organizationTeamId = "N94CS4N6VR"
        public static let bundlePrefix = "io.Autocrypt.Weather"
        public static let appVersion = "1.0.0"
        public static let mainBundleId = "io.Autocrypt.Weather"
    }
}
