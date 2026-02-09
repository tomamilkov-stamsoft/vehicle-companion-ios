//
//  VehicleCompanionApp.swift
//  VehicleCompanion
//
//  Created by Toma Milkov on 9.02.26.
//

import SwiftUI

@main
struct VehicleCompanionApp: App {
    @StateObject private var appRouter = AppRouter()

    init() {
        registerDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView(router: appRouter)
                .environmentObject(appRouter)
        }
    }
}
