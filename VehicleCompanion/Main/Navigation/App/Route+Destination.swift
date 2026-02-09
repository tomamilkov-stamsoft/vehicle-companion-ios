import SwiftUI

extension Route {
    @ViewBuilder
    func destination() -> some View {
        switch self {
        case .garage:
            GarageScreen()
        case .places:
            PlacesScreen()
        }
    }
}
