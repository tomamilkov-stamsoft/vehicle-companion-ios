import Foundation
import Swinject
import SwiftData

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

        container.register(PersistenceStack.self) { _ in
            PersistenceStack()
        }
        .inObjectScope(.container)

        container.register(ModelContainer.self) { resolver in
            resolver.required(PersistenceStack.self).container
        }
        .inObjectScope(.container)

        container.register(ModelContext.self) { resolver in
            resolver.required(ModelContainer.self).mainContext
        }
        .inObjectScope(.container)
    }
}
