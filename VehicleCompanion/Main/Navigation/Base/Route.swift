import Foundation

enum Route: Hashable {
    case garage
    case places
    case garageVehicleForm(vehicleID: UUID?)
    case placeDetail(poi: POI)
}
