import SwiftUI

struct FlowRoutingView: View {
    @ObservedObject var router: FlowRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            router.rootRoute.destination()
                .navigationDestination(for: Route.self) { route in
                    route.destination()
                }
                .sheet(item: $router.sheetRouter, onDismiss: router.onDismissHandler) { sheetRouter in
                    FlowRoutingView(router: sheetRouter)
                        .presentationDragIndicator(.visible)
                }
                .fullScreenCover(item: $router.fullScreenRouter, onDismiss: router.onDismissHandler) { fullScreenRouter in
                    FlowRoutingView(router: fullScreenRouter)
                }
        }
    }
}
