import Foundation
import SwiftData

@Model
final class VehicleRecord {
    @Attribute(.unique) var id: UUID
    var nickname: String
    var make: String
    var model: String
    var year: Int
    var vin: String
    var fuelTypeRaw: String
    @Attribute(.externalStorage) var heroImageData: Data?
    var createdAt: Date

    init(
        id: UUID,
        nickname: String,
        make: String,
        model: String,
        year: Int,
        vin: String,
        fuelTypeRaw: String,
        heroImageData: Data?,
        createdAt: Date
    ) {
        self.id = id
        self.nickname = nickname
        self.make = make
        self.model = model
        self.year = year
        self.vin = vin
        self.fuelTypeRaw = fuelTypeRaw
        self.heroImageData = heroImageData
        self.createdAt = createdAt
    }
}

extension VehicleRecord {
    func toDomain() -> Vehicle {
        Vehicle(
            id: id,
            nickname: nickname,
            make: make,
            model: model,
            year: year,
            vin: vin,
            fuelType: FuelType(rawValue: fuelTypeRaw) ?? .gasoline,
            heroImageData: heroImageData,
            createdAt: createdAt
        )
    }
}
