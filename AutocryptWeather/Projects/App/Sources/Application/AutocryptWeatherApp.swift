import SwiftUI
import ComposableArchitecture
import Presentation
import Foundations
import Model

@main
struct AutocryptWeatherApp: App {
    var cityModel: CityModels?
    var store = Store(initialState: Home.State()) {
        Home()
            ._printChanges()
            ._printChanges(.actionLabels)
    }
    var locationManger = LocationManger()
    public init() {
        registerDependencies()
        LocationManger.shared.checkAuthorizationStatus()

        
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(store: store)
//                .onAppear {
//                    store.send(.async(.fetchWeather(
//                        latitude: LocationManger.currentLocation?.latitude ?? .zero,
//                        longitude: LocationManger.currentLocation?.longitude ?? .zero
//                    )))
//                }
            
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
