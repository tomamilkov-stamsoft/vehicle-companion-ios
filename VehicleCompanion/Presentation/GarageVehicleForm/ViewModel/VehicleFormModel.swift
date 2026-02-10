import Foundation

struct VehicleFormModel {
    var nickname: String = ""
    var make: String = ""
    var model: String = ""
    var year: Int = Calendar.current.component(.year, from: Date())
    var vin: String = ""
    var fuelType: FuelType = .gasoline
    var heroImageData: Data?

    init(vehicle: Vehicle? = nil) {
        guard let vehicle else { return }
        nickname = vehicle.nickname
        make = vehicle.make
        model = vehicle.model
        year = vehicle.year
        vin = vehicle.vin
        fuelType = vehicle.fuelType
        heroImageData = vehicle.heroImageData
    }

    var isValid: Bool {
        !nickname.trimmed().isEmpty && !make.trimmed().isEmpty && !model.trimmed().isEmpty && (1886...2100).contains(year)
    }

    func toVehicle(existingID: UUID?) -> Vehicle {
        Vehicle(
            id: existingID ?? UUID(),
            nickname: nickname.trimmed(),
            make: make.trimmed(),
            model: model.trimmed(),
            year: year,
            vin: vin.trimmed(),
            fuelType: fuelType,
            heroImageData: heroImageData,
            createdAt: Date()
        )
    }
}

private extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
