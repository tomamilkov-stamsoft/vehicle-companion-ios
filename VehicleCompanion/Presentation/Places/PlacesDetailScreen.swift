import MapKit
import SwiftUI

struct PlacesDetailScreen: View {
    @State private var viewModel: PlacesDetailViewModel

    init(poi: POI) {
        _viewModel = State(
            initialValue: ServiceLocator.required(
                PlacesDetailViewModel.self,
                argument: poi
            )
        )
    }

    private var roundedRating: Int {
        let value = Int((viewModel.poi.rating ?? 0).rounded())
        return min(max(value, 0), 5)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RemoteThumbnailView(
                    url: viewModel.poi.imageURL,
                    height: 220,
                    cornerRadius: 12
                )

                Text(viewModel.poi.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)

                Text(viewModel.poi.category)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < roundedRating ? "star.fill" : "star")
                            .foregroundStyle(.yellow)
                    }
                    Text(String(format: "%.1f", viewModel.poi.rating ?? 0))
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Rating \(roundedRating) out of 5")

                Map(initialPosition: .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: viewModel.poi.latitude, longitude: viewModel.poi.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )) {
                    Marker(viewModel.poi.name, coordinate: CLLocationCoordinate2D(latitude: viewModel.poi.latitude, longitude: viewModel.poi.longitude))
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Toggle(isOn: Binding(
                    get: { viewModel.isSaved },
                    set: { _ in
                        viewModel.toggleSaved()
                    }
                )) {
                    Text("Save for Later")
                }
                .toggleStyle(.switch)

                if let url = viewModel.poi.url {
                    Link("Open in Browser", destination: url)
                        .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .navigationTitle("Place Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Could not update saved state", isPresented: hasErrorAlertBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
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
