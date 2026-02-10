import Foundation

struct POIRepositoryImpl: POIRepository {
    private let dataSource: POIDataSource

    init(dataSource: POIDataSource) {
        self.dataSource = dataSource
    }

    func discoverPOIs(in bbox: BoundingBox, pageSize: Int) async throws -> [POI] {
        try await dataSource.discoverPOIs(in: bbox, pageSize: pageSize)
    }
}
