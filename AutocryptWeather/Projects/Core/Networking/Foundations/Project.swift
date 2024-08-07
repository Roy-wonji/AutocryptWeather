import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin

let project = Project.makeAppModule(
    name: "Foundations",
    bundleId: .appBundleID(name: ".Foundations"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
        .sdk(name: "OSLog", type: .framework),
        .Networking(implements: .ThirdPartys),
    ],
    sources: ["Sources/**"]
)
