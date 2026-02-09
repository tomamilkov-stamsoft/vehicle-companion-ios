import Foundation

enum HTTPError: LocalizedError, Equatable {
    case invalidRequest
    case invalidResponse
    case statusCode(Int)
    case transport(String)
    case decoding(String)

    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Invalid HTTP request."
        case .invalidResponse:
            return "Invalid HTTP response."
        case .statusCode(let code):
            return "Server returned status code \(code)."
        case .transport(let message):
            return "Transport error: \(message)"
        case .decoding(let message):
            return "Decoding error: \(message)"
        }
    }
}
