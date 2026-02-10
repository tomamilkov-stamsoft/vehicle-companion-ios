import SwiftUI

struct TabBarView: View {
    @ObservedObject var router: AppRouter

    var body: some View {
        TabView(selection: $router.selectedTabTag) {
            FlowRoutingView(router: router.garageRouter)
                .tag(TabTag.garage)
                .tabItem {
                    Label("Garage", systemImage: "car.fill")
                }

            FlowRoutingView(router: router.placesRouter)
                .tag(TabTag.places)
                .tabItem {
                    Label("Places", systemImage: "map.fill")
                }
        }
    }
}
