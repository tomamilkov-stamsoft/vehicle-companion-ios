import PhotosUI
import SwiftUI

struct GarageVehicleFormScreen: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel: GarageVehicleFormViewModel
    @State private var selectedPhotoItem: PhotosPickerItem?

    init(vehicleID: UUID?) {
        _viewModel = State(
            initialValue: ServiceLocator.required(
                GarageVehicleFormViewModel.self,
                argument: vehicleID
            )
        )
    }

    var body: some View {
        Form {
            vehicleSection
            heroImageSection
        }
        .navigationTitle(viewModel.navigationTitle)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: viewModel.cancel)
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: viewModel.save)
                    .disabled(!viewModel.isSaveEnabled)
            }
        }
        .alert("Could not save vehicle", isPresented: hasErrorAlertBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
        .task(id: selectedPhotoItem) {
            guard let selectedPhotoItem,
                  let data = try? await selectedPhotoItem.loadTransferable(type: Data.self) else { return }

            viewModel.didSelectPhotoData(data)
        }
        .task {
            viewModel.router = router
        }
    }

    private var vehicleSection: some View {
        @Bindable var bindableViewModel = viewModel

        return Section("Vehicle") {
            TextField("Nickname", text: $bindableViewModel.formModel.nickname)
            TextField("Make", text: $bindableViewModel.formModel.make)
            TextField("Model", text: $bindableViewModel.formModel.model)
            Stepper("Year: \(String(viewModel.formModel.year))", value: $bindableViewModel.formModel.year, in: 1886...2100)
            TextField("VIN", text: $bindableViewModel.formModel.vin)

            Picker("Fuel Type", selection: $bindableViewModel.formModel.fuelType) {
                ForEach(FuelType.allCases) { fuelType in
                    Text(fuelType.title).tag(fuelType)
                }
            }
        }
    }

    private var heroImageSection: some View {
        Section("Hero Image") {
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
            }

            if let heroImageData = viewModel.formModel.heroImageData,
               let image = UIImage(data: heroImageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    private var hasErrorAlertBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.errorMessage = nil
                }
            }
        )
    }
}
