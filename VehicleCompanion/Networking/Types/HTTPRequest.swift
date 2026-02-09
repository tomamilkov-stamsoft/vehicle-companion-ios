import Foundation

struct HTTPRequest: Equatable {
    let scheme: String
    let host: String
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Data?
    let timeout: TimeInterval
    let cachePolicy: URLRequest.CachePolicy

    init(
        scheme: String = "https",
        host: String,
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        timeout: TimeInterval = 30,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.timeout = timeout
        self.cachePolicy = cachePolicy
    }

    func asURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            throw HTTPError.invalidRequest
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.timeoutInterval = timeout
        request.cachePolicy = cachePolicy

        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
