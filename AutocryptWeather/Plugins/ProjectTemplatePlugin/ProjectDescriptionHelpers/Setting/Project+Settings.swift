//
//  Project+Settings.swift
//  MyPlugin
//
//  Created by 서원지 on 8/7/24.
//

import Foundation
import ProjectDescription

extension Settings {
    public static let appMainSetting: Settings = .settings(
        base: SettingsDictionary()
            .setProductName(Project.Environment.appName)
            .setCFBundleDisplayName(Project.Environment.appName)
            .setMarketingVersion(.appVersion(version: "1.0.0"))
            .setASAuthenticationServicesEnabled()
            .setPushNotificationsEnabled()
            .setEnableBackgroundModes()
            .setArchs()
            .setOtherLdFlags()
            .setCurrentProjectVersion(.appBuildVersion())
            .setCodeSignIdentity()
            .setCodeSignStyle()
            .setVersioningSystem()
            .setDevelopmentTeam(Project.Environment.organizationTeamId)
            .setDebugInformationFormat(),
      
        
        configurations: [
            .debug(name: .debug, settings: SettingsDictionary()
                .setProductName(Project.Environment.appName)
                .setCFBundleDisplayName(Project.Environment.appName)
                .setOtherLdFlags("-ObjC -all_load")
                .setDebugInformationFormat("non-global")

            ),
            .debug(name: "QA", settings: SettingsDictionary()
                .setProductName(Project.Environment.appDevName)
                .setCFBundleDisplayName(Project.Environment.appDevName)
                .setOtherLdFlags("-ObjC -all_load")
                .setDebugInformationFormat("non-global")
                .setSkipInstall(false)
            ),
            .release(name: .release, settings: SettingsDictionary()
                .setProductName(Project.Environment.appName)
                .setCFBundleDisplayName(Project.Environment.appName)
                .setOtherLdFlags("-ObjC -all_load")
                .setDebugInformationFormat("non-global")
                .setSkipInstall(false)
            )
        ], defaultSettings: .recommended
    )
    
    public static func appBaseSetting(appName: String) -> Settings {
         let appBaseSetting: Settings = .settings(
            base: SettingsDictionary()
                .setProductName(appName)
                .setMarketingVersion(.appVersion())
                .setCurrentProjectVersion(.appBuildVersion())
                .setCodeSignIdentity()
                .setASAuthenticationServicesEnabled()
                .setArchs()
                .setVersioningSystem()
                .setDebugInformationFormat(),
            configurations: [
                .debug(name: .debug, settings: SettingsDictionary()
                    .setProductName(appName)
                    .setOtherLdFlags("-ObjC -all_load")
                    .setStripStyle()
                ),
                .debug(name: "QA", settings: SettingsDictionary()
                    .setProductName("\(appName)-QA")
                    .setOtherLdFlags("-ObjC -all_load")
                    .setStripStyle()
                       
                ),
                .release(name: .release, settings: SettingsDictionary()
                    .setProductName(appName)
                    .setOtherLdFlags("-ObjC -all_load")
                    .setStripStyle()
                         
                )
            ], defaultSettings: .recommended)
        
        return appBaseSetting
        
    }
    
    
}
