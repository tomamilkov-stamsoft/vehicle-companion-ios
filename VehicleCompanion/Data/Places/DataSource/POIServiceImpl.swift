import Foundation

typealias POIServiceType = POIDataSource

struct POIServiceImpl: POIServiceType {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func discoverPOIs(in bbox: BoundingBox, pageSize: Int) async throws -> [POI] {
        do {
            let response = try await apiClient.request(
                DiscoverPOIsEndpoint(bbox: bbox, pageSize: pageSize),
                as: POIDiscoverResponseDTO.self
            )

            let pois = response.pois.map { $0.toDomain() }
            if pois.isEmpty {
                throw POIServiceError.emptyResponse
            }
            return pois
        } catch let error as HTTPError {
            switch error {
            case .invalidRequest:
                throw POIServiceError.invalidURL
            case .statusCode(let code):
                throw POIServiceError.server(code)
            case .decoding(let message):
                throw POIServiceError.decoding(message)
            case .transport(let message):
                throw POIServiceError.transport(message)
            case .invalidResponse:
                throw POIServiceError.transport("Invalid response")
            }
        } catch let error as POIServiceError {
            throw error
        } catch {
            throw POIServiceError.transport(error.localizedDescription)
        }
    }
}
