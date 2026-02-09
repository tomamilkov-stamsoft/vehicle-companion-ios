import SwiftUI

struct VehicleRowView: View {
    let vehicle: Vehicle

    var body: some View {
        HStack(spacing: 12) {
            vehicleImage

            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.nickname)
                    .font(.headline)
                Text("\(vehicle.make) \(vehicle.model) • \(vehicle.year)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(vehicle.nickname), \(vehicle.make) \(vehicle.model), \(vehicle.year)")
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
