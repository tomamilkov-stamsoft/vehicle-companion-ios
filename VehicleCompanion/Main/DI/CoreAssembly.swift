import Foundation
import Swinject

struct CoreAssembly: Assembly {
    func assemble(container: Container) {
        container.register(JSONDecoder.self) { _ in
            JSONDecoder()
        }
        .inObjectScope(.container)

        container.register(JSONEncoder.self) { _ in
            JSONEncoder()
        }
        .inObjectScope(.container)
    }
}
