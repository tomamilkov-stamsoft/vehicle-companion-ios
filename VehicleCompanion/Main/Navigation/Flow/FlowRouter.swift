import Combine

final class FlowRouter: Router, ObservableObject, Identifiable {
    let rootRoute: Route

    @Published var path: [Route] = []
    @Published var sheetRouter: FlowRouter?
    @Published var fullScreenRouter: FlowRouter?

    var topRoute: Route {
        path.last ?? rootRoute
    }

    weak var parentRouter: FlowRouter?

    private var onDismiss: (() -> Void)?

    init(rootRoute: Route) {
        self.rootRoute = rootRoute
    }

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func popToRoot() {
        path.removeAll()
    }

    func present(_ route: Route, as presentation: ModalPresentation, onDismiss: (() -> Void)?) {
        let router = FlowRouter(rootRoute: route)
        router.parentRouter = self
        self.onDismiss = onDismiss

        switch presentation {
        case .sheet:
            sheetRouter = router
        case .fullScreenCover:
            fullScreenRouter = router
        }
    }

    func dismiss() {
        if sheetRouter != nil {
            sheetRouter = nil
        } else if fullScreenRouter != nil {
            fullScreenRouter = nil
        }
    }

    func onDismissHandler() {
        onDismiss?()
        onDismiss = nil
    }

    func resetTab() {}
}
