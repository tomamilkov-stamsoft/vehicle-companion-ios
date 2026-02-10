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

    func required<Service, Arg1>(
        _ serviceType: Service.Type,
        argument: Arg1,
        name: String? = nil,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Service {
        guard let service = resolve(serviceType, name: name, argument: argument) else {
            fatalError("Missing DI registration for \(serviceType) with argument \(Arg1.self) at \(file):\(line)")
        }
        return service
    }
}
