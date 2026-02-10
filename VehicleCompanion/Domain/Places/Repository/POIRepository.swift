import Foundation

protocol POIRepository {
    func discoverPOIs(in bbox: BoundingBox, pageSize: Int) async throws -> [POI]
}

enum POIServiceError: LocalizedError, Equatable {
    case invalidURL
    case transport(String)
    case decoding(String)
    case server(Int)
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid places URL."
        case .transport(let message):
            return "Network error: \(message)"
        case .decoding(let message):
            return "Could not parse places response: \(message)"
        case .server(let code):
            return "Places server returned status code \(code)."
        case .emptyResponse:
            return "No places found for this area."
        }
    }
}
