import Foundation

protocol DiscoverPOIsUseCase {
    func execute(in bbox: BoundingBox, pageSize: Int) async throws -> [POI]
}

struct DiscoverPOIsUseCaseImpl: DiscoverPOIsUseCase {
    private let repository: POIRepository

    init(repository: POIRepository) {
        self.repository = repository
    }

    func execute(in bbox: BoundingBox, pageSize: Int) async throws -> [POI] {
        try await repository.discoverPOIs(in: bbox, pageSize: pageSize)
    }
}
