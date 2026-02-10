import Foundation

protocol VehicleRepository {
    func fetchVehicles() throws -> [Vehicle]
    func fetchVehicle(id: UUID) throws -> Vehicle?
    func upsert(_ vehicle: Vehicle) throws
    func delete(id: UUID) throws
}
