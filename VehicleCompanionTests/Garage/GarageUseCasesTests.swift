import Foundation
import Testing
@testable import VehicleCompanion

private final class VehicleRepositorySpy: VehicleRepository {
    var vehiclesToReturn: [Vehicle] = []
    var upsertedVehicle: Vehicle?
    var deletedVehicleID: UUID?

    func fetchVehicles() throws -> [Vehicle] {
        vehiclesToReturn
    }

    func fetchVehicle(id: UUID) throws -> Vehicle? {
        vehiclesToReturn.first(where: { $0.id == id })
    }

    func upsert(_ vehicle: Vehicle) throws {
        upsertedVehicle = vehicle
    }

    func delete(id: UUID) throws {
        deletedVehicleID = id
    }
}

struct GarageUseCasesTests {
    @Test
    func getVehiclesUseCaseDelegatesToRepository() throws {
        let repo = VehicleRepositorySpy()
        repo.vehiclesToReturn = [
            Vehicle(
                id: UUID(),
                nickname: "Daily",
                make: "Toyota",
                model: "Corolla",
                year: 2020,
                vin: "VIN",
                fuelType: .gasoline,
                heroImageData: nil,
                createdAt: Date()
            )
        ]

        let useCase = GetVehiclesUseCaseImpl(repository: repo)
        let result = try useCase.execute()

        #expect(result.count == 1)
        #expect(result.first?.nickname == "Daily")
    }

    @Test
    @MainActor
    func upsertAndDeleteUseCasesDelegateToRepository() throws {
        let repo = VehicleRepositorySpy()
        let vehicle = Vehicle(
            id: UUID(),
            nickname: "Trip",
            make: "BMW",
            model: "X3",
            year: 2023,
            vin: "VIN-2",
            fuelType: .hybrid,
            heroImageData: nil,
            createdAt: Date()
        )

        try UpsertVehicleUseCaseImpl(repository: repo).execute(vehicle)
        #expect(repo.upsertedVehicle == vehicle)

        try DeleteVehicleUseCaseImpl(repository: repo).execute(id: vehicle.id)
        #expect(repo.deletedVehicleID == vehicle.id)
    }
}
