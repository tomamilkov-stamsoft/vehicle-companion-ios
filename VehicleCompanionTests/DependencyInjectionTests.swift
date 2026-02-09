import Testing
@testable import VehicleCompanion
internal import Swinject

struct DependencyInjectionTests {
    @Test
    func resolvesCoreDependenciesFromServiceLocator() {
        registerDependencies()

        let apiClient = ServiceLocator.resolve(APIClient.self)
        let httpClient = ServiceLocator.resolve(HTTPClient.self)

        #expect(apiClient != nil)
        #expect(httpClient != nil)
    }
}
