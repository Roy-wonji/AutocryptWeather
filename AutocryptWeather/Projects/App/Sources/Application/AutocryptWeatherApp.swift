import SwiftUI
import ComposableArchitecture
import Presentation
import Foundations

@main
struct AutocryptWeatherApp: App {
    
    public init() {
        registerDependencies()
        LocationManger.shared.checkAuthorizationStatus(completion: {}, locationStatustOff: {})
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
