import Foundation

protocol GetVehiclesUseCase {
    func execute() throws -> [Vehicle]
}

struct GetVehiclesUseCaseImpl: GetVehiclesUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute() throws -> [Vehicle] {
        try repository.fetchVehicles()
    }
}
