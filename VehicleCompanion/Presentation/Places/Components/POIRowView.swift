import SwiftUI

struct POIRowView: View {
    let poi: POI
    let isSaved: Bool

    private var roundedRating: Int {
        let value = Int((poi.rating ?? 0).rounded())
        return min(max(value, 0), 5)
    }

    var body: some View {
        HStack(spacing: 12) {
            RemoteThumbnailView(
                url: poi.imageURL,
                width: 56,
                height: 56,
                cornerRadius: 8
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(poi.name)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                Text(poi.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < roundedRating ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                    }
                }
                .accessibilityLabel("Rating \(roundedRating) out of 5")
            }

            Spacer()

            if isSaved {
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(.blue)
                    .accessibilityLabel("Saved")
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(poi.name), \(poi.category)")
        .accessibilityValue("Rating \(roundedRating) out of 5\(isSaved ? ", saved" : "")")
        .accessibilityHint("Tap to open place details")
    }
}
