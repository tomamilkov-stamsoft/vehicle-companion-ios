import Foundation

protocol DeleteVehicleUseCase {
    func execute(id: UUID) throws
}

struct DeleteVehicleUseCaseImpl: DeleteVehicleUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute(id: UUID) throws {
        try repository.delete(id: id)
    }
}
