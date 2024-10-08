import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin

let infoPlist: [String: Plist.Value] = InfoPlistValues.generateInfoPlist()

let project = Project.makeAppModule(
    name: Project.Environment.appName,
    bundleId: .mainBundleID(),
    product: .app,
    settings: .appMainSetting,
    scripts: [],
    dependencies: [
        .Shared(implements: .Shareds),
        .Networking(implements: .Networkings),
        .Presentation(implements: .Presentation)
    ],
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    infoPlist: .extendingDefault(with: infoPlist)
    
)
