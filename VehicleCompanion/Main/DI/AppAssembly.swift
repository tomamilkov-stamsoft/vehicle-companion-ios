import Swinject
import SwiftData

struct AppAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VehicleRepository.self) { resolver in
            VehicleRepositoryImpl(context: resolver.required(ModelContext.self))
        }
        .inObjectScope(.container)

        container.register(GetVehiclesUseCase.self) { resolver in
            GetVehiclesUseCaseImpl(repository: resolver.required(VehicleRepository.self))
        }
        .inObjectScope(.transient)

        container.register(GetVehicleByIDUseCase.self) { resolver in
            GetVehicleByIDUseCaseImpl(repository: resolver.required(VehicleRepository.self))
        }
        .inObjectScope(.transient)

        container.register(UpsertVehicleUseCase.self) { resolver in
            UpsertVehicleUseCaseImpl(repository: resolver.required(VehicleRepository.self))
        }
        .inObjectScope(.transient)

        container.register(DeleteVehicleUseCase.self) { resolver in
            DeleteVehicleUseCaseImpl(repository: resolver.required(VehicleRepository.self))
        }
        .inObjectScope(.transient)

        container.register(GarageViewModel.self) { resolver in
            GarageViewModel(
                getVehiclesUseCase: resolver.required(GetVehiclesUseCase.self),
                upsertVehicleUseCase: resolver.required(UpsertVehicleUseCase.self),
                deleteVehicleUseCase: resolver.required(DeleteVehicleUseCase.self)
            )
        }
        .inObjectScope(.transient)

        container.register(GarageVehicleFormViewModel.self) { resolver, vehicleID in
            GarageVehicleFormViewModel(
                vehicleID: vehicleID,
                getVehicleByIDUseCase: resolver.required(GetVehicleByIDUseCase.self),
                upsertVehicleUseCase: resolver.required(UpsertVehicleUseCase.self)
            )
        }
        .inObjectScope(.transient)
    }
}
