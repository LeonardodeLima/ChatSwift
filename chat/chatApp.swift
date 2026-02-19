import SwiftUI

@main
struct chatApp: App {

    @StateObject private var serviceContainer = ServiceContainer()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(serviceContainer)
        }
    }
}
