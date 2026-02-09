import Foundation

@MainActor
@Observable
final class GarageViewModel {
    private(set) var vehicles: [Vehicle] = []
    var errorMessage: String?

    weak var router: AppRouter?

    private let getVehiclesUseCase: GetVehiclesUseCase
    private let upsertVehicleUseCase: UpsertVehicleUseCase
    private let deleteVehicleUseCase: DeleteVehicleUseCase

    init(
        getVehiclesUseCase: GetVehiclesUseCase,
        upsertVehicleUseCase: UpsertVehicleUseCase,
        deleteVehicleUseCase: DeleteVehicleUseCase
    ) {
        self.getVehiclesUseCase = getVehiclesUseCase
        self.upsertVehicleUseCase = upsertVehicleUseCase
        self.deleteVehicleUseCase = deleteVehicleUseCase
    }

    func didAppear() {
        loadVehicles()
    }

    func didTapAddVehicle() {
        router?.present(.garageVehicleForm(vehicleID: nil), as: .sheet, onDismiss: { [weak self] in
            self?.didDismissVehicleForm()
            self?.loadVehicles()
        })
    }

    func didSelectVehicle(_ vehicle: Vehicle) {
        router?.present(.garageVehicleForm(vehicleID: vehicle.id), as: .sheet, onDismiss: { [weak self] in
            self?.didDismissVehicleForm()
            self?.loadVehicles()
        })
    }

    func didDismissVehicleForm() {
        // Reserved for cleanup hooks after modal dismissal.
    }

    private func loadVehicles() {
        do {
            vehicles = try getVehiclesUseCase.execute()
            if vehicles.isEmpty {
                errorMessage = nil
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveVehicle(_ vehicle: Vehicle) {
        do {
            try upsertVehicleUseCase.execute(vehicle)
            router?.dismiss()
            loadVehicles()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func dismissVehicleForm() {
        router?.dismiss()
    }

    func deleteVehicles(at offsets: IndexSet) {
        for offset in offsets {
            let id = vehicles[offset].id
            do {
                try deleteVehicleUseCase.execute(id: id)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        loadVehicles()
    }
}
