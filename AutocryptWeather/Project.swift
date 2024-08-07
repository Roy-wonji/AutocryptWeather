import ProjectDescription

let project = Project(
    name: "AutocryptWeather",
    targets: [
        .target(
            name: "AutocryptWeather",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.AutocryptWeather",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["AutocryptWeather/Sources/**"],
            resources: ["AutocryptWeather/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "AutocryptWeatherTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.AutocryptWeatherTests",
            infoPlist: .default,
            sources: ["AutocryptWeather/Tests/**"],
            resources: [],
            dependencies: [.target(name: "AutocryptWeather")]
        ),
    ]
)
