import Alamofire
import Foundation

struct HTTPClientImpl: HTTPClient {
    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func perform(_ request: HTTPRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let urlRequest = try request.asURLRequest()

        let afResponse = await session.request(urlRequest)
            .serializingData()
            .response

        if let afError = afResponse.error {
            throw HTTPError.transport(afError.localizedDescription)
        }

        guard let httpResponse = afResponse.response else {
            throw HTTPError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw HTTPError.statusCode(httpResponse.statusCode)
        }

        return (afResponse.data ?? Data(), httpResponse)
    }
}
