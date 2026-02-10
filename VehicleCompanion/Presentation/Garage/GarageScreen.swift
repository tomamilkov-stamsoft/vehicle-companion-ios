import SwiftUI

struct GarageScreen: View {
    @State private var viewModel: GarageViewModel
    @EnvironmentObject private var router: AppRouter

    init() {
        _viewModel = State(initialValue: ServiceLocator.required(GarageViewModel.self))
    }

    var body: some View {
        List {
            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            if viewModel.vehicles.isEmpty {
                ContentUnavailableView(
                    "No Vehicles Yet",
                    systemImage: "car",
                    description: Text("Add your first vehicle to start managing your garage.")
                )
                .listRowBackground(Color.clear)
            } else {
                ForEach(viewModel.vehicles) { vehicle in
                    VehicleRowView(vehicle: vehicle)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.didSelectVehicle(vehicle)
                        }
                }
                .onDelete(perform: viewModel.deleteVehicles)
            }
        }
        .navigationTitle("Garage")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.didTapAddVehicle()
                } label: {
                    Label("Add Vehicle", systemImage: "plus")
                }
            }
        }
        .task {
            viewModel.router = router
            viewModel.didAppear()
        }
    }
}

#Preview {
    NavigationStack {
        GarageScreen()
    }
}
