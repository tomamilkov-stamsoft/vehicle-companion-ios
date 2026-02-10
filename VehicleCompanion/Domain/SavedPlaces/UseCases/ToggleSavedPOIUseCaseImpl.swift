import Foundation

protocol ToggleSavedPOIUseCase {
    func execute(_ poi: POI) throws
}

struct ToggleSavedPOIUseCaseImpl: ToggleSavedPOIUseCase {
    private let repository: SavedPOIRepository

    init(repository: SavedPOIRepository) {
        self.repository = repository
    }

    func execute(_ poi: POI) throws {
        if try repository.isSaved(id: poi.id) {
            try repository.delete(id: poi.id)
        } else {
            try repository.upsert(poi)
        }
    }
}
