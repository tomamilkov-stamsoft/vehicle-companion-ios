import Foundation

enum ModalPresentation {
    case sheet
    case fullScreenCover
}

protocol Router: AnyObject {
    func push(_ route: Route)
    func pop()
    func popToRoot()

    func present(_ route: Route, as presentation: ModalPresentation, onDismiss: (() -> Void)?)
    func dismiss()
    func resetTab()
}
