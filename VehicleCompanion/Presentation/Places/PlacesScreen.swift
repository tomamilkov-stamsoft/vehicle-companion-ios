import SwiftUI

struct PlacesScreen: View {
    @State private var viewModel = ServiceLocator.required(PlacesViewModel.self)

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
                List(viewModel.displayPOIs) { poi in
                    NavigationLink {
                        PlacesDetailScreen(
                            poi: poi,
                            isSaved: viewModel.isSaved(poi),
                            onToggleSaved: { viewModel.toggleSaved(poi) }
                        )
                    } label: {
                        POIRowView(poi: poi, isSaved: viewModel.isSaved(poi))
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Places")
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        PlacesScreen()
    }
}
