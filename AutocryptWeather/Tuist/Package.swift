// swift-tools-version: 5.9
#if swift(>=6.0)
@preconcurrency import PackageDescription
#else
import PackageDescription
#endif

#if TUIST

#if swift(>=6.0)
@preconcurrency import ProjectDescription
#else
import ProjectDescription
#endif

    let packageSettings = PackageSettings(
        productTypes: [
            :
        ], baseSettings: .settings(configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ])
    )
#endif

let package = Package(
    name: "AutocryptWeather",
    dependencies: [
        .package(url: "http://github.com/pointfreeco/swift-composable-architecture", from: "1.12.1"),
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", from: "1.1.0"),
        
    ]
)
