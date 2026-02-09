import Swinject

// swiftlint:disable identifier_name
var ServiceLocator: Resolver {
    // swiftlint:enable identifier_name
    assembler.resolver
}

private let assembler = Assembler(
    [
        CoreAssembly(),
        NetworkingAssembly(),
        AppAssembly()
    ]
)

func registerDependencies() {
    _ = ServiceLocator
}

extension Resolver {
    func required<Service>(_ serviceType: Service.Type, name: String? = nil, file: StaticString = #fileID, line: UInt = #line) -> Service {
        guard let service = resolve(serviceType, name: name) else {
            fatalError("Missing DI registration for \(serviceType) at \(file):\(line)")
        }
        return service
    }
}
