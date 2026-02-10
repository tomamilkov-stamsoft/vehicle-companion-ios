import SwiftData
import SwiftUI

@main
struct VehicleCompanionApp: App {
    @StateObject private var appRouter = AppRouter()
    private let modelContainer: ModelContainer

    init() {
        URLCacheConfigurator.configureDefault()

        registerDependencies()
        modelContainer = ServiceLocator.required(ModelContainer.self)
    }

    var body: some Scene {
        WindowGroup {
            TabBarView(router: appRouter)
                .environmentObject(appRouter)
        }
        .modelContainer(modelContainer)
    }
}
