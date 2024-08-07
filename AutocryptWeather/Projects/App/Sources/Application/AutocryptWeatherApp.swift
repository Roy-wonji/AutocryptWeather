import SwiftUI
import ComposableArchitecture
import Presentation

@main
struct AutocryptWeatherApp: App {
    
    public init() {
        registerDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(
                store:
                    Store(
                        initialState: Home.State(),
                        reducer: {
                            Home()
                                ._printChanges()
                                ._printChanges(.actionLabels)
                        }
                    )
            )
        }
    }
}


extension AutocryptWeatherApp {
    private func registerDependencies() {
        Task {
            await AppDIContainer.shared.registerDependencies()
        }
    }
}
