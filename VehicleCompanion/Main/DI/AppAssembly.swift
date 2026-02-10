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

        container.register(SavedPOIRepository.self) { resolver in
            SavedPOIRepositoryImpl(context: resolver.required(ModelContext.self))
        }
        .inObjectScope(.container)

        container.register(POIRepository.self) { resolver in
            POIRepositoryImpl(dataSource: resolver.required(POIDataSource.self))
        }
        .inObjectScope(.container)

        container.register(DiscoverPOIsUseCase.self) { resolver in
            DiscoverPOIsUseCaseImpl(repository: resolver.required(POIRepository.self))
        }
        .inObjectScope(.transient)

        container.register(GetSavedPOIsUseCase.self) { resolver in
            GetSavedPOIsUseCaseImpl(repository: resolver.required(SavedPOIRepository.self))
        }
        .inObjectScope(.transient)

        container.register(ToggleSavedPOIUseCase.self) { resolver in
            ToggleSavedPOIUseCaseImpl(repository: resolver.required(SavedPOIRepository.self))
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

        container.register(PlacesViewModel.self) { resolver in
            PlacesViewModel(
                discoverPOIsUseCase: resolver.required(DiscoverPOIsUseCase.self),
                getSavedPOIsUseCase: resolver.required(GetSavedPOIsUseCase.self),
                toggleSavedPOIUseCase: resolver.required(ToggleSavedPOIUseCase.self)
            )
        }
        .inObjectScope(.transient)
    }
}
