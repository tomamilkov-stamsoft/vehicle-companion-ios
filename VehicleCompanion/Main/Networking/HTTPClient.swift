import Foundation

protocol HTTPClient {
    func perform(_ request: HTTPRequest) async throws -> (data: Data, response: HTTPURLResponse)
}
