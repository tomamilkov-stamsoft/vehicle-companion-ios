import Foundation

protocol UpsertVehicleUseCase {
    func execute(_ vehicle: Vehicle) throws
}

struct UpsertVehicleUseCaseImpl: UpsertVehicleUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute(_ vehicle: Vehicle) throws {
        try repository.upsert(vehicle)
    }
}
