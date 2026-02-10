import Foundation

protocol POIDataSource {
    func discoverPOIs(in bbox: BoundingBox, pageSize: Int) async throws -> [POI]
}
