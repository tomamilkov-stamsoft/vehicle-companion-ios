import Foundation

protocol HTTPClientType {
    func perform(_ request: HTTPRequest) async throws -> (data: Data, response: HTTPURLResponse)
}
