import Foundation

protocol GetVehicleByIDUseCase {
    func execute(id: UUID) throws -> Vehicle?
}

struct GetVehicleByIDUseCaseImpl: GetVehicleByIDUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute(id: UUID) throws -> Vehicle? {
        try repository.fetchVehicle(id: id)
    }
}
