import Foundation

enum FuelType: String, CaseIterable, Codable, Identifiable {
    case gasoline
    case diesel
    case hybrid
    case electric

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }
}

struct Vehicle: Identifiable, Equatable {
    let id: UUID
    var nickname: String
    var make: String
    var model: String
    var year: Int
    var vin: String
    var fuelType: FuelType
    var heroImageData: Data?
    let createdAt: Date
}
