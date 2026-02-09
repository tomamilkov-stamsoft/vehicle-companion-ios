import Combine

enum TabTag {
    case garage
    case places
}

final class AppRouter: Router, ObservableObject {
    let garageRouter = FlowRouter(rootRoute: .garage)
    let placesRouter = FlowRouter(rootRoute: .places)

    @Published var selectedTabTag: TabTag = .garage {
        willSet {
            if newValue == selectedTabTag {
                currentTabRouter.popToRoot()
            }
        }
    }

    private var currentTabRouter: FlowRouter {
        switch selectedTabTag {
        case .garage:
            garageRouter
        case .places:
            placesRouter
        }
    }

    var topRouter: FlowRouter {
        var router = currentTabRouter

        while let modalRouter = router.sheetRouter ?? router.fullScreenRouter {
            router = modalRouter
        }

        return router
    }

    func push(_ route: Route) {
        topRouter.push(route)
    }

    func pop() {
        topRouter.pop()
    }

    func popToRoot() {
        topRouter.popToRoot()
    }

    func present(_ route: Route, as presentation: ModalPresentation, onDismiss: (() -> Void)?) {
        topRouter.present(route, as: presentation, onDismiss: onDismiss)
    }

    func dismiss() {
        topRouter.parentRouter?.dismiss()
    }

    func resetTab() {
        selectedTabTag = .garage
    }
}
