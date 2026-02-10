import Foundation

@MainActor
@Observable
final class GarageVehicleFormViewModel {
    private let vehicle: Vehicle?
    private let upsertVehicleUseCase: UpsertVehicleUseCase

    var formModel: VehicleFormModel
    var errorMessage: String?
    weak var router: AppRouter?

    init(
        vehicleID: UUID?,
        getVehicleByIDUseCase: GetVehicleByIDUseCase,
        upsertVehicleUseCase: UpsertVehicleUseCase
    ) {
        if let vehicleID {
            self.vehicle = try? getVehicleByIDUseCase.execute(id: vehicleID)
        } else {
            self.vehicle = nil
        }

        self.upsertVehicleUseCase = upsertVehicleUseCase
        self.formModel = VehicleFormModel(vehicle: self.vehicle)
    }

    var navigationTitle: String {
        vehicle == nil ? "Add Vehicle" : "Edit Vehicle"
    }

    var isSaveEnabled: Bool {
        formModel.isValid
    }

    func didSelectPhotoData(_ data: Data) {
        formModel.heroImageData = ImageCompression.compressJPEG(data)
    }

    func save() {
        do {
            try upsertVehicleUseCase.execute(formModel.toVehicle(existingID: vehicle?.id))
            errorMessage = nil
            router?.dismiss()
        } catch {
            errorMessage = UserErrorMessageMapper.message(for: error)
        }
    }

    func cancel() {
        router?.dismiss()
    }
}
