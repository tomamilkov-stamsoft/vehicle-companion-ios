import SwiftUI

struct PlacesScreen: View {
    private enum PlacesViewMode: String, CaseIterable, Identifiable {
        case list = "List"
        case map = "Map"

        var id: String { rawValue }
    }

    @State private var viewModel = ServiceLocator.required(PlacesViewModel.self)
    @State private var viewMode: PlacesViewMode = .list
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Menu {
                    ForEach(PlacesViewModel.SortOption.allCases) { option in
                        Button {
                            bindableViewModel.sortOption = option
                        } label: {
                            if bindableViewModel.sortOption == option {
                                Label(option.rawValue, systemImage: "checkmark")
                            } else {
                                Text(option.rawValue)
                            }
                        }
                    }
                } label: {
                    Label("Sort: \(bindableViewModel.sortOption.rawValue)", systemImage: "arrow.up.arrow.down")
                }
                .accessibilityLabel("Sort places")
                .accessibilityValue(bindableViewModel.sortOption.rawValue)

                Toggle("Favorites", isOn: $bindableViewModel.favoritesOnly)
                    .toggleStyle(.switch)
            }
            .padding(.horizontal)

            Picker("View", selection: $viewMode) {
                ForEach(PlacesViewMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if viewModel.isLoading {
                ProgressView("Loading places...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage, viewModel.displayPOIs.isEmpty {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Could not load places",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage)
                    )
                    Button("Retry") {
                        Task { await viewModel.load() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else if viewModel.displayPOIs.isEmpty {
                ContentUnavailableView(
                    "No places available",
                    systemImage: "mappin.slash",
                    description: Text("Try again later or disable Favorites only.")
                )
            } else {
                if viewMode == .list {
                    List(viewModel.displayPOIs) { poi in
                        Button {
                            viewModel.didSelectPOI(poi)
                        } label: {
                            POIRowView(poi: poi, isSaved: viewModel.isSaved(poi))
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                } else {
                    PlacesMapView(
                        pois: viewModel.displayPOIs,
                        isSaved: viewModel.isSaved,
                        onDetail: viewModel.didSelectPOI
                    )
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Places")
        .task {
            viewModel.router = router
            await viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        PlacesScreen()
    }
}
