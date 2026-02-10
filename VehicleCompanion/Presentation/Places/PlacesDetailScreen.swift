import MapKit
import SwiftUI

struct PlacesDetailScreen: View {
    private let poi: POI
    private let onToggleSaved: () -> Void
    @State private var isSaved: Bool

    init(poi: POI, isSaved: Bool, onToggleSaved: @escaping () -> Void) {
        self.poi = poi
        self.onToggleSaved = onToggleSaved
        _isSaved = State(initialValue: isSaved)
    }

    private var roundedRating: Int {
        let value = Int((poi.rating ?? 0).rounded())
        return min(max(value, 0), 5)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RemoteThumbnailView(
                    url: poi.imageURL,
                    height: 220,
                    cornerRadius: 12
                )

                Text(poi.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)

                Text(poi.category)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < roundedRating ? "star.fill" : "star")
                            .foregroundStyle(.yellow)
                    }
                    Text(String(format: "%.1f", poi.rating ?? 0))
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Rating \(roundedRating) out of 5")

                Map(initialPosition: .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )) {
                    Marker(poi.name, coordinate: CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude))
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Toggle(isOn: Binding(
                    get: { isSaved },
                    set: { _ in
                        isSaved.toggle()
                        onToggleSaved()
                    }
                )) {
                    Text("Save for Later")
                }
                .toggleStyle(.switch)

                if let url = poi.url {
                    Link("Open in Browser", destination: url)
                        .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .navigationTitle("Place Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
