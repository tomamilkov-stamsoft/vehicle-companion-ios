import Foundation

protocol GetSavedPOIsUseCase {
    func execute() throws -> [SavedPOI]
}

struct GetSavedPOIsUseCaseImpl: GetSavedPOIsUseCase {
    private let repository: SavedPOIRepository

    init(repository: SavedPOIRepository) {
        self.repository = repository
    }

    func execute() throws -> [SavedPOI] {
        try repository.fetchAll()
    }
}
