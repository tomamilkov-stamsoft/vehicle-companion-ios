import Foundation

struct APIConfiguration {
    let scheme: String
    let host: String
    let basePath: String
    let defaultHeaders: [String: String]
    let defaultQueryItems: [URLQueryItem]
    let timeout: TimeInterval
    let cachePolicy: URLRequest.CachePolicy

    init(
        scheme: String = "https",
        host: String,
        basePath: String = "",
        defaultHeaders: [String: String] = ["Accept": "application/json"],
        defaultQueryItems: [URLQueryItem] = [],
        timeout: TimeInterval = 30,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.scheme = scheme
        self.host = host
        self.basePath = basePath
        self.defaultHeaders = defaultHeaders
        self.defaultQueryItems = defaultQueryItems
        self.timeout = timeout
        self.cachePolicy = cachePolicy
    }
}
