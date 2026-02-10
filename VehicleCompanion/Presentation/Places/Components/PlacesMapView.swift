import MapKit
import SwiftUI

struct PlacesMapView: View {
    let pois: [POI]
    let isSaved: (POI) -> Bool
    let onDetail: (POI) -> Void

    @State private var position: MapCameraPosition
    @State private var selectedPOIID: Int?

    init(
        pois: [POI],
        isSaved: @escaping (POI) -> Bool,
        onDetail: @escaping (POI) -> Void
    ) {
        self.pois = pois
        self.isSaved = isSaved
        self.onDetail = onDetail

        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: BoundingBox.candidateArea.swLat + (BoundingBox.candidateArea.neLat - BoundingBox.candidateArea.swLat) / 2,
                    longitude: BoundingBox.candidateArea.swLon + (BoundingBox.candidateArea.neLon - BoundingBox.candidateArea.swLon) / 2
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.06)
            )
        ))
    }

    private var selectedPOI: POI? {
        guard let selectedPOIID else { return nil }
        return pois.first(where: { $0.id == selectedPOIID })
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $position, selection: $selectedPOIID) {
                ForEach(pois) { poi in
                    Marker(poi.name, coordinate: CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude))
                        .tag(poi.id)
                }
            }
            .mapControlVisibility(.visible)

            if let selectedPOI {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(selectedPOI.name)
                            .font(.headline)
                            .lineLimit(2)
                        Text(selectedPOI.category)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    if isSaved(selectedPOI) {
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(.blue)
                    }

                    Button("Details") {
                        onDetail(selectedPOI)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding()
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Selected place \(selectedPOI.name), \(selectedPOI.category)")
                .accessibilityHint("Open details for this place")
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
