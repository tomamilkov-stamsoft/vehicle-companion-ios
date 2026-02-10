import Foundation
import Testing
@testable import VehicleCompanion

private struct POIHTTPClientMock: HTTPClient {
    var responseData: Data
    var error: Error?
    var statusCode: Int = 200

    func perform(_ request: HTTPRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        if let error {
            throw error
        }
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        return (responseData, response)
    }
}

struct POIServiceTests {
    @Test
    @MainActor
    func serviceReturnsMappedPOIsOnSuccess() async throws {
        let json = """
        {
          "pois": [
            {
              "id": 42,
              "name": "Park",
              "url": "https://example.com",
              "primary_category_display_name": "Nature",
              "rating": 4,
              "v_320x320_url": "https://example.com/image.jpg",
              "loc": [-84.5, 39.1]
            }
          ]
        }
        """.data(using: .utf8)!

        let apiClient = APIClient(
            httpClient: POIHTTPClientMock(responseData: json, error: nil),
            configuration: APIConfiguration(host: "api2.roadtrippers.com", basePath: "/api/v2")
        )
        let service = POIServiceImpl(apiClient: apiClient)
        let pois = try await service.discoverPOIs(in: .candidateArea, pageSize: 50)

        #expect(pois.count == 1)
        #expect(pois[0].name == "Park")
        #expect(pois[0].longitude == -84.5)
    }

    @Test
    @MainActor
    func serviceMapsTransportFailure() async {
        let apiClient = APIClient(
            httpClient: POIHTTPClientMock(
                responseData: Data(),
                error: HTTPError.transport("offline")
            ),
            configuration: APIConfiguration(host: "api2.roadtrippers.com", basePath: "/api/v2")
        )
        let service = POIServiceImpl(
            apiClient: apiClient
        )

        do {
            _ = try await service.discoverPOIs(in: .candidateArea, pageSize: 50)
            Issue.record("Expected transport error")
        } catch let error as POIServiceError {
            if case .transport = error {
                #expect(true)
            } else {
                Issue.record("Unexpected POIServiceError: \(error)")
            }
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
