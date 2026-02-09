import Foundation
import Testing
@testable import VehicleCompanion

private struct MockHTTPClient: HTTPClient {
    let result: Result<(data: Data, response: HTTPURLResponse), Error>

    func perform(_ request: HTTPRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        try result.get()
    }
}

private final class CapturingHTTPClient: HTTPClient {
    var lastRequest: HTTPRequest?
    var responseData: Data = Data("{}".utf8)
    var statusCode: Int = 200

    func perform(_ request: HTTPRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        lastRequest = request
        let response = HTTPURLResponse(
            url: try request.asURLRequest().url ?? URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        return (responseData, response)
    }
}

private struct TestEndpoint: APIEndpoint {
    let path: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]
    var body: Data? = nil
    var timeout: TimeInterval? = nil
    var cachePolicy: URLRequest.CachePolicy? = nil
}

private struct TestResponse: Decodable {
    let ok: Bool
}

struct HTTPNetworkingTests {
    @Test
    func requestBuildsURLAndHeaders() throws {
        let request = HTTPRequest(
            host: "api.example.com",
            path: "/v1/items",
            method: .get,
            queryItems: [URLQueryItem(name: "page", value: "1")],
            headers: ["Accept": "application/json"]
        )

        let urlRequest = try request.asURLRequest()

        #expect(urlRequest.url?.absoluteString == "https://api.example.com/v1/items?page=1")
        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test
    func mockClientCanReturnData() async throws {
        let payload = Data("{\"ok\":true}".utf8)
        let response = try #require(HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))

        let client = MockHTTPClient(result: .success((payload, response)))
        let request = await HTTPRequest(host: "api.example.com", path: "/")

        let result = try await client.perform(request)
        #expect(result.data == payload)
        #expect(result.response.statusCode == 200)
    }

    @Test
    func apiClientMergesDefaultsAndEndpointValues() async throws {
        let capturing = CapturingHTTPClient()
        capturing.responseData = Data("{\"ok\":true}".utf8)

        let client = await APIClient(
            httpClient: capturing,
            configuration: APIConfiguration(
                host: "api.example.com",
                basePath: "/v1",
                defaultHeaders: ["Accept": "application/json", "X-App": "Vehicle"],
                defaultQueryItems: [URLQueryItem(name: "lang", value: "en")],
                timeout: 25
            )
        )

        let endpoint = TestEndpoint(
            path: "/places",
            method: .get,
            queryItems: [URLQueryItem(name: "page", value: "1")],
            headers: ["X-App": "Override"]
        )

        let response: TestResponse = try await client.request(endpoint)

        #expect(response.ok == true)
        let captured = try #require(capturing.lastRequest)
        #expect(captured.path == "/v1/places")
        #expect(captured.headers["Accept"] == "application/json")
        #expect(captured.headers["X-App"] == "Override")
        #expect(captured.queryItems.count == 2)
        #expect(captured.timeout == 25)
    }

    @Test
    func apiClientMapsDecodingError() async {
        let capturing = CapturingHTTPClient()
        capturing.responseData = Data("{\"unexpected\":true}".utf8)

        let client = await APIClient(
            httpClient: capturing,
            configuration: APIConfiguration(host: "api.example.com")
        )

        do {
            _ = try await client.request(TestEndpoint(path: "/invalid"), as: TestResponse.self)
            Issue.record("Expected decoding failure")
        } catch let error as HTTPError {
            if case .decoding = error {
                #expect(true)
            } else {
                Issue.record("Expected decoding error, got \(error)")
            }
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
