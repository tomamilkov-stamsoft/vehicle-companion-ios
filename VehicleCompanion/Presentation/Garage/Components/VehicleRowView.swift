import SwiftUI

struct VehicleRowView: View {
    let vehicle: Vehicle
    private var yearText: String { String(vehicle.year) }

    var body: some View {
        HStack(spacing: 12) {
            vehicleImage

            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.nickname)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                Text("\(vehicle.make) \(vehicle.model) • \(yearText)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(vehicle.nickname), \(vehicle.make) \(vehicle.model), year \(yearText)")
        .accessibilityHint("Tap to edit vehicle")
    }

    @ViewBuilder
    private var vehicleImage: some View {
        if let heroImageData = vehicle.heroImageData, let image = UIImage(data: heroImageData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 68, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        } else {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 68, height: 68)
                .overlay(Image(systemName: "car.fill").foregroundStyle(.secondary))
        }
    }
}
