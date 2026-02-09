import Foundation

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var timeout: TimeInterval? { get }
    var cachePolicy: URLRequest.CachePolicy? { get }
}

extension APIEndpoint {
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem] { [] }
    var headers: [String: String] { [:] }
    var body: Data? { nil }
    var timeout: TimeInterval? { nil }
    var cachePolicy: URLRequest.CachePolicy? { nil }
}
