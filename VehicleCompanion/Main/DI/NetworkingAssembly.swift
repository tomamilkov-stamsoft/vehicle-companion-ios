import Foundation
import Swinject

struct NetworkingAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HTTPClient.self) { _ in
            HTTPClientImpl()
        }
        .inObjectScope(.container)

        container.register(APIClient.self, name: DIName.roadtrippersAPIClient.rawValue) { resolver in
            APIClient(
                httpClient: resolver.required(HTTPClient.self),
                configuration: APIConfiguration(
                    host: "api2.roadtrippers.com",
                    basePath: "/api/v2",
                    defaultHeaders: ["Accept": "application/json"]
                ),
                decoder: resolver.required(JSONDecoder.self),
                encoder: resolver.required(JSONEncoder.self)
            )
        }
        .inObjectScope(.container)

        container.register(POIDataSource.self) { resolver in
            POIServiceImpl(apiClient: resolver.required(APIClient.self, name: DIName.roadtrippersAPIClient.rawValue))
        }
        .inObjectScope(.container)
    }
}
