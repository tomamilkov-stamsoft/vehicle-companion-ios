import Foundation

struct APIClient {
    private let httpClient: HTTPClientType
    private let configuration: APIConfiguration
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        httpClient: HTTPClientType,
        configuration: APIConfiguration,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.httpClient = httpClient
        self.configuration = configuration
        self.decoder = decoder
        self.encoder = encoder
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint, as type: T.Type = T.self) async throws -> T {
        let result = try await httpClient.perform(buildRequest(from: endpoint))
        do {
            return try decoder.decode(type, from: result.data)
        } catch {
            throw HTTPError.decoding(error.localizedDescription)
        }
    }

    func requestVoid(_ endpoint: APIEndpoint) async throws {
        _ = try await httpClient.perform(buildRequest(from: endpoint))
    }

    func request(_ endpoint: APIEndpoint) async throws -> Data {
        let result = try await httpClient.perform(buildRequest(from: endpoint))
        return result.data
    }

    func encodeBody<T: Encodable>(_ value: T) throws -> Data {
        try encoder.encode(value)
    }

    private func buildRequest(from endpoint: APIEndpoint) -> HTTPRequest {
        let combinedHeaders = configuration.defaultHeaders.merging(endpoint.headers) { _, new in new }
        let combinedQuery = configuration.defaultQueryItems + endpoint.queryItems

        return HTTPRequest(
            scheme: configuration.scheme,
            host: configuration.host,
            path: configuration.basePath + endpoint.path,
            method: endpoint.method,
            queryItems: combinedQuery,
            headers: combinedHeaders,
            body: endpoint.body,
            timeout: endpoint.timeout ?? configuration.timeout,
            cachePolicy: endpoint.cachePolicy ?? configuration.cachePolicy
        )
    }
}
