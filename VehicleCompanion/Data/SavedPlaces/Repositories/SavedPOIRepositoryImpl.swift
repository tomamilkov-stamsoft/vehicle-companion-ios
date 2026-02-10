import Foundation
import SwiftData

enum SavedPOIRepositoryError: LocalizedError {
    case fetchFailed(String)
    case saveFailed(String)
    case deleteFailed(String)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return "Failed to fetch saved places: \(message)"
        case .saveFailed(let message):
            return "Failed to save place: \(message)"
        case .deleteFailed(let message):
            return "Failed to delete place: \(message)"
        }
    }
}

@MainActor
final class SavedPOIRepositoryImpl: SavedPOIRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() throws -> [SavedPOI] {
        do {
            let descriptor = FetchDescriptor<SavedPOIRecord>(sortBy: [SortDescriptor(\.savedAt, order: .reverse)])
            return try context.fetch(descriptor).map { $0.toDomain() }
        } catch {
            throw SavedPOIRepositoryError.fetchFailed(error.localizedDescription)
        }
    }

    func upsert(_ poi: POI) throws {
        do {
            if let existing = try find(by: poi.id) {
                apply(poi, to: existing)
            } else {
                context.insert(makeRecord(from: poi))
            }
            try context.save()
        } catch let error as SavedPOIRepositoryError {
            throw error
        } catch {
            throw SavedPOIRepositoryError.saveFailed(error.localizedDescription)
        }
    }

    func delete(id: Int) throws {
        do {
            if let record = try find(by: id) {
                context.delete(record)
                try context.save()
            }
        } catch let error as SavedPOIRepositoryError {
            throw error
        } catch {
            throw SavedPOIRepositoryError.deleteFailed(error.localizedDescription)
        }
    }

    func isSaved(id: Int) throws -> Bool {
        do {
            return try find(by: id) != nil
        } catch let error as SavedPOIRepositoryError {
            throw error
        } catch {
            throw SavedPOIRepositoryError.fetchFailed(error.localizedDescription)
        }
    }

    private func find(by id: Int) throws -> SavedPOIRecord? {
        do {
            let targetID = id
            let descriptor = FetchDescriptor<SavedPOIRecord>(predicate: #Predicate { $0.id == targetID })
            return try context.fetch(descriptor).first
        } catch {
            throw SavedPOIRepositoryError.fetchFailed(error.localizedDescription)
        }
    }

    private func apply(_ poi: POI, to record: SavedPOIRecord) {
        record.name = poi.name
        record.category = poi.category
        record.rating = poi.rating
        record.imageURLString = poi.imageURL?.absoluteString
        record.urlString = poi.url?.absoluteString
        record.longitude = poi.longitude
        record.latitude = poi.latitude
    }

    private func makeRecord(from poi: POI) -> SavedPOIRecord {
        SavedPOIRecord(
            id: poi.id,
            name: poi.name,
            category: poi.category,
            rating: poi.rating,
            imageURLString: poi.imageURL?.absoluteString,
            urlString: poi.url?.absoluteString,
            longitude: poi.longitude,
            latitude: poi.latitude,
            savedAt: Date()
        )
    }
}
