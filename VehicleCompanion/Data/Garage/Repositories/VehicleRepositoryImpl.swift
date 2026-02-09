import Foundation
import SwiftData

enum VehicleRepositoryError: LocalizedError {
    case fetchFailed(String)
    case saveFailed(String)
    case deleteFailed(String)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return "Failed to fetch vehicles: \(message)"
        case .saveFailed(let message):
            return "Failed to save vehicle: \(message)"
        case .deleteFailed(let message):
            return "Failed to delete vehicle: \(message)"
        }
    }
}

@MainActor
final class VehicleRepositoryImpl: VehicleRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchVehicles() throws -> [Vehicle] {
        do {
            let descriptor = FetchDescriptor<VehicleRecord>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
            return try context.fetch(descriptor).map { $0.toDomain() }
        } catch {
            throw VehicleRepositoryError.fetchFailed(error.localizedDescription)
        }
    }

    func fetchVehicle(id: UUID) throws -> Vehicle? {
        do {
            return try find(by: id)?.toDomain()
        } catch let error as VehicleRepositoryError {
            throw error
        } catch {
            throw VehicleRepositoryError.fetchFailed(error.localizedDescription)
        }
    }

    func upsert(_ vehicle: Vehicle) throws {
        do {
            if let existing = try find(by: vehicle.id) {
                apply(vehicle, to: existing)
            } else {
                context.insert(makeRecord(from: vehicle))
            }
            try context.save()
        } catch let error as VehicleRepositoryError {
            throw error
        } catch {
            throw VehicleRepositoryError.saveFailed(error.localizedDescription)
        }
    }

    func delete(id: UUID) throws {
        do {
            if let vehicle = try find(by: id) {
                context.delete(vehicle)
                try context.save()
            }
        } catch let error as VehicleRepositoryError {
            throw error
        } catch {
            throw VehicleRepositoryError.deleteFailed(error.localizedDescription)
        }
    }

    private func find(by id: UUID) throws -> VehicleRecord? {
        do {
            let descriptor = FetchDescriptor<VehicleRecord>(predicate: #Predicate { $0.id == id })
            return try context.fetch(descriptor).first
        } catch {
            throw VehicleRepositoryError.fetchFailed(error.localizedDescription)
        }
    }

    private func apply(_ vehicle: Vehicle, to record: VehicleRecord) {
        record.nickname = vehicle.nickname
        record.make = vehicle.make
        record.model = vehicle.model
        record.year = vehicle.year
        record.vin = vehicle.vin
        record.fuelTypeRaw = vehicle.fuelType.rawValue
        record.heroImageData = vehicle.heroImageData
    }

    private func makeRecord(from vehicle: Vehicle) -> VehicleRecord {
        VehicleRecord(
            id: vehicle.id,
            nickname: vehicle.nickname,
            make: vehicle.make,
            model: vehicle.model,
            year: vehicle.year,
            vin: vehicle.vin,
            fuelTypeRaw: vehicle.fuelType.rawValue,
            heroImageData: vehicle.heroImageData,
            createdAt: vehicle.createdAt
        )
    }
}
