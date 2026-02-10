import Foundation
import Swinject

struct NetworkingAssembly: Assembly {
    func assemble(container: Container) {
        container.register(APIConfiguration.self) { _ in
            APIConfiguration(
                host: "api2.roadtrippers.com",
                basePath: "/api/v2",
                defaultHeaders: ["Accept": "application/json"]
            )
        }
        .inObjectScope(.container)

        container.register(HTTPClient.self) { _ in
            HTTPClientImpl()
        }
        .inObjectScope(.container)

        container.register(APIClient.self) { resolver in
            APIClient(
                httpClient: resolver.required(HTTPClient.self),
                configuration: resolver.required(APIConfiguration.self),
                decoder: resolver.required(JSONDecoder.self),
                encoder: resolver.required(JSONEncoder.self)
            )
        }
        .inObjectScope(.container)
    }
}
