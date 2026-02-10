import Foundation

protocol SavedPOIRepository {
    func fetchAll() throws -> [SavedPOI]
    func upsert(_ poi: POI) throws
    func delete(id: Int) throws
    func isSaved(id: Int) throws -> Bool
}
