import SwiftUI

extension Route {
    @ViewBuilder
    func destination() -> some View {
        switch self {
        case .garage:
            GarageScreen()
        case .places:
            PlacesScreen()
        case let .garageVehicleForm(vehicleID):
            GarageVehicleFormScreen(vehicleID: vehicleID)
        case let .placeDetail(poi):
            PlacesDetailScreen(poi: poi)
        }
    }
}
